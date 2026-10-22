import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:glicnote_app/data/api_client.dart';
import 'package:glicnote_app/data/app_repository.dart';
import 'package:glicnote_app/data/glucose_entry.dart';

void main() {
  test('Duplicate rule uses historical day and moment, regardless of glucose or insulin', () {
    final first = GlucoseEntry(value: 94, moment: 'Jejum', at: DateTime(2026, 10, 20, 7));
    expect(first.conflictsWith(GlucoseEntry(value: 150, insulinUnits: 2,
      moment: 'Jejum', at: DateTime(2026, 10, 20, 10))), isTrue);
    expect(first.conflictsWith(GlucoseEntry(value: 94,
      moment: 'Após café', at: DateTime(2026, 10, 20, 7))), isFalse);
    expect(first.conflictsWith(GlucoseEntry(value: 94,
      moment: 'Jejum', at: DateTime(2026, 10, 21, 7))), isFalse);
    expect(first.conflictsWith(GlucoseEntry(value: 100, moment: 'Jejum',
      at: DateTime(2026, 10, 21, 1), localDate: DateTime(2026, 10, 20))), isTrue);
  });

  test('Other allows multiple readings per day but never the same instant', () {
    final first = GlucoseEntry(value: 94, moment: 'Outro', at: DateTime.utc(2026, 10, 20, 10));
    expect(first.conflictsWith(GlucoseEntry(value: 150, moment: 'Outro',
      at: DateTime.utc(2026, 10, 20, 10, 0, 0, 0, 1))), isFalse);
    expect(first.conflictsWith(GlucoseEntry(value: 150, insulinUnits: 2, moment: 'Outro',
      at: DateTime.parse('2026-10-20T07:00:00-03:00'))), isTrue);
    expect(first.conflictsWith(GlucoseEntry(value: 94, moment: 'Jejum', at: first.at)), isFalse);
  });

  test('A slow startup retries profile reads automatically without requesting another login', () async {
    var calls = 0;
    final client = ApiClient(baseUrl: Uri.parse('https://api.example.test'),
      userId: () => 'alice', accessToken: () => 'saved-token', refreshSession: () async {},
      readTimeout: const Duration(milliseconds: 5),
      client: MockClient((request) async {
        calls++;
        if (calls == 1) await Future<void>.delayed(const Duration(milliseconds: 20));
        return http.Response('{"id":"alice"}', 200);
      }));
    expect((await client.request('GET', '/v1/me'))['id'], 'alice');
    expect(calls, 2);
    client.close();
  });

  test('Read retries are bounded and writes are never retried after a timeout', () async {
    for (final method in ['GET', 'POST']) {
      var calls = 0;
      final client = ApiClient(baseUrl: Uri.parse('https://api.example.test'),
        userId: () => 'alice', accessToken: () => 'token', refreshSession: () async {},
        client: MockClient((_) async { calls++; throw TimeoutException('offline'); }));
      await expectLater(client.request(method, '/v1/readings'), throwsA(isA<TimeoutException>()));
      expect(calls, method == 'GET' ? 3 : 1);
      client.close();
    }
  });

  test('An unavailable gateway retries a read then accepts a successful response', () async {
    var calls = 0;
    final client = ApiClient(baseUrl: Uri.parse('https://api.example.test'),
      userId: () => 'alice', accessToken: () => 'token', refreshSession: () async {},
      client: MockClient((_) async => ++calls == 1 ? http.Response('', 503) : http.Response('{}', 200)));
    await client.request('GET', '/v1/me');
    expect(calls, 2);
    client.close();
  });

  test('Expired token refreshes once and preserves the idempotent POST body', () async {
    var token = 'old';
    final bodies = <String>[];
    var calls = 0;
    final client = ApiClient(baseUrl: Uri.parse('http://localhost:8081'),
      userId: () => 'alice', accessToken: () => token,
      refreshSession: () async { token = 'new'; },
      client: MockClient((request) async {
        bodies.add(request.body);
        calls++;
        expect(request.headers['Authorization'], 'Bearer ${calls == 1 ? 'old' : 'new'}');
        return http.Response(calls == 1 ? '' : '{"ok":true}', calls == 1 ? 401 : 200);
      }));
    await client.request('POST', '/v1/readings', body: {'id': 'fixed-id', 'glucoseMgDl': 94});
    expect(calls, 2);
    expect(bodies[0], bodies[1]);
    client.close();
  });

  test('Account changes during refresh never replay a write for another user', () async {
    var user = 'alice';
    var calls = 0;
    final client = ApiClient(baseUrl: Uri.parse('http://localhost'), userId: () => user,
      accessToken: () => 'token', refreshSession: () async { user = 'bob'; },
      client: MockClient((_) async { calls++; return http.Response('', 401); }));
    await expectLater(client.request('POST', '/v1/readings', body: {'id': 'x'}),
      throwsA(isA<ApiFailure>()));
    expect(calls, 1);
    client.close();
  });

  test('History follows cursors so totals and filters include every page', () async {
    final client = ApiClient(baseUrl: Uri.parse('http://localhost'), userId: () => 'alice',
      accessToken: () => 'token', refreshSession: () async {},
      client: MockClient((request) async {
        final second = request.url.queryParameters['cursor'] == 'next';
        return http.Response(jsonEncode({'items': [{
          'id': second ? 'b' : 'a', 'version': 0, 'glucoseMgDl': second ? 110 : 94,
          'insulinUnits': second ? 2.5 : null, 'moment': 'fasting',
          'measuredAt': '2026-10-20T10:30:00Z',
        }], 'nextCursor': second ? null : 'next'}), 200);
      }));
    final entries = await AppRepository(client).readings();
    expect(entries.map((e) => e.id), ['a', 'b']);
    expect(entries.last.insulinUnits, 2.5);
    expect(entries.first.moment, 'Jejum');
    client.close();
  });

  test('A missing contact is empty; a failed service is an error', () async {
    var status = 404;
    final client = ApiClient(baseUrl: Uri.parse('http://localhost'), userId: () => 'alice',
      accessToken: () => 'token', refreshSession: () async {},
      client: MockClient((_) async => http.Response('{}', status)));
    expect(await AppRepository(client).contact(), isNull);
    status = 503;
    await expectLater(AppRepository(client).contact(), throwsA(isA<ApiFailure>()));
    client.close();
  });

  test('Reading payload uses stable moment codes and an absolute timestamp', () {
    final entry = GlucoseEntry(value: 94, moment: 'Após almoço',
      at: DateTime(2026, 10, 20, 12), insulinUnits: 2.5);
    final json = entry.toJson(requestId: 'fixed', timeZone: 'America/Sao_Paulo');
    expect(json['moment'], 'after_lunch');
    expect(json['insulinUnits'], 2.5);
    expect(DateTime.parse(json['measuredAt'] as String).isUtc, isTrue);
    expect(json.containsKey('userId'), isFalse);
  });
}

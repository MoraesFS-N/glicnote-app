import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glicnote_app/auth/supabase_login_controller.dart';
import 'package:glicnote_app/main.dart';

String token(int expiry) => '${base64Url.encode(utf8.encode('{"alg":"HS256"}'))}.${base64Url.encode(utf8.encode(jsonEncode({'exp': expiry, 'sub': 'alice'})))}.signature';
Map<String, dynamic> session(String accessToken) => {
  'access_token': accessToken, 'refresh_token': 'test-refresh',
  'token_type': 'bearer', 'expires_in': 3600,
  'user': {'id': 'alice', 'aud': 'authenticated', 'app_metadata': {},
    'user_metadata': {}, 'created_at': '2026-01-01T00:00:00Z'},
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const storageKey = 'sb-restore-test-auth-token';
  Future<Supabase> start(http.Client client) => Supabase.initialize(
    url: 'https://restore-test.supabase.co', publishableKey: 'public-test-key', debug: false,
    httpClient: client, authOptions: glicAuthOptions.copyWith(detectSessionInUri: false));

  test('A persisted session survives restart, and explicit logout removes it', () async {
    final access = token(DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600);
    SharedPreferences.setMockInitialValues({storageKey: jsonEncode(session(access))});
    final client = MockClient((_) async => http.Response('', 204));
    addTearDown(() async { await Supabase.instance.dispose(); });
    var supabase = await start(client);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(supabase.client.auth.currentUser?.id, 'alice');
    await supabase.dispose();
    supabase = await start(MockClient((_) async => http.Response('', 204)));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(supabase.client.auth.currentUser?.id, 'alice');
    await supabase.client.auth.signOut(scope: SignOutScope.local);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect((await SharedPreferences.getInstance()).containsKey(storageKey), isFalse);
    await supabase.dispose();
    supabase = await start(MockClient((_) async => http.Response('', 204)));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(supabase.client.auth.currentSession, isNull);
  });

  test('An expired persisted session refreshes before the private profile request', () async {
    final expired = token(DateTime.now().millisecondsSinceEpoch ~/ 1000 - 60);
    final renewed = token(DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600);
    SharedPreferences.setMockInitialValues({storageKey: jsonEncode(session(expired))});
    var refreshes = 0;
    final authHttp = MockClient((request) async {
      expect(request.url.path, '/auth/v1/token');
      refreshes++;
      return http.Response(jsonEncode(session(renewed)), 200,
        headers: {'content-type': 'application/json'});
    });
    addTearDown(() async { await Supabase.instance.dispose(); });
    final supabase = await start(authHttp);
    final controller = SupabaseLoginController(client: supabase.client,
      apiBaseUrl: Uri.parse('https://api.example.test'), redirectUrl: 'com.glicnote.app://login-callback',
      httpClient: MockClient((request) async {
        expect(request.headers['Authorization'], 'Bearer $renewed');
        return http.Response('{"id":"alice","name":"Alice"}', 200);
      }));
    expect((await controller.loadProfile()).id, 'alice');
    expect(refreshes, 1);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final stored = jsonDecode((await SharedPreferences.getInstance()).getString(storageKey)!);
    expect(stored['access_token'], renewed);
    controller.dispose();
  });
}

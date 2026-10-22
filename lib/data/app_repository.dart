import 'package:flutter_timezone/flutter_timezone.dart';
import '../auth/login_controller.dart';
import '../widgets/emergency_contact_sheet.dart';
import 'api_client.dart';
import 'glucose_entry.dart';

class AppRepository {
  AppRepository(this.api, {Future<String> Function()? deviceTimeZone})
    : deviceTimeZone = deviceTimeZone ?? (() async => (await FlutterTimezone.getLocalTimezone()).identifier);
  final Future<String> Function() deviceTimeZone;
  final _pendingZones = <String, String>{};
  final ApiClient api;

  Future<List<GlucoseEntry>> readings() async {
    final result = <GlucoseEntry>[];
    String? cursor;
    do {
      final page = await api.request('GET', '/v1/readings', query: {
        'limit': '50', if (cursor != null) 'cursor': cursor,
      }) as Map<String, dynamic>;
      result.addAll((page['items'] as List).map((e) => GlucoseEntry.fromJson(e as Map<String, dynamic>)));
      cursor = page['nextCursor'] as String?;
    } while (cursor != null);
    return result;
  }

  Future<GlucoseEntry> addReading(GlucoseEntry entry, String requestId) async {
    final zone = _pendingZones[requestId] ?? await deviceTimeZone();
    _pendingZones[requestId] = zone;
    final saved = GlucoseEntry.fromJson(await api.request('POST', '/v1/readings',
      body: entry.toJson(requestId: requestId, timeZone: zone)) as Map<String, dynamic>);
    _pendingZones.remove(requestId);
    return saved;
  }

  Future<LoginProfile> saveProfile(LoginProfile profile, String username,
    {required String timeZone, DateTime? birthDate, String? diabetesType}) async =>
    LoginProfile.fromJson(await api.request('PUT', '/v1/me', body: {
      // Kept unchanged for compatibility with older API deployments.
      'name': profile.name, 'username': username, 'timeZone': timeZone,
      'diabetesType': diabetesType,
      'birthDate': birthDate == null ? null
        : '${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}',
      'birthdayMonth': birthDate?.month ?? (profile.birthDate == null ? profile.birthdayMonth : null),
      'birthdayDay': birthDate?.day ?? (profile.birthDate == null ? profile.birthdayDay : null),
    }) as Map<String, dynamic>);

  Future<EmergencyContact?> contact() async {
    try {
      final json = await api.request('GET', '/v1/me/emergency-contact') as Map<String, dynamic>;
      return EmergencyContact(name: json['name'] as String, phone: json['phone'] as String,
        relationship: json['relationship'] as String? ?? '');
    } on ApiFailure catch (error) {
      if (error.status == 404) return null;
      rethrow;
    }
  }

  Future<void> saveContact(EmergencyContact contact) async {
    if (contact.name.isEmpty && contact.phone.isEmpty) {
      await api.request('DELETE', '/v1/me/emergency-contact');
    } else {
      await api.request('PUT', '/v1/me/emergency-contact', body: {
        'name': contact.name, 'phone': contact.phone.replaceAll(RegExp(r'[\s()\-]'), ''),
        'relationship': contact.relationship,
      });
    }
  }
}

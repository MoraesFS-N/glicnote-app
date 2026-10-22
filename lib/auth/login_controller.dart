import '../data/app_repository.dart';
import 'package:flutter/foundation.dart';

class LoginProfile {
  const LoginProfile({required this.id, required this.name, this.email, this.photoUrl, this.username, this.timeZone = 'UTC', this.birthdayMonth, this.birthdayDay, this.birthDate, this.diabetesType});
  final String id;
  final String name;
  final String? email;
  final String? photoUrl;
  final String? username;
  final String timeZone;
  final int? birthdayMonth;
  final int? birthdayDay;
  final DateTime? birthDate;
  final String? diabetesType;

  bool get needsRegistration => username == null || username!.trim().isEmpty;

  int? ageAt(DateTime today) {
    final birth = birthDate;
    if (birth == null || birth.isAfter(today)) return null;
    var age = today.year - birth.year;
    if (today.month < birth.month || (today.month == birth.month && today.day < birth.day)) age--;
    return age;
  }

  LoginProfile withRegistration({required String username, required String timeZone, DateTime? birthDate, String? diabetesType}) =>
    LoginProfile(id: id, name: name, email: email, photoUrl: photoUrl, username: username,
      timeZone: timeZone, birthDate: birthDate, diabetesType: diabetesType,
      birthdayMonth: birthDate?.month ?? (this.birthDate == null ? birthdayMonth : null),
      birthdayDay: birthDate?.day ?? (this.birthDate == null ? birthdayDay : null));

  factory LoginProfile.fromJson(Map<String, dynamic> json) => LoginProfile(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    email: json['email'] as String?,
    photoUrl: json['photoUrl'] as String?,
    username: json['username'] as String?,
    timeZone: json['timeZone'] as String? ?? 'UTC',
    birthdayMonth: json['birthdayMonth'] as int?,
    birthdayDay: json['birthdayDay'] as int?,
    diabetesType: json['diabetesType'] as String?,
    birthDate: json['birthDate'] == null ? null : DateTime.parse(json['birthDate'] as String),
  );
}

abstract class LoginController extends ChangeNotifier {
  AppRepository? get repository => null;
  bool get hasSession;
  String? get userId;
  bool get hasAuthError;
  Future<void> signInWithGoogle();
  Future<LoginProfile> loadProfile();
  Future<void> signOut();
}

class LoginFailure implements Exception {
  const LoginFailure();
}

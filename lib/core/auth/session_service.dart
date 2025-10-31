// lib/core/auth/session_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfile {
  final int? schoolId;
  final String? schoolCode;
  final int? gradeId;
  final String? grade;       // "10" | "11" | "12"
  final String? deviceId;

  const UserProfile({
    this.schoolId,
    this.schoolCode,
    this.gradeId,
    this.grade,
    this.deviceId,
  });
}

class SessionService {
  static const _kGuestId     = 'guest_id';
  static const _kGuestToken  = 'guest_token';   // opsional bila BE nanti menambah token
  static const _kSchoolId    = 'school_id';
  static const _kSchoolCode  = 'school_code';
  static const _kGradeId     = 'grade_id';
  static const _kGrade       = 'grade_str';
  static const _kDeviceId    = 'device_id';

  final FlutterSecureStorage _s = const FlutterSecureStorage();

  // ===== Guest creds =====
  Future<void> saveGuest({required int guestId, String? token}) async {
    await _s.write(key: _kGuestId, value: guestId.toString());
    if (token != null && token.isNotEmpty) {
      await _s.write(key: _kGuestToken, value: token);
    }
  }

  Future<int?> loadGuestId() async {
    final v = await _s.read(key: _kGuestId);
    return v == null ? null : int.tryParse(v);
    }

  Future<String?> loadGuestToken() => _s.read(key: _kGuestToken);

  Future<void> clearGuest() async {
    await _s.delete(key: _kGuestId);
    await _s.delete(key: _kGuestToken);
  }

  // ===== Profile (school/grade/device) =====
  Future<void> saveProfile({
    int? schoolId,
    String? schoolCode,
    int? gradeId,
    String? grade,
    String? deviceId,
  }) async {
    if (schoolId != null)   await _s.write(key: _kSchoolId, value: schoolId.toString());
    if (schoolCode != null) await _s.write(key: _kSchoolCode, value: schoolCode);
    if (gradeId != null)    await _s.write(key: _kGradeId, value: gradeId.toString());
    if (grade != null)      await _s.write(key: _kGrade, value: grade);
    if (deviceId != null)   await _s.write(key: _kDeviceId, value: deviceId);
  }

  Future<UserProfile> loadProfile() async {
    final sid = await _s.read(key: _kSchoolId);
    final sc  = await _s.read(key: _kSchoolCode);
    final gid = await _s.read(key: _kGradeId);
    final gs  = await _s.read(key: _kGrade);
    final dev = await _s.read(key: _kDeviceId);

    return UserProfile(
      schoolId: sid == null ? null : int.tryParse(sid),
      schoolCode: sc,
      gradeId: gid == null ? null : int.tryParse(gid),
      grade: gs,
      deviceId: dev,
    );
  }
}

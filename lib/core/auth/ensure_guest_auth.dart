// lib/core/auth/ensure_guest.dart
import 'package:uuid/uuid.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';
import 'package:sikap/core/auth/session_service.dart';

/// (Opsional) resolve school_code -> school_id.
/// Untuk sementara pakai fallback seed SMATS -> 12345.
Future<int> _resolveSchoolIdOrThrow(ApiClient api, String schoolCode) async {
  if (schoolCode.toUpperCase() == 'SMATS') return 12345;
  throw ApiException(
    message: "Belum ada resolver school_code → school_id untuk: $schoolCode",
    code: 400,
  );
}

/// Pastikan ada sesi guest.
/// - Ambil profil dari SessionService (schoolCode/grade/deviceId).
/// - Lengkapi schoolId/gradeId kalau perlu.
/// - Quick-login → simpan guest_id (+ guest_token jika ada).
Future<void> ensureGuestAuthenticated({
  int? schoolId,
  String? schoolCode,
  int? gradeId,
  String? gradeStr, // "10" | "11" | "12"
  String? deviceId,
}) async {
  final session = SessionService();
  final profile = await session.loadProfile();

  // Fast path: kalau sudah punya guest_id, selesai.
  final existingGid = await session.loadGuestId();
  if (existingGid != null) return;

  final api = ApiClient();

  // Lengkapi deviceId
  final dev = (deviceId ?? profile.deviceId ?? '').trim().isEmpty
      ? const Uuid().v4()
      : (deviceId ?? profile.deviceId!);

  // Lengkapi schoolId
  int? sid = schoolId ?? profile.schoolId;
  final scode = schoolCode ?? profile.schoolCode;
  if (sid == null) {
    if (scode == null || scode.trim().isEmpty) {
      throw ApiException(message: "Harap isi kode sekolah atau school_id.", code: 400);
    }
    sid = await _resolveSchoolIdOrThrow(api, scode.trim());
  }

  // Lengkapi gradeId
  int? gid = gradeId ?? profile.gradeId;
  if (gid == null) {
    final gs = (gradeStr ?? profile.grade ?? '').trim();
    if (gs.isEmpty) {
      throw ApiException(message: "Harap isi grade/grade_id.", code: 400);
    }
    gid = int.tryParse(gs);
    if (gid == null) {
      throw ApiException(message: "Grade harus numerik (mis. 10/11/12).", code: 400);
    }
  }

  // Simpan profil yang sudah lengkap
  await session.saveProfile(schoolId: sid, schoolCode: scode, gradeId: gid, deviceId: dev);

  // === QUICK-LOGIN STUDENT ===
  final payload = {
    "username": "g-$dev",
    "school_id": sid,
    "grade_id": gid,
    "device_id": dev,
  };

  final res = await api.post<Map<String, dynamic>>(
    "/api/accounts/student/quick-login/",
    payload,
    headers: const {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    expectEnvelope: false, // respons BE kamu bukan {success,data}
    transform: (raw) => Map<String, dynamic>.from(raw as Map),
  );

  // Contoh respons BE kamu:
  // {
  //   "guest_id": 5, "username": "g-dev-123", "school_id": 12345,
  //   "grade_id": 10, "device_id": "dev-123", "expires_at": "...",
  //   (opsional) "guest_token": "..." 
  // }
  final rawId = res.data['guest_id'];
  if (rawId == null) {
    throw ApiException(message: "guest_id tidak ada di respons BE.", code: 500);
  }
  final gId = (rawId is num) ? rawId.toInt() : int.tryParse(rawId.toString());
  if (gId == null) {
    throw ApiException(message: "guest_id bukan integer: $rawId", code: 500);
  }

  final token = res.data['guest_token'] ?? res.data['token'];
  await session.saveGuest(guestId: gId, token: token is String ? token : null);

  // ignore: avoid_print
  print("[GUEST] stored guest_id=$gId (device=$dev, school=$sid, grade=$gid)");
}

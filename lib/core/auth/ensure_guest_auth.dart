// lib/core/auth/ensure_guest_auth.dart
import 'package:uuid/uuid.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';
import 'package:sikap/core/auth/session_service.dart';

Future<void> ensureGuestAuthenticated({
  String? schoolCode,   // "SMATS"
  String? gradeStr,     // "10" | "11" | "12"
  String? deviceId,     // stabil
}) async {
  final session = SessionService();
  final profile = await session.loadProfile();

  // Fast-path: sudah punya guest_id
  final existingGid = await session.loadGuestId();
  if (existingGid != null) return;

  final api = ApiClient();

  // Lengkapi deviceId
  final dev = (deviceId ?? profile.deviceId ?? '').trim().isEmpty
      ? const Uuid().v4()
      : (deviceId ?? profile.deviceId!);

  // Validasi school_code
  final scode = (schoolCode ?? profile.schoolCode ?? '').trim().toUpperCase();
  if (scode.isEmpty) {
    throw ApiException(message: "Kode sekolah wajib diisi", code: 400);
  }

  // Parse grade
  final gstr = (gradeStr ?? profile.grade ?? '').trim();
  final grade = int.tryParse(gstr);
  if (grade == null) {
    throw ApiException(message: "Grade harus numerik (10/11/12).", code: 400);
  }

  // Persist agar konsisten antar layar
  await session.saveProfile(schoolCode: scode, grade: gstr, deviceId: dev);

  // Payload sesuai BE-mu
  final payload = {
    "school_code": scode,
    "grade": grade,
    "device_id": dev,
  };

  // Panggil API, payload bertipe Map<String,dynamic>
  final res = await api.post<Map<String, dynamic>>(
    "/api/accounts/student/quick-login/",
    payload,
    headers: const {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    expectEnvelope: false, // respons BE langsung objek (bukan envelope)
    transform: (raw) => Map<String, dynamic>.from(raw as Map),
  );

  // ⬇️ Ambil dari res.data, BUKAN res['...']
  final map = res.data;
  final rawId = map['guest_id'];
  final gId = (rawId is num) ? rawId.toInt() : int.tryParse(rawId.toString());
  if (gId == null) {
    throw ApiException(message: "guest_id tidak ditemukan/invalid", code: 500);
  }

  // BE saat ini tidak memberi token → simpan guest_id saja
  await session.saveGuest(guestId: gId, token: null);

  // ignore: avoid_print
  print("[GUEST] stored guest_id=$gId (device=$dev, school=$scode, grade=$grade)");
}

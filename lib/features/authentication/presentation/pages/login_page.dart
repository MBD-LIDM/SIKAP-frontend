// lib/features/authentication/login_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/auth/ensure_guest_auth.dart'; // pastikan file ini ada
import 'package:sikap/core/network/api_exception.dart';

import '../../../home/presentation/pages/home_page.dart';
import 'teacher_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _kodeSekolahController = TextEditingController();
  String? _selectedKelas;
  bool _loading = false;

  final List<String> _kelasList = const [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  @override
  void dispose() {
    _kodeSekolahController.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);

    final session = SessionService();
    try {
      // 1) Pastikan deviceId stabil
      final prof = await session.loadProfile();
      final deviceId =
          (prof.deviceId ?? '').isNotEmpty ? prof.deviceId! : const Uuid().v4();

      final schoolCode = _kodeSekolahController.text.trim(); // ex: "SMATS"
      final gradeStr = _selectedKelas!.trim(); // "10" | "11" | "12"

      print('[STUDENT_LOGIN] Starting login process');
      print('[STUDENT_LOGIN] Selected school_code: $schoolCode');
      print('[STUDENT_LOGIN] Selected grade: $gradeStr');
      print('[STUDENT_LOGIN] Device ID: $deviceId');
      print('[STUDENT_LOGIN] Current profile before save - schoolId: ${prof.schoolId}, schoolCode: ${prof.schoolCode}');

      // 2) Simpan profil (opsional tapi berguna untuk layar lain)
      await session.saveProfile(
        schoolCode: schoolCode,
        grade:
            gradeStr, // tetap string; konversi ke int dilakukan di ensureGuestAuthenticated
        deviceId: deviceId,
      );
      
      final profileAfterSave = await session.loadProfile();
      print('[STUDENT_LOGIN] Profile after save - schoolId: ${profileAfterSave.schoolId}, schoolCode: ${profileAfterSave.schoolCode}');

      // 3) Quick-login sesuai kontrak BE:
      //    Request: {"school_code": "SMATS", "grade": 10, "device_id": "<uuid>"}
      await ensureGuestAuthenticated(
        schoolCode: schoolCode,
        gradeStr: gradeStr, // akan di-parse ke int di helper
        deviceId: deviceId,
      );
      
      // Verify final state
      final finalProfile = await session.loadProfile();
      final finalGuestId = await session.loadGuestId();
      print('[STUDENT_LOGIN] ✅ Login complete');
      print('[STUDENT_LOGIN] Final state - guestId: $finalGuestId, schoolId: ${finalProfile.schoolId}, schoolCode: ${finalProfile.schoolCode}');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on ApiException catch (e) {
      // Tampilkan field errors bila ada
      final hint = e.errors == null
          ? e.message
          : e.errors!.entries.map((kv) => "${kv.key}: ${kv.value}").join("\n");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(hint), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('[STUDENT_LOGIN] ❌ Error during login: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Upper white section with logo
              Container(
                width: double.infinity,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Column(
                  children: [
                    // Logo
                    Container(
                      width: 180,
                      height: 180,
                      child: Image.asset(
                        'assets/icons/sikap_icon.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Lower blue section with form
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFF0066CC)),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Selamat Datang',
                      style: GoogleFonts.abrilFatface(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          const Icon(Icons.person_outline,
                              color: Color(0xFF0066CC)),
                          Text(
                            'Anda sedang login sebagai siswa',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: const Color(0xFF0066CC),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tombol login guru/kepsek
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TeacherLoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB678FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_outline),
                            const SizedBox(width: 8),
                            Text(
                              'Klik untuk login sebagai\nGuru/Kepala Sekolah',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kode Sekolah
                            Text(
                              'Kode Sekolah',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _kodeSekolahController,
                              validator: _required,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                hintText: "mis. SMATS",
                              ),
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Kelas
                            Text(
                              'Kelas',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedKelas,
                                validator: (v) =>
                                    v == null ? 'Wajib diisi' : null,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                hint: Text(
                                  'Pilih Kelas',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                icon:
                                    const Icon(Icons.arrow_drop_down, size: 30),
                                dropdownColor: Colors.white,
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                items: _kelasList
                                    .map((kelas) => DropdownMenuItem<String>(
                                          value: kelas,
                                          child: Text('Kelas $kelas'),
                                        ))
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedKelas = val),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Tombol Login
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFDBB6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: _loading
                                    ? const CircularProgressIndicator(
                                        color: Color(0xFF0066CC))
                                    : Text(
                                        'Login',
                                        style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0066CC),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            Center(
                              child: Text(
                                '© 2025 SIKAP.  All rights reserved.',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

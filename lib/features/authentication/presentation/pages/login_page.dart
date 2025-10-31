import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/auth/ensure_guest_auth.dart';      // <— penting
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

  final List<String> _kelasList = const ['10', '11', '12'];

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
      // deviceId stabil: ambil existing; kalau kosong generate
      final prof = await session.loadProfile();
      final deviceId =
          (prof.deviceId ?? '').isNotEmpty ? prof.deviceId! : const Uuid().v4();

      // Simpan profil dari form
      await session.saveProfile(
        schoolCode: _kodeSekolahController.text.trim(), // contoh "SMATS"
        grade: _selectedKelas!.trim(),                  // "10" | "11" | "12"
        deviceId: deviceId,
      );

      // Quick-login → simpan guest_id/token di SessionService
      await ensureGuestAuthenticated();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on ApiException catch (e) {
      final hint = e.errors == null
          ? e.message
          : e.errors!.entries.map((kv) => "${kv.key}: ${kv.value}").join("\n");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(hint), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
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
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Column(
                  children: [
                    // Logo
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFDBB6),
                          width: 4,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/sikap_icon.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SIKAP',
                      style: GoogleFonts.abrilFatface(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A4A7D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sistem Informasi Kelola Asa dan Pelaporan',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: const Color(0xFFE07B8A),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Lower blue section with form
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFF0066CC)),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Text(
                          'Login sebagai\nGuru/Kepala Sekolah',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
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
                    Text(
                      'Anda sedang login sebagai siswa',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),

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
                                validator: (v) => v == null ? 'Wajib diisi' : null,
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
                                icon: const Icon(Icons.arrow_drop_down, size: 30),
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
                                onChanged: (val) => setState(() => _selectedKelas = val),
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
                                    ? const CircularProgressIndicator(color: Color(0xFF0066CC))
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

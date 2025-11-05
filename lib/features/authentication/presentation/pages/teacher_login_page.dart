import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/presentation/pages/home_teacher_page.dart';
import 'login_page.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';

class TeacherLoginPage extends StatefulWidget {
  const TeacherLoginPage({super.key});

  @override
  State<TeacherLoginPage> createState() => _TeacherLoginPageState();
}

class _TeacherLoginPageState extends State<TeacherLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SessionService _session = SessionService();
  final ApiClient _api = ApiClient();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (_usernameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan password wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final payload = {
        'username': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      print('[TEACHER_LOGIN] Starting login for username: ${payload['username']}');

      final response = await _api.post<Map<String, dynamic>>(
        '/api/accounts/user/login/',
        payload,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        expectEnvelope: false, // Backend returns direct response, no envelope
        transform: (raw) => raw as Map<String, dynamic>,
      );

      // Parse direct response: {user_id, full_name, username, role_name, school_id, whatsapp_number}
      if (response.data is Map<String, dynamic>) {
        final userData = Map<String, dynamic>.from(response.data);
        
        print('[TEACHER_LOGIN] Login response received');
        print('[TEACHER_LOGIN] Response keys: ${userData.keys.toList()}');
        
        // Extract fields
        final userId = userData['user_id'];
        final roleName = userData['role_name']?.toString();
        final fullName = userData['full_name']?.toString();
        final schoolId = userData['school_id'];

        print('[TEACHER_LOGIN] User ID: $userId');
        print('[TEACHER_LOGIN] Role: $roleName');
        print('[TEACHER_LOGIN] Full Name: $fullName');
        print('[TEACHER_LOGIN] School ID: $schoolId');
        
        // CRITICAL: Validate school_id
        if (schoolId == null) {
          print('[TEACHER_LOGIN] ❌ CRITICAL ERROR: school_id is NULL in login response!');
          print('[TEACHER_LOGIN] ❌ This teacher cannot be associated with any school!');
          throw ApiException(
            message: 'User tidak terasosiasi dengan sekolah. Silakan hubungi administrator.',
            code: 400,
          );
        }

        // Extract sessionid from Set-Cookie header
        final setCookieHeader = response.headers?['set-cookie'];
        String? sessionId;
        
        if (setCookieHeader != null) {
          print('[TEACHER_LOGIN] Set-Cookie header found');
          // Parse: "sessionid=abc123; Path=/; HttpOnly"
          final sessionIdMatch = RegExp(r'sessionid=([^;]+)').firstMatch(setCookieHeader);
          sessionId = sessionIdMatch?.group(1);
        } else {
          print('[TEACHER_LOGIN] ⚠️ WARNING: Set-Cookie header not found in response');
          print('[TEACHER_LOGIN] Available headers: ${response.headers?.keys.toList()}');
        }
        
        if (sessionId == null || sessionId.isEmpty) {
          print('[TEACHER_LOGIN] ❌ ERROR: Session ID not found in response');
          throw ApiException(message: 'Session ID tidak ditemukan di response', code: 500);
        }

        final maskedSessionId = sessionId.length > 20 
            ? '${sessionId.substring(0, 10)}...${sessionId.substring(sessionId.length - 4)}'
            : '***';
        print('[TEACHER_LOGIN] Session ID extracted: $maskedSessionId');

        // Save sessionid as token for Android cookie management
        final schoolIdInt = schoolId is num 
            ? schoolId.toInt() 
            : int.tryParse(schoolId.toString());
            
        await _session.saveUserAuth(
          token: sessionId,
          userId: userId is num ? userId.toInt() : int.tryParse(userId?.toString() ?? ''),
          role: roleName,
          userName: fullName,
          schoolId: schoolIdInt,
        );

        // Verify what was saved
        final savedSchoolId = await _session.loadUserSchoolId();
        final savedUserId = await _session.loadUserId();
        final savedToken = await _session.loadUserToken();
        print('[TEACHER_LOGIN] ✅ Session saved successfully');
        print('[TEACHER_LOGIN] Verified - userId: $savedUserId, schoolId: $savedSchoolId, token present: ${savedToken != null && savedToken.isNotEmpty}');

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeTeacherPage()),
        );
      } else {
        throw ApiException(message: 'Response data tidak valid', code: 500);
      }
    } on ApiException catch (e) {
      print('[TEACHER_LOGIN] ❌ Login failed: ${e.message} (code: ${e.code})');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: ${e.message}'), backgroundColor: Colors.red),
      );
    } catch (e) {
      print('[TEACHER_LOGIN] ❌ Unexpected error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                decoration: const BoxDecoration(
                  color: Color(0xFF0066CC),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Selamat Datang text
                    Text(
                      'Selamat Datang',
                      style: GoogleFonts.abrilFatface(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Keterangan role aktif
                    Text(
                      'Anda sedang login sebagai guru/kepala sekolah',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
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
                          'Login sebagai Siswa',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),                    
                    const SizedBox(height: 24),
                    // Form fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          // Username
                          Text(
                            'Username',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _usernameController,
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
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Password
                          Text(
                            'Password',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
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
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFDBB6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                                      ),
                                    )
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
                          // Copyright text
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



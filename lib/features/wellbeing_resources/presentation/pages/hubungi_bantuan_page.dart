import 'package:flutter/material.dart';
import 'package:sikap/core/theme/app_theme.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/core/network/multipart_client.dart';

/// Simple DTO for counselor contact returned by the backend.
class CounselorContact {
  final int userId;
  final String fullName;
  final String whatsappNumber;
  final String schedule;

  CounselorContact({
    required this.userId,
    required this.fullName,
    required this.whatsappNumber,
    required this.schedule,
  });

  factory CounselorContact.fromJson(Map<String, dynamic> json) {
    return CounselorContact(
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse('${json['user_id']}') ?? 0,
      fullName: json['full_name']?.toString() ?? '',
      whatsappNumber: json['whatsapp_number']?.toString() ?? '',
      schedule: json['schedule']?.toString() ?? '',
    );
  }
}

class HubungiBantuanPage extends StatefulWidget {
  const HubungiBantuanPage({super.key});

  @override
  State<HubungiBantuanPage> createState() => _HubungiBantuanPageState();
}

class _HubungiBantuanPageState extends State<HubungiBantuanPage> {
  final ApiClient _api = ApiClient();
  final SessionService _session = SessionService();

  bool _loading = true;
  String? _error;
  List<CounselorContact> _counselors = [];

  @override
  void initState() {
    super.initState();
    _loadCounselors();
  }

  Future<void> _loadCounselors() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final profile = await _session.loadProfile();
      final schoolCode = profile.schoolCode;
      print('[DEBUG] School code: $schoolCode');
      if (schoolCode == null || schoolCode.isEmpty) {
        setState(() {
          _error = 'School code not set for current user.';
          _loading = false;
        });
        return;
      }

      final auth = AuthHeaderProvider(
        loadUserToken: () => _session.getToken(),
        loadGuestToken: () => _session.getGuestToken(),
        loadGuestId: () => _session.getGuestId(),
      );

      final headers =
          await auth.buildHeaders(asGuest: false); // pakai user login

      //  Ambil daftar sekolah dulu dengan headers
      final schoolResp = await _api.get<List<Map<String, dynamic>>>(
        '/api/accounts/schools/',
        headers: headers,
        expectEnvelope: false,
        transform: (json) {
          if (json is Map && json['results'] is List) {
            final raw = json['results'] as List;
            return raw.map((e) => Map<String, dynamic>.from(e)).toList();
          }
          return <Map<String, dynamic>>[];
        },
      );

      print(
          '[DEBUG] Parsed school codes: ${schoolResp.data.map((s) => s['school_code']).toList()}');
      print('[DEBUG] Total schools: ${schoolResp.data.length}');

      //  Cari sekolah yang cocok dengan schoolCode
      final matched = schoolResp.data.firstWhere(
        (s) =>
            s['school_code'].toString().toLowerCase() ==
            schoolCode.toLowerCase(),
        orElse: () => {},
      );

      if (matched.isEmpty) {
        setState(() {
          _error = 'Sekolah dengan kode $schoolCode tidak ditemukan.';
          _loading = false;
        });
        return;
      }

      final schoolId = matched['school_id'];
      print('[DEBUG] Ditemukan school_id: $schoolId untuk code $schoolCode');

      // Ambil data konselor berdasarkan school_id
      final resp = await _api.get<List<CounselorContact>>(
        '/api/accounts/counselors/contact-info/?school_id=$schoolId',
        headers: headers, // pake headers auth
        expectEnvelope: false,
        transform: (json) {
          if (json is Map && json['results'] is List) {
            final raw = json['results'] as List;
            return raw
                .map((e) =>
                    CounselorContact.fromJson(Map<String, dynamic>.from(e)))
                .toList();
          }
          return <CounselorContact>[];
        },
      );

      setState(() {
        _counselors = resp.data;
        _loading = false;
      });
    } catch (e, st) {
      print('[ERROR] $e\n$st');
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Segera Hadir'),
        content: const Text('Fitur ini akan segera hadir!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7F55B1), Color(0xFFFFDBB6)],
            stops: [0.76, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Title
                  Text('Hubungi Bantuan', style: AppTheme.headingLarge),
                  const SizedBox(height: 8),
                  Text('Kamu tidak sendiri', style: AppTheme.bodyLarge),
                  const SizedBox(height: 24),

                  const _SectionTitle('Kontak Konselor Sekolah'),
                  const SizedBox(height: 12),

                  // Loading / Error / List
                  if (_loading)
                    const Center(child: CircularProgressIndicator())
                  else if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Error: $_error',
                          style: const TextStyle(color: Colors.redAccent)),
                    )
                  else if (_counselors.isEmpty)
                    const Text('Tidak ada konselor tersedia untuk sekolah ini.',
                        style: TextStyle(color: Colors.white))
                  else
                    Column(
                      children: _counselors
                          .map((c) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _CounselorCard(
                                  name: c.fullName,
                                  role:
                                      'Konselor Sekolah', // role not provided by endpoint
                                  schedule: c.schedule,
                                  avatarAsset: 'assets/icons/sikap_icon.jpg',
                                  onChatTap: () => _showComingSoon(context),
                                ),
                              ))
                          .toList(),
                    ),

                  const SizedBox(height: 24),
                  const _SectionTitle('Layanan Nasional'),
                  const SizedBox(height: 12),

                  _NationalServiceCard(
                    title: 'Sahabat Perempuan\ndan Anak (SAPA)',
                    onCallTap: () => _showComingSoon(context),
                  ),

                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Center(
                      child: Text(
                        '© 2025 SIKAP. All rights reserved.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    );
  }
}

class _CounselorCard extends StatelessWidget {
  const _CounselorCard({
    required this.name,
    required this.role,
    required this.schedule,
    required this.avatarAsset,
    required this.onChatTap,
  });

  final String name;
  final String role;
  final String schedule;
  final String avatarAsset;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 32, backgroundImage: AssetImage(avatarAsset)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7F55B1),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF7F55B1)),
                ),
                const SizedBox(height: 8),
                Text(
                  schedule,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: onChatTap,
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('Chat dengan WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFDBB6),
                      foregroundColor: const Color(0xFF7F55B1),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NationalServiceCard extends StatelessWidget {
  const _NationalServiceCard({required this.title, required this.onCallTap});
  final String title;
  final VoidCallback onCallTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFFFE0CC),
            child: Icon(Icons.call, color: Color(0xFF7F55B1)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7F55B1),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onCallTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDBB6),
                    foregroundColor: const Color(0xFF7F55B1),
                    elevation: 0,
                  ),
                  child: const Text('Telepon 129'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

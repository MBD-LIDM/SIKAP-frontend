import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HubungiBantuanPage extends StatelessWidget {
  const HubungiBantuanPage({super.key});

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

                  _CounselorCard(
                    name: 'Gianpiero Lambiase',
                    role: 'Konselor SMP 5 Monte Carlo',
                    schedule: 'Jadwal: Senin 15.00–16.40\nKamis 15.00–16.40',
                    avatarAsset: 'assets/icons/sikap_icon.jpg',
                    onChatTap: () => _showComingSoon(context),
                  ),
                  const SizedBox(height: 16),
                  _CounselorCard(
                    name: 'Laura Mueller',
                    role: 'Konselor SMP 5 Monte Carlo',
                    schedule: 'Jadwal: Selasa 08.00–11.40\nJumat 15.00–16.40',
                    avatarAsset: 'assets/icons/sikap_icon.jpg',
                    onChatTap: () => _showComingSoon(context),
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
                  style: const TextStyle(fontSize: 12, color: Color(0xFF7F55B1)),
                ),
                const SizedBox(height: 8),
                Text(
                  schedule,
                  style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
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



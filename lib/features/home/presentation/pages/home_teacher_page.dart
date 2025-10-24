import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/feature_button_placeholder.dart';
import '../../../cases/presentation/pages/cases_list_page.dart';

class HomeTeacherPage extends StatefulWidget {
  const HomeTeacherPage({super.key});

  @override
  State<HomeTeacherPage> createState() => _HomeTeacherPageState();
}

class _HomeTeacherPageState extends State<HomeTeacherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7F55B1), // Purple at 76%
              Color(0xFFFFDBB6), // Light peach/orange at 100%
            ],
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
                  Text(
                    'Selamat Datang\ndi Dasbor Guru',
                    style: AppTheme.headingLarge,
                  ),
                  const SizedBox(height: 16),
                  // Subtitle
                  Text(
                    'Kelola kasus dan refleksi siswa dari satu tempat.',
                    style: AppTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  // Buttons Section
                  Column(
                    children: [
                      // Lihat Kasus Button - gunakan placeholder style
                      FeatureButtonPlaceholder(
                        title: 'Lihat Kasus',
                        subtitle: 'Tinjau dan kelola laporan siswa',
                        icon: Icons.folder_open,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CasesListPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Lihat Refleksi Siswa Button - placeholder style
                      FeatureButtonPlaceholder(
                        title: 'Lihat Refleksi Siswa',
                        subtitle: 'Pantau refleksi dan kemajuan emosi',
                        icon: Icons.insights,
                        onTap: () {
                          _showComingSoonDialog('Lihat Refleksi Siswa');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Bottom Section - Copyright
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Center(
                      child: Text(
                        '© 2025 SIKAP. All rights reserved.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feature),
          content: const Text('Fitur ini akan segera hadir!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}



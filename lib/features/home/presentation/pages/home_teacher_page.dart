import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/feature_button_placeholder.dart';
import '../../../cases/presentation/pages/case_list_page.dart';
import '../../../reflections/presentation/reflection_scenario.dart';
import 'package:sikap/features/reflections/presentation/reflection_list.dart';
import '../../../dashboard/presentation/dashboard_global.dart';
import '../../../authentication/presentation/pages/login_page.dart';
import 'package:sikap/core/auth/session_service.dart';

class HomeTeacherPage extends StatefulWidget {
  const HomeTeacherPage({super.key});

  @override
  State<HomeTeacherPage> createState() => _HomeTeacherPageState();
}

class _HomeTeacherPageState extends State<HomeTeacherPage> {
  final SessionService _session = SessionService();
  String? _role;
  bool _loadingRole = true;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final r = await _session.loadUserRole();
    if (!mounted) return;
    setState(() {
      _role = r;
      _loadingRole = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (_loadingRole) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFE7CE),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF7F55B1), // Purple at 76%
                Color(0xFFFFE7CE), // Soft cream at 100%
              ],
              stops: [0.76, 1.0],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    final isCounselor = (_role?.toLowerCase() == 'counselor');
    final isPrincipal = (_role?.toLowerCase() == 'principal');
    return Scaffold(
      backgroundColor: const Color(0xFFFFE7CE),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7F55B1), // Purple at 76%
              Color(0xFFFFE7CE), // Soft cream at 100%
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
                      if (!isCounselor && !isPrincipal || isPrincipal) ...[
                        FeatureButtonPlaceholder(
                          title: 'Dasbor Bullying',
                          subtitle: 'Insight laporan bullying sekolah',
                          icon: Icons.analytics,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardGlobalPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (!isPrincipal) ...[
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
                        FeatureButtonPlaceholder(
                          title: 'Lihat Refleksi Siswa',
                          subtitle: 'Pantau refleksi dan kemajuan emosi',
                          icon: Icons.insights,
                          onTap: () {
                            if (isCounselor) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReflectionListPage(
                                    scenarioTitle: 'Refleksi Siswa',
                                    scenarioDescription: 'Riwayat refleksi siswa di sekolah Anda',
                                    question: 'Daftar Refleksi',
                                    scenarioId: null,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReflectionScenarioPage(),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      FeatureButtonPlaceholder(
                        title: 'Log Out',
                        subtitle: '',
                        icon: Icons.logout,
                        isSettings: true,
                        backgroundColor: const Color(0xFFB678FF),
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        filled: true,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                            (route) => false,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
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
}



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sikap/features/bullying/presentation/pages/bullying_reports_list_page.dart';
import 'package:sikap/features/wellbeing_resources/presentation/pages/pojok_tenang_page.dart';
import 'package:sikap/features/authentication/presentation/pages/login_page.dart';
import '../widgets/feature_button_placeholder.dart';
import '../../../../core/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    'Tempat untuk Didengar',
                    style: AppTheme.headingLarge,
                  ),
                  const SizedBox(height: 16),
                  // Subtitle
                  Text(
                    'Aksi kecilmu dapat berdampak besar bagi dirimu sendiri maupun orang lain.',
                    style: AppTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  // Buttons Section
                  Column(
                    children: [
                      // Lapor Bullying Button - Full SVG
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BullyingReportsListPage(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 365 / 83,
                            child: SvgPicture.asset(
                              'assets/images/lapor_bullying.svg',
                              fit: BoxFit.contain,
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Pojok Tenang Button - Full SVG
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PojokTenangPage(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 365 / 83,
                            child: SvgPicture.asset(
                              'assets/images/pojok_tenang_button.svg',
                              fit: BoxFit.contain,
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Jejak Intervensi Button - Full SVG
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to intervention trail page
                          _showComingSoonDialog('Jejak Intervensi');
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 365 / 83,
                            child: SvgPicture.asset(
                              'assets/images/jejak_intervensi_button.svg',
                              fit: BoxFit.contain,
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Log Out Button
                      FeatureButtonPlaceholder(
                        title: 'Log Out',
                        subtitle: '', // Empty for logout
                        icon: Icons.logout,
                        isSettings: true,
                        backgroundColor: const Color(0xFFB678FF),
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        filled: true,
                        onTap: () {
                          // Navigate back to LoginPage and clear navigation stack
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                            (route) => false,
                          );
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

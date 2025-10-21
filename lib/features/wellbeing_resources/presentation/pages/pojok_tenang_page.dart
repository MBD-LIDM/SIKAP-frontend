import 'package:flutter/material.dart';
import 'artikel_info_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sikap/features/mood_check/presentation/pages/mood_check_page.dart';
import '../../../../core/theme/app_theme.dart';

class PojokTenangPage extends StatefulWidget {
  const PojokTenangPage({Key? key}) : super(key: key);

  @override
  State<PojokTenangPage> createState() => _PojokTenangPageState();
}

class _PojokTenangPageState extends State<PojokTenangPage> {
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60), // Space for back button
                  // Title
                  Text(
                    'Pojok Tenang',
                    style: AppTheme.headingLarge,
                  ),
                  const SizedBox(height: 16),
                  // Subtitle
                  Text(
                    'Temukan Ketenangan. Temukan Kekuatan.',
                    style: AppTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  // Buttons Section
                  Column(
                    children: [
                      // Hubungi Bantuan Button - Full SVG
                      GestureDetector(
                        onTap: () {
                          _showComingSoonDialog('Hubungi Bantuan');
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 365 / 83,
                            child: SvgPicture.asset(
                              'assets/images/hubungi_bantuan_button.svg',
                              fit: BoxFit.contain,
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Mood Check Button - Full SVG
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MoodCheckPage(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 365 / 83,
                            child: SvgPicture.asset(
                              'assets/images/mood_check_button.svg',
                              fit: BoxFit.contain,
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Artikel Info Button - Full SVG
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ArtikelInfoPage(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 365 / 83,
                            child: SvgPicture.asset(
                              'assets/images/artikel_info_button.svg',
                              fit: BoxFit.contain,
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
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
                  // Additional space to ensure scrolling
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
              // Custom Back Button
              Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
          title: Text('$feature'),
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'mood_check_recording_page.dart';
import '../../../../core/theme/app_theme.dart';

class MoodCheckPage extends StatefulWidget {
  const MoodCheckPage({Key? key}) : super(key: key);

  @override
  State<MoodCheckPage> createState() => _MoodCheckPageState();
}

class _MoodCheckPageState extends State<MoodCheckPage> {
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
                        'Mood Check',
                        style: AppTheme.headingLarge,
                      ),
                      const SizedBox(height: 16),
                      // Subtitle
                      Text(
                        'Di sini, kamu bisa berbicara dengan jujur tentang perasaanmu.',
                        style: AppTheme.bodyLarge,
                      ),
                      const SizedBox(height: 40),
                      // SVG Illustration - Centered
                      Center(
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: SvgPicture.asset(
                            'assets/images/mood_check_intro.svg',
                            fit: BoxFit.contain,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Paragraph
                      const Text(
                        'Ini adalah ruang yang aman untuk kamu mengekspresikan diri.\n\nRekaman suaramu bersifat rahasia dan hanya digunakan oleh sistem kami untuk menganalisis emosi.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      // Start Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MoodCheckRecordingPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF7F55B1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: SvgPicture.asset(
                                  'assets/icons/speak-ai-fill.svg',
                                  fit: BoxFit.contain,
                                  allowDrawingOutsideViewBox: true,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Mulai Berbicara',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
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

}

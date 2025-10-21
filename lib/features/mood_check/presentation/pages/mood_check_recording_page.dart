import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoodCheckRecordingPage extends StatefulWidget {
  const MoodCheckRecordingPage({Key? key}) : super(key: key);

  @override
  State<MoodCheckRecordingPage> createState() => _MoodCheckRecordingPageState();
}

class _MoodCheckRecordingPageState extends State<MoodCheckRecordingPage> {
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
                      const SizedBox(height: 80),
                      // Recording Status Text
                      const Text(
                        'Rekaman suara sedang berlangsung.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Instruction Text
                      const Text(
                        'Tekan ikon di bawah untuk menghentikan rekaman.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),
                      // Recording Button - Centered
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(60),
                              onTap: () {
                                _showStopRecordingDialog();
                              },
                              child: Center(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: SvgPicture.asset(
                                    'assets/icons/speak-ai-fill.svg',
                                    fit: BoxFit.contain,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
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

  void _showStopRecordingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hentikan Rekaman'),
          content: const Text('Apakah kamu yakin ingin menghentikan rekaman?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement stop recording logic
                _showComingSoonDialog('Analisis Selesai');
              },
              child: const Text('Hentikan'),
            ),
          ],
        );
      },
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

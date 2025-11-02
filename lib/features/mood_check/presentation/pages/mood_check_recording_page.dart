import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/auth/ensure_guest_auth.dart';
import 'package:sikap/core/network/multipart_client.dart';
import 'package:sikap/features/venting/data/repositories/venting_repository.dart';
import 'mood_check_result_page.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class MoodCheckRecordingPage extends StatefulWidget {
  const MoodCheckRecordingPage({super.key});

  @override
  State<MoodCheckRecordingPage> createState() => _MoodCheckRecordingPageState();
}

class _MoodCheckRecordingPageState extends State<MoodCheckRecordingPage> {
  bool _uploading = false;
  late final VentingRepository _repo;
  late final AudioRecorder _recorder;

  @override
  void initState() {
    super.initState();
    final multipart = MultipartClient();
    final session = SessionService();
    final auth = AuthHeaderProvider(
      loadUserToken: () async => null,
      loadGuestToken: () async => await session.loadGuestToken(),
      loadGuestId: () async => await session.loadGuestId(),
    );
    _repo = VentingRepository(multipartClient: multipart, auth: auth);
    _recorder = AudioRecorder();
    _startRecording();
  }

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
                              onTap:
                                  _uploading ? null : _showStopRecordingDialog,
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
                        color: Colors.black.withValues(alpha: 0.2),
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
              if (_uploading)
                Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 12),
                        Text('Mengunggah dan menganalisis...',
                            style: TextStyle(color: Colors.white)),
                      ],
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
                _stopAndAnalyze();
              },
              child: const Text('Hentikan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _stopAndAnalyze() async {
    if (_uploading) return;
    setState(() => _uploading = true);
    try {
      // Pastikan sesi guest siap agar X-Guest-Token tersedia
      await ensureGuestAuthenticated();

      final path = await _stopRecording();
      if (path == null || path.isEmpty) {
        throw Exception('Gagal mendapatkan file rekaman');
      }
      final audioFile = File(path);

      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] Start analyze upload: ${audioFile.path}');

      final result = await _repo.analyzeAudio(audioFile, asGuest: true);

      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] Analyze result received: keys=${result.keys.toList()}');
      if (kDebugMode) {
        try {
          // ignore: avoid_print
          print('[DEBUG] Analyze result full: ${jsonEncode(result)}');
        } catch (_) {
          // Fallback if result is not pure JSON-serializable
          // ignore: avoid_print
          print('[DEBUG] Analyze result full (toString): $result');
        }
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MoodCheckResultPage(result: result),
        ),
      );
    } catch (e, st) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('[DEBUG] Analyze failed: $e');
        // ignore: avoid_print
        print(st);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menganalisis: $e')),
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _startRecording() async {
    try {
      final hasPerm = await _recorder.hasPermission();
      if (!hasPerm) {
        // ignore: avoid_print
        print('[DEBUG] Microphone permission denied');
        return;
      }
      final dir = await getTemporaryDirectory();
      final filename = 'venting_${DateTime.now().millisecondsSinceEpoch}.wav';
      final path = '${dir.path}/$filename';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: path,
      );
      // ignore: avoid_print
      print('[DEBUG] Recording started');
    } catch (e) {
      // ignore: avoid_print
      print('[DEBUG] Failed to start recording: $e');
    }
  }

  Future<String?> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      // ignore: avoid_print
      print('[DEBUG] Recording stopped: $path');
      return path;
    } catch (e) {
      // ignore: avoid_print
      print('[DEBUG] Failed to stop recording: $e');
      return null;
    }
  }
}

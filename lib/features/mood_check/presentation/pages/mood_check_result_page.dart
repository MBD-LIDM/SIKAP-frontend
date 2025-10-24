import 'package:flutter/material.dart';

class MoodCheckResultPage extends StatelessWidget {
  const MoodCheckResultPage({super.key});

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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        'Hasil Analisis Emosi',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.2,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Score card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E4BA6).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Simple donut placeholder
                            SizedBox(
                              width: 88,
                              height: 88,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 88,
                                    height: 88,
                                    child: CircularProgressIndicator(
                                      value: 0.7,
                                      strokeWidth: 10,
                                      color: const Color(0xFFFFDBB6),
                                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                                    ),
                                  ),
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Row(
                                    children: [
                                      Icon(Icons.warning_amber, color: Color(0xFFFFDBB6), size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        '70% Sadness',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  _Legend(color: Colors.white, label: '20% Anxiety'),
                                  _Legend(color: Color(0xFFBFD4FF), label: '10% Calmness'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      const _SectionTitle('Hasil Analisis'),
                      const SizedBox(height: 12),

                      const Text(
                        'Sadness (Kesedihan) adalah emosi yang paling dominan. Ini bisa jadi berasal dari nada suara yang menurun, ritme bicara yang lambat, atau jeda yang lebih panjang saat kamu  berbicara.',
                        style: TextStyle(fontSize: 14, color: Colors.white, height: 1.6),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Sistem juga mendeteksi adanya Anxiety (Kecemasan) dengan probabilitas 20% dari tempo bicara yang sedikit tidak teratur atau variasi nada suara yang tidak stabil, meskipun tidak dominan.',
                        style: TextStyle(fontSize: 14, color: Colors.white, height: 1.6),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Sementara itu, Calmness (Ketenangan) hanya terdeteksi 10%. Ini menunjukkan bahwa meski ada unsur ketenangan, emosi tersebut tidak menjadi emosi utama dalam rekaman suaramu.',
                        style: TextStyle(fontSize: 14, color: Colors.white, height: 1.6),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hasil ini hanyalah wawasan teknis berdasarkan analisis suara, bukan diagnosis medis. Jika Anda merasa tertekan, kami sangat menganjurkan untuk berbicara dengan profesional kesehatan mental.',
                        style: TextStyle(fontSize: 13, color: Colors.white, height: 1.6, fontWeight: FontWeight.w700),
                      ),

                      const SizedBox(height: 24),
                      Center(
                        child: SizedBox(
                          width: 280,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF7F55B1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Kembali ke Homepage'),
                          ),
                        ),
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

              // Back button
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
                        icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
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

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
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



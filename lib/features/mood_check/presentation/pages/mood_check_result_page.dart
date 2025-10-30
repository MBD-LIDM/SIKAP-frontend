import 'package:flutter/material.dart';

class MoodCheckResultPage extends StatelessWidget {
  const MoodCheckResultPage({super.key, required this.result});

  final Map<String, dynamic> result;

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
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.insights, color: Color(0xFFFFDBB6), size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        _primaryLabel(result),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ..._legendFromResult(result),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      const _SectionTitle('Hasil Analisis'),
                      const SizedBox(height: 12),

                      Text(
                        _summaryText(result),
                        style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.6),
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

// Helpers to render dynamic result
String _primaryLabel(Map<String, dynamic> result) {
  // Try common shapes: {primary_emotion, scores: {sad:0.7,...}} or flat {emotion:'sadness', score:0.7}
  final primary = result['primary_emotion'] ?? result['emotion'];
  final score = result['score'] ?? (result['primary_score'] ?? _maxScore(result['scores']));
  if (primary != null && score != null) {
    final pct = ((score as num) * 100).toStringAsFixed(0);
    return '$pct% ${_title(primary.toString())}';
  }
  return 'Emosi Terdeteksi';
}

List<Widget> _legendFromResult(Map<String, dynamic> result) {
  final scores = result['scores'];
  if (scores is Map) {
    final entries = scores.entries
        .where((e) => e.value is num)
        .cast<MapEntry<dynamic, num>>()
        .toList()
      ..sort((a, b) => (b.value).compareTo(a.value));
    final colors = [Colors.white, const Color(0xFFBFD4FF), Colors.white70, Colors.white60];
    return [
      for (var i = 0; i < entries.length && i < 4; i++)
        _Legend(color: colors[i % colors.length], label: '${((entries[i].value) * 100).toStringAsFixed(0)}% ${_title(entries[i].key.toString())}')
    ];
  }
  return const [];
}

double? _maxScore(dynamic scores) {
  if (scores is Map) {
    final values = scores.values.whereType<num>();
    if (values.isNotEmpty) return values.reduce((a, b) => a > b ? a : b).toDouble();
  }
  return null;
}

String _title(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

String _summaryText(Map<String, dynamic> result) {
  final primary = result['primary_emotion'] ?? result['emotion'];
  final scores = result['scores'];
  if (primary != null) {
    return 'Emosi dominan: ${_title(primary.toString())}.\nHasil ini adalah wawasan teknis berdasarkan analisis suara, bukan diagnosis medis.';
  }
  if (scores is Map) {
    final top = scores.entries
        .where((e) => e.value is num)
        .cast<MapEntry<dynamic, num>>()
        .toList()
      ..sort((a, b) => (b.value).compareTo(a.value));
    if (top.isNotEmpty) {
      final first = top.first;
      final pct = (first.value * 100).toStringAsFixed(0);
      return 'Emosi tertinggi: ${_title(first.key.toString())} ($pct%).\nHasil ini adalah wawasan teknis berdasarkan analisis suara, bukan diagnosis medis.';
    }
  }
  return 'Analisis berhasil. Detail lengkap ditampilkan di atas.';
}



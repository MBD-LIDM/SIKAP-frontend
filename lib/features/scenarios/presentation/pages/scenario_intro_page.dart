import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ScenarioIntroPage extends StatelessWidget {
  const ScenarioIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE7CE),
      body: Container(
        color: const Color(0xFFFFE7CE),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF7F55B1)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text('Berani Menolong\nTeman', style: AppTheme.headingLarge.copyWith(color: const Color(0xFF7F55B1))),
                      const SizedBox(height: 24),
                      Text(
                        'Halo!\n\nSebelum kita mulai, bayangkan kamu akan menjadi pahlawan bagi dirimu sendiri atau orang lain.\n\nSetiap pilihan yang kamu buat di sini adalah langkah menuju keberanian.',
                        style: AppTheme.bodyLarge.copyWith(color: const Color(0xFF3F3F3F)),
                      ),
                      const Spacer(),
                      Center(
                        child: SizedBox(
                          height: 180,
                          child: Image.asset('assets/icons/sikap_icon.jpg', fit: BoxFit.contain),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7F55B1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ScenarioQuestionPage(),
                              ),
                            );
                          },
                          child: Text('Mulai Skenario  →', style: AppTheme.buttonText.copyWith(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 24),
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
}

class ScenarioQuestionPage extends StatelessWidget {
  const ScenarioQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFEDE0), Color(0xFF0C58B9)],
            stops: [0.45, 0.46],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF0C58B9)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Di kelas, kamu melihat Darrel sedang menangis di mejanya. Ada beberapa teman yang berbisik-bisik sambil menunjuk ke arahnya.\n\nDarrel terlihat sangat sedih dan tidak berani menoleh.',
                  style: AppTheme.bodyLarge.copyWith(color: const Color(0xFF3F3F3F)),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _OptionTile(
                        text: "Mendatangi Darrel dan bertanya, 'Kamu baik-baik saja?'",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ScenarioFeedbackGoodPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _OptionTile(
                        text: 'Pergi ke guru di luar kelas dan melapor secara diam-diam.',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ScenarioFeedbackGoodPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _OptionTile(
                        text: 'Mengabaikannya dan pura-pura tidak melihat.',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ScenarioFeedbackBadPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScenarioFeedbackGoodPage extends StatelessWidget {
  const ScenarioFeedbackGoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFEDE0), Color(0xFF0C58B9)],
            stops: [0.45, 0.46],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF0C58B9)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 12),
                Text('Pilihan jawabanmu adalah', style: AppTheme.headingMedium.copyWith(color: Colors.white)),
                const SizedBox(height: 12),
                _ChoiceBubble(text: "Mendatangi Darrel dan bertanya, 'Kamu baik-baik saja?'"),
                const SizedBox(height: 16),
                Text(
                  'Hebat! Kamu memilih untuk peduli. Pilihanmu membuat Darrel merasa tidak sendirian.\n\nDengan langsung bertanya, kamu menunjukkan bahwa ada teman yang peduli padanya.',
                  style: AppTheme.bodyLarge,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7F55B1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ScenarioReflectionPage(),
                        ),
                      );
                    },
                    child: Text('Skenario Berikutnya  →', style: AppTheme.buttonText.copyWith(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScenarioFeedbackBadPage extends StatelessWidget {
  const ScenarioFeedbackBadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFEDE0), Color(0xFF0C58B9)],
            stops: [0.45, 0.46],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF0C58B9)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 12),
                Text('Pilihan jawabanmu adalah', style: AppTheme.headingMedium.copyWith(color: Colors.white)),
                const SizedBox(height: 12),
                _ChoiceBubble(text: 'Mengabaikannya dan pura-pura tidak melihat.'),
                const SizedBox(height: 16),
                Text(
                  'Kamu memilih untuk tidak ikut campur. Kadang itu adalah cara yang paling aman, tapi temanmu mungkin tetap merasa sendirian.',
                  style: AppTheme.bodyLarge,
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF7F55B1),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Coba Lagi', style: AppTheme.buttonTextPurple),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7F55B1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ScenarioReflectionPage(),
                            ),
                          );
                        },
                        child: Text('Skenario Berikutnya  →', style: AppTheme.buttonText.copyWith(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScenarioReflectionPage extends StatelessWidget {
  const ScenarioReflectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skenario Selesai 🥳'),
        backgroundColor: const Color(0xFF7F55B1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF7F55B1),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Berani Menolong\nTeman', style: AppTheme.headingLarge),
                const SizedBox(height: 16),
                Text('Bagaimana perasaanmu saat membuat pilihan tadi?', style: AppTheme.bodyLarge),
                const SizedBox(height: 12),
                _ReflectionBox(hint: 'Ketik jawaban di sini...'),
                const SizedBox(height: 16),
                Text('Apakah ada hal yang akan kamu lakukan berbeda jika ini terjadi sungguhan?', style: AppTheme.bodyLarge),
                const SizedBox(height: 12),
                _ReflectionBox(hint: 'Ketik jawaban di sini...'),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF7F55B1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text('Kembali ke Homepage', style: AppTheme.buttonTextPurple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4))),
            const Icon(Icons.chevron_right, color: Color(0xFF7F55B1)),
          ],
        ),
      ),
    );
  }
}

class _ChoiceBubble extends StatelessWidget {
  const _ChoiceBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6E7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDC7FF)),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF7F55B1), fontWeight: FontWeight.w600)),
    );
  }
}

class _ReflectionBox extends StatelessWidget {
  const _ReflectionBox({required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
      child: TextField(
        maxLines: null,
        expands: true,
        decoration: InputDecoration.collapsed(hintText: hint, hintStyle: const TextStyle(color: Colors.black38)),
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }
}



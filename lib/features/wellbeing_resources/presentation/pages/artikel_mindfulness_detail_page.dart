import 'package:flutter/material.dart';

class ArtikelMindfulnessDetailPage extends StatelessWidget {
  const ArtikelMindfulnessDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E8D6),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back, color: Color(0xFF7F55B1)),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur bagikan akan segera hadir')),
                            );
                          },
                          icon: const Icon(Icons.share, color: Color(0xFF7F55B1)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pikiran Tenang, Belajar Lancar. Begini Manfaat Mindfulness untuk Pelajar',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF7F55B1),
                        height: 1.25,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '17 November 2025',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7A6C57),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFFF3D9BF),
                        padding: const EdgeInsets.all(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            'assets/images/article_images/Pikiran Tenang Belajar Lancar Begini Manfaat Mindfulness untuk Pelajar.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Foto: Pexels',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7A6C57),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage('assets/icons/sikap_icon.jpg'),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tim SIKAP',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3A2E24),
                              ),
                            ),
                            Text(
                              'Kesehatan Jiwa Remaja',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8A7B6A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mindfulness adalah latihan kesadaran penuh—mengarahkan perhatian pada apa yang terjadi saat ini tanpa menghakimi. Saat berlatih, kita belajar mengamati pikiran, perasaan, dan sensasi tubuh apa adanya, tanpa langsung menilainya “baik” atau “buruk”. Latihan sederhana ini menciptakan jeda antara pemicu dan respons, sehingga kita punya ruang untuk memilih cara menanggapi dengan lebih tenang dan bijak.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mengapa Mindfulness Penting bagi Siswa?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Berbagai penelitian di sekolah menunjukkan manfaat yang konsisten dari latihan mindfulness. Siswa cenderung mengalami peningkatan kemampuan berpikir (kognisi), pencapaian akademik, perilaku belajar, dan kesehatan sosial-emosional. Mindfulness juga membantu meningkatkan kemampuan regulasi emosi, serta mendorong perilaku prososial seperti empati dan kerja sama. Dengan berkurangnya reaktivitas emosi, iklim kelas menjadi lebih positif dan konflik antarsiswa dapat menurun.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Manfaat pada Tiap Jenjang Usia',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Siswa SD: Mindfulness membantu mengurangi masalah emosional dan perilaku, termasuk hiperaktivitas. Latihan ini juga mendukung fungsi eksekutif—kemampuan untuk fokus, mengendalikan impuls, dan mengingat—yang pada gilirannya berkaitan dengan peningkatan prestasi akademik.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Siswa SMP/SMA: Pada remaja, mindfulness efektif mengelola stres, terutama yang berkaitan dengan tuntutan akademik. Latihan ini juga membantu meningkatkan konsentrasi saat belajar.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Latihan Sederhana untuk Siswa',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1) Napas Balon (menenangkan diri)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: 'Duduk tegak dan letakkan satu tangan di perut.'),
                    const _Bullet(text: 'Tarik napas perlahan melalui hidung, rasakan perut mengembang seperti balon.'),
                    const _Bullet(text: 'Hembuskan napas perlahan melalui mulut.'),
                    const _Bullet(text: 'Ulangi lima kali atau sampai tubuh terasa lebih tenang.'),
                    const SizedBox(height: 12),
                    const Text(
                      '2) Jeda Sadar (STOP)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: 'S – Stop (Berhenti): saat emosi memuncak, hentikan dulu tindakan atau ucapan.'),
                    const _Bullet(text: 'T – Take a breath (Tarik napas): ambil satu tarikan napas dalam dan disadari.'),
                    const _Bullet(text: 'O – Observe (Amati): rasakan sensasi tubuh (mis. jantung berdebar) dan amati pikiran yang muncul.'),
                    const _Bullet(text: 'P – Proceed (Lanjutkan): setelah lebih tenang, pilih respons yang paling bijak.'),
                    const SizedBox(height: 24),
                    const Text(
                      'Referensi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: 'Dunning, D.L., dkk. (2022). The impact of mindfulness-based interventions in schools on adolescent stress, depression and anxiety. Child and Adolescent Mental Health, 28(2), 307–317.'),
                    const _Bullet(text: 'Flook, L., dkk. (2013). Effects of mindfulness education on executive functioning in elementary school children. Advances in School Mental Health Promotion, 6(3), 209–228.'),
                    const _Bullet(text: 'García-Banda, G., dkk. (2022). Mindfulness-Based Interventions (MBIs) for Youth (3–18): A Systematic Review. Children, 9(9), 1338.'),
                    const _Bullet(text: 'Kallapiran, K., dkk. (2023). Mindfulness-based interventions in schools for adolescents. Int. J. Environ. Res. Public Health, 20(5), 4068.'),
                    const _Bullet(text: 'Maynard, B.R., dkk. (2017). Mindfulness-based interventions for students. Campbell Systematic Reviews, 13(1), 1–144.'),
                    const SizedBox(height: 32),
                    const Center(
                      child: Text(
                        '© 2025 SIKAP. All rights reserved.',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 14, height: 1.6)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}



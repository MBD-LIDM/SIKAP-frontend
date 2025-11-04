import 'package:flutter/material.dart';

class ArtikelKecemasanDetailPage extends StatelessWidget {
  const ArtikelKecemasanDetailPage({super.key});

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
                      'Saat Dunia Terlalu Ramai: Mengenal dan Mengatasi Kecemasan Sehari-hari.',
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
                      '18 Agustus 2025',
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
                            'assets/images/article_images/Saat Dunia Terlalu Ramai Kecemasan Sehari-hari.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Foto: Karola G / Pexels',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7A6C57),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage('assets/icons/sikap_icon.jpg'),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
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
                      'Saat dunia terasa terlalu ramai, anak-anak dan remaja dapat mudah merasa cemas. Kecemasan adalah perasaan khawatir atau takut yang normal dialami sesekali. Misalnya, sebelum ujian atau berbicara di depan kelas, wajar jika merasa gugup. Rasa cemas seperti ini biasanya hilang setelah situasinya lewat. Namun, kecemasan bisa menjadi masalah jika muncul terlalu sering atau terasa sangat kuat.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tanda-tanda kecemasan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ketika seseorang merasa cemas, tubuh dan pikirannya memberikan sinyal tertentu. Secara fisik, cemas bisa membuat napas terasa cepat atau pendek, jantung berdebar kencang, tubuh gemetar atau gelisah, perut terasa tidak nyaman (misalnya mual atau mulas), hingga sulit tidur. Secara emosional dan mental, orang yang cemas mungkin sulit fokus atau kehilangan konsentrasi, merasa panik atau ketakutan tanpa alasan jelas, mudah merasa kewalahan, atau jadi lekas marah. Tentu setiap individu mungkin mengalami gejala yang sedikit berbeda.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cemas normal vs. cemas berlebihan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tidak semua kecemasan itu buruk. Rasa khawatir dalam kadar ringan dapat membantu kita waspada atau memotivasi belajar. Cemas yang normal biasanya sementara dan karena penyebab yang jelas. Di sisi lain, cemas berlebihan cenderung berlangsung terus-menerus atau muncul tanpa penyebab jelas, dan rasanya sangat intens hingga mengganggu aktivitas sehari-hari. Jika kekhawatiran tidak hilang-hilang dan mulai mengganggu kehidupan, itu tanda membutuhkan dukungan profesional.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Latihan untuk menenangkan diri',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: 'Pernapasan dalam: tarik napas perlahan lewat hidung, tahan sejenak, hembuskan lewat mulut.'),
                    const _Bullet(text: 'Relaksasi otot progresif: kencangkan lalu kendurkan kelompok otot dari kaki hingga kepala.'),
                    const _Bullet(text: 'Aktivitas fisik ringan: berjalan santai, peregangan, atau bersepeda santai untuk melepas ketegangan.'),
                    const _Bullet(text: 'Alihkan perhatian: menggambar, musik tenang, membaca cerita, atau bercerita pada orang tepercaya.'),
                    const SizedBox(height: 24),
                    const Text(
                      'Sumber',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: '''HealthyChildren.org: Anxiety in Teens
https://www.healthychildren.org/English/health-issues/conditions/emotional-problems/Pages/Anxiety-Disorders.aspx'''),
                    const _Bullet(text: '''UNICEF Indonesia: Apa itu kecemasan?
https://www.unicef.org/indonesia/id/kesehatan-mental/artikel/kecemasan'''),
                    const _Bullet(text: '''WHO Fact Sheet: Anxiety disorders
https://www.who.int/news-room/fact-sheets/detail/anxiety-disorders'''),
                    const _Bullet(text: '''Relaxasi otot progresif pada remaja (PubMed)
https://pubmed.ncbi.nlm.nih.gov/38905787/'''),
                    const _Bullet(text: '''Olahraga bantu kurangi kecemasan pada anak dan remaja (UniSA)
https://unisa.edu.au/media-centre/Releases/2025/move-to-improve-exercise-eases-depression-and-anxiety-in-kids/'''),
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



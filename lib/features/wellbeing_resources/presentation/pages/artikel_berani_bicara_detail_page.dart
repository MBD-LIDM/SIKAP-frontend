import 'package:flutter/material.dart';

class ArtikelBeraniBicaraDetailPage extends StatelessWidget {
  const ArtikelBeraniBicaraDetailPage({super.key});

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
                      'Berani Bicara: Mengapa Cerita Kecil tentang Perasaan Bisa Membuatmu Lebih Kuat',
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
                      '12 Agustus 2025',
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
                            'assets/images/article_images/Berani Bicara Cerita Kecil tentang Perasaan.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Foto: Mary Taylor / Pexels',
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
                      'Bercerita tentang perasaan – bahkan hal kecil sekalipun – adalah tindakan berani yang dapat membuatmu lebih kuat secara emosional. Dengan berbagi, beban pikiran terasa lebih ringan karena mendapat dukungan dari orang lain.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pentingnya komunikasi terbuka',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Komunikasi keluarga yang positif berhubungan dengan menurunnya tingkat kecemasan dan depresi pada remaja. Dukungan orang tua dan teman sebaya adalah faktor besar yang membuat remaja merasa bahagia dan sejahtera. Bisa bercerita dan didengarkan membantu kamu merasa dicintai dan diperhatikan.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cara memulai percakapan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: 'Mulai dengan cerita kecil: “Hari ini aku merasa gugup waktu ulangan.”'),
                    const _Bullet(text: 'Ungkapkan dengan jujur apa yang dirasakan dan penyebabnya.'),
                    const _Bullet(text: 'Sampaikan pada orang dewasa tepercaya: orang tua, wali, guru, atau kakak.'),
                    const SizedBox(height: 16),
                    const Text(
                      'Berbagi cerita mengurangi beban pikiran',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Menceritakan masalah atau kekhawatiran berarti membagi beban itu dengan orang yang dipercaya. Banyak anak merasa lega setelah curhat kepada orang tua atau sahabat. Kebiasaan berani bicara sejak dini menjadi modal penting bagi kesehatan mental di masa depan.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sumber',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: 'Huang, X. et al. (2023). Family communication, anxiety, and depression in adolescents. BMC Public Health.'),
                    const _Bullet(text: 'Wu, Y. & Lee, J. (2022). Parental support, peer support, and adolescents’ well-being. Child Indicators Research.'),
                    const _Bullet(text: 'Demol, K. et al. (2025). Relationships with peers and teachers and adolescent mental health. Journal of Research on Adolescence.'),
                    const _Bullet(text: 'Reynolds, M. et al. (2000). Emotional disclosure in school children. J. Child Psychol. Psychiatry.'),
                    const _Bullet(text: 'Bethell, C. et al. (2019). Positive childhood experiences and adult mental health. JAMA Pediatrics.'),
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



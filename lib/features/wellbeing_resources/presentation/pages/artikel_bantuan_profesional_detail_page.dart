import 'package:flutter/material.dart';

class ArtikelBantuanProfesionalDetailPage extends StatelessWidget {
  const ArtikelBantuanProfesionalDetailPage({super.key});

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
                      'Kapan dan Bagaimana Mencari Bantuan Profesional',
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
                      '20 Juli 2025',
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
                            'assets/images/article_images/Kapan dan Bagaimana Mencari Bantuan Profesional.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Foto: Alex Green / Pexels',
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
                      'Masalah kesehatan mental pada anak dan remaja cukup umum. Namun, banyak yang belum mendapatkan bantuan yang dibutuhkan karena gejala tidak disadari atau stigma. Jika tidak ditangani, dampaknya dapat mengganggu kehidupan di rumah dan sekolah.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Kapan harus mencari bantuan?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: 'Perasaan sedih, cemas, atau menarik diri berlangsung lebih dari dua minggu.'),
                    const _Bullet(text: 'Muncul keinginan menyakiti diri sendiri atau pikiran bunuh diri.'),
                    const _Bullet(text: 'Perubahan perilaku drastis, ketakutan berlebihan tanpa sebab jelas, atau gangguan fungsi harian.'),
                    const SizedBox(height: 16),
                    const Text(
                      'Bagaimana cara mencari bantuan?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: 'Mulailah bercerita pada orang dewasa yang dipercaya (orang tua, wali, guru, atau kakak).'),
                    const _Bullet(text: 'Minta bantuan profesional: psikolog atau psikiater terbiasa membantu anak dan remaja.'),
                    const SizedBox(height: 16),
                    const Text(
                      'Hindari mendiagnosis diri sendiri',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hanya profesional terlatih yang dapat memastikan kondisi dan penanganan yang tepat. Hindari menyimpulkan diagnosis dari media sosial atau sumber internet acak.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tidak perlu malu meminta bantuan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masalah kesehatan mental sama seriusnya dengan masalah fisik. Konseling atau terapi adalah langkah berani untuk menjaga kesehatan diri dan kembali fokus pada hal-hal yang disukai.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sumber',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: '''WHO: Mental health of adolescents
https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health'''),
                    const _Bullet(text: '''NAMI: Nearly 1 in 7 US Kids and Teens have a Mental Health Condition
https://www.nami.org/in-the-news/nearly-1-in-7-us-kids-and-teens-have-a-mental-health-condition-half-go-untreated-study-says/'''),
                    const _Bullet(text: '''CDC: About Children’s Mental Health
https://www.cdc.gov/children-mental-health/about/index.html'''),
                    const _Bullet(text: '''UNICEF Parenting: When to help your teen find mental health support
https://www.unicef.org/parenting/mental-health/when-help-your-teen-find-mental-health-support'''),
                    const _Bullet(text: '''University of Utah Health: Teens, Social Media, and Self-Diagnosis
https://healthcare.utah.edu/the-scope/kids-zone/all/2023/10/teens-social-media-and-trouble-self-diagnosis'''),
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



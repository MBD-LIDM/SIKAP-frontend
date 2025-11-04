import 'package:flutter/material.dart';

class ArtikelTemanDetailPage extends StatelessWidget {
  const ArtikelTemanDetailPage({super.key});

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
                      'Menjadi Teman yang Baik: Bagaimana Dukungan Antar Teman Bisa Menjaga Kesehatan Mental',
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
                      '10 Agustus 2025',
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
                            'assets/images/article_images/Menjadi Teman yang Baik Dukungan Antar Teman.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Foto: Pixabay / Pexels',
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
                      'Teman yang baik berperan penting dalam menjaga kesehatan mental anak dan remaja. Dukungan emosional dari teman sebaya bisa membuat seseorang merasa lebih tenang dan dihargai. Penelitian menunjukkan bahwa remaja yang merasa didukung oleh teman-temannya cenderung mengalami lebih sedikit masalah psikologis seperti kecemasan dan depresi.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Saling mendukung dan menjadi pendengar yang baik adalah ciri utama teman yang positif. Ketika seorang teman mau mendengarkan dengan sabar tanpa menghakimi, hal ini memberi kelegaan emosional. Dukungan teman memberikan rasa empati dan pengertian sehingga seorang anak merasa tidak sendirian menghadapi kecemasannya.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Di samping memberi dukungan positif, teman yang baik tidak akan menjerumuskan. Ini berarti penting bagi anak dan remaja untuk menghindari tekanan kelompok negatif. Tekanan negatif terjadi ketika teman sebaya mendorong hal-hal merugikan, seperti membolos sekolah, mencoba rokok atau perilaku berisiko lain.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Menjalin pertemanan yang positif dan saling mendukung sejak dini adalah investasi bagi kesehatan mental jangka panjang. Dengan teman-teman yang baik di sisi kita, masa tumbuh kembang dapat dilalui dengan lebih gembira dan aman.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sumber',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: '''JAMA Network Open: Social Support & Adolescent Mental Health
https://jamanetwork.com/journals/jamanetworkopen/fullarticle/2773539'''),
                    const _Bullet(text: '''BMC Public Health: Friendship quality & wellbeing
https://bmcpublichealth.biomedcentral.com/articles/10.1186/s12889-022-14776-4'''),
                    const _Bullet(text: '''BMC Psychiatry: Peer support effectiveness
https://bmcpsychiatry.biomedcentral.com/articles/10.1186/s12888-023-04578-2'''),
                    const _Bullet(text: '''Nature HSS Communications: Peer support reduces math anxiety
https://www.nature.com/articles/s41599-025-05075-5'''),
                    const _Bullet(text: '''Adolescent Research Review: Peers & social anxiety development
https://link.springer.com/article/10.1007/s40894-019-00117-x'''),
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



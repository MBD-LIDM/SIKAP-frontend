import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArtikelBullyingDetailPage extends StatelessWidget {
  const ArtikelBullyingDetailPage({super.key});

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
                    // Top bar
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

                    // Title
                    const Text(
                      'Bukan Salahmu: Memahami Apa Itu Bullying dan Mengapa Itu Terjadi',
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
                      '15 Agustus 2025',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7A6C57),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Illustration card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFFF3D9BF),
                        padding: const EdgeInsets.all(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: SvgPicture.asset(
                            'assets/images/lapor_bullying.svg',
                            fit: BoxFit.contain,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Author row
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
                              'Gianpiero Lambiase',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3A2E24),
                              ),
                            ),
                            Text(
                              'Psikolog Anak',
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

                    // Article content
                    const Text(
                      'Bullying, atau perundungan, adalah tindakan agresif dan berulang yang dilakukan oleh seseorang atau sekelompok orang kepada orang lain. Perilaku ini bukan hanya sekadar iseng atau candaan, karena tujuannya adalah untuk menyakiti atau membuat seseorang merasa tidak nyaman. Penting untuk diingat: apa pun alasannya, bullying tidak pernah menjadi kesalahan korban.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Apa yang Termasuk Bullying?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),

                    _Bullet(text: 'Verbal: Mengejek, menyebarkan gosip, atau memanggil nama yang tidak pantas.'),
                    _Bullet(text: 'Fisik: Mendorong, memukul, menendang, atau merusak barang.'),
                    _Bullet(text: 'Sosial: Mengucilkan dari kelompok atau menyebarkan rumor.'),
                    _Bullet(text: 'Siber: Mengirim pesan yang mengancam, menyebarkan foto memalukan, atau mengolok-olok di media sosial.'),

                    const SizedBox(height: 16),
                    const Text(
                      'Mengapa Bullying Terjadi?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Bullying bisa terjadi karena banyak faktor, seperti kebutuhan pelaku untuk merasa berkuasa, tekanan dari teman sebaya, atau masalah pribadi yang tidak terselesaikan. Apapun penyebabnya, bullying tidak bisa dibenarkan.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Apa yang Bisa Kamu Lakukan?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    _Bullet(text: 'Jika kamu menjadi korban: ceritakan pada orang dewasa yang dipercaya.'),
                    _Bullet(text: 'Jika kamu melihat bullying: bantu dengan cara aman atau laporkan.'),
                    _Bullet(text: 'Simpan bukti jika terjadi secara online, dan hindari membalas.'),

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



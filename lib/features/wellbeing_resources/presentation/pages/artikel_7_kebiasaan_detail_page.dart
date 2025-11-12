import 'package:flutter/material.dart';

class ArtikelTujuhKebiasaanDetailPage extends StatelessWidget {
  const ArtikelTujuhKebiasaanDetailPage({super.key});

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
                      'Penerapan 7 Kebiasaan Anak Indonesia Hebat dalam Meningkatkan Kesehatan Mental Siswa',
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
                      '10 November 2025',
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
                            'assets/images/article_images/Penerapan 7 Kebiasaan Anak Indonesia Hebat dalam Meningkatkan Kesehatan Mental Siswa.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Photo by Mehmet Turgut Kirkgoz from Pexels: https://www.pexels.com/photo/group-of-students-playing-on-the-ground-11445241/',
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
                      'Kesehatan mental siswa di Indonesia merupakan hal yang sangat penting untuk diperhatikan, terutama karena anak-anak dan remaja di jenjang SD, SMP, hingga SMA sedang berada pada masa perkembangan yang penuh perubahan dan tuntutan. Selain penanganan klinis, kebiasaan sehari-hari yang sederhana justru menjadi fondasi utama dalam menjaga pikiran tetap sehat dan emosi tetap stabil. Kerangka \"7 Kebiasaan Anak Indonesia Hebat\" menawarkan pendekatan yang mudah diterapkan untuk membangun kesehatan mental yang kuat, yaitu bangun pagi, beribadah, berolahraga, makan sehat dan bergizi, gemar belajar, bermasyarakat, dan tidur cepat. Kebiasaan-kebiasaan ini bukan sekadar rutinitas, tetapi memiliki dasar ilmiah yang berkaitan langsung dengan kerja tubuh, cara otak mengelola stres, serta bagaimana seseorang membangun hubungan sosial.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tidur cepat dan bangun pagi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tidur cepat dan bangun pagi membantu mengatur ritme alami tubuh yang dikenal sebagai ritme sirkadian. Pada masa remaja, tubuh memang cenderung ingin tidur lebih larut, tetapi sekolah dan aktivitas pagi menuntut sebaliknya. Ketika pola tidur tidak seimbang, otak menjadi lebih rentan terhadap kecemasan, stres, dan pikiran negatif. Dengan membiasakan diri tidur di waktu yang sama setiap malam dan bangun dengan teratur, siswa dapat melindungi diri dari kelelahan emosional yang sering muncul tanpa disadari. Kebiasaan ini bekerja layaknya penyangga yang membantu otak tetap tenang dan siap menghadapi hari.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pola makan sehat',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selain tidur, makanan yang dikonsumsi sehari-hari juga berpengaruh besar pada kondisi mental. Pola makan yang kaya buah, sayuran, biji-bijian, ikan, dan makanan segar membantu menjaga kesehatan otak dan mengurangi risiko munculnya rasa cemas dan sedih. Sebaliknya, makanan ultra-olahan seperti camilan kemasan atau minuman manis lebih mudah memicu suasana hati yang tidak stabil. Kebiasaan makan sehat bukan berarti harus selalu mahal atau rumit, tetapi lebih pada memilih makanan yang alami dan tidak berlebihan dalam gula atau pengawet. Ketika tubuh diberi “bahan bakar” yang baik, pikiran pun menjadi lebih seimbang.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Olahraga sebagai antistres alami',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Berolahraga juga berperan sebagai “obat antistres” alami. Saat tubuh bergerak, otak melepaskan zat kimia yang membuat seseorang merasa lebih bahagia dan rileks. Tidak diperlukan olahraga berat atau latihan panjang setiap hari. Aktivitas ringan hingga sedang yang dilakukan beberapa kali seminggu, seperti berjalan cepat, bersepeda, bermain bola, atau menari, sudah mampu membantu memperbaiki suasana hati dan kualitas tidur. Olahraga, tidur, dan makanan sehat bekerja bersama sebagai satu rangkaian pendukung kesehatan mental.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ketenangan melalui ibadah',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Di sisi emosional, kebiasaan beribadah dapat menjadi cara yang kuat untuk menenangkan diri. Berdoa, bersyukur, atau mengambil waktu untuk merenung membantu seseorang kembali terhubung dengan perasaan damai. Banyak siswa melaporkan bahwa beribadah membuat mereka merasa tidak sendirian dan membantu meredakan kecemasan yang menumpuk. Di saat pikiran terasa penuh, jeda sejenak dalam keheningan dapat membantu memberi kelegaan dan kejernihan.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Makna “gemar belajar”',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Belajar juga berpengaruh pada kesehatan mental, tetapi bukan dalam arti belajar keras demi nilai atau peringkat. “Gemar belajar” berarti merasa tertarik, penasaran, dan menikmati proses memahami hal baru. Ketika belajar dilakukan karena ingin berkembang, bukan karena takut gagal, prosesnya menjadi menyenangkan dan membuat kepercayaan diri tumbuh. Pola pikir ini membantu siswa menikmati perjalanannya, bukan hanya hasilnya.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bermasyarakat menguatkan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Terakhir, kebiasaan bermasyarakat membantu melawan rasa kesepian. Memiliki hubungan positif dengan teman, keluarga, dan guru terbukti dapat mengurangi stres dan membuat seseorang merasa memiliki tempat untuk pulang secara emosional. Menariknya, bukan hanya menerima dukungan yang bermanfaat, tetapi memberi dukungan kepada orang lain juga meningkatkan kebahagiaan. Membantu teman, berbagi, atau sekadar hadir untuk seseorang dapat menciptakan rasa hangat yang memperkuat hubungan dan ketahanan mental.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Keterkaitan tujuh kebiasaan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ketujuh kebiasaan ini saling berhubungan dan saling menguatkan. Tidur yang baik membantu tubuh berenergi untuk berolahraga. Olahraga membantu memperbaiki suasana hati dan kualitas tidur. Makan sehat mendukung konsentrasi dalam belajar. Beribadah menenangkan hati. Bermasyarakat memperkuat rasa saling memiliki. Semuanya bekerja sebagai lingkaran positif. Tidak perlu memulai semuanya sekaligus. Pilih satu kebiasaan kecil terlebih dahulu, lakukan dengan konsisten, dan biarkan perubahan baik tumbuh dari sana. Kesehatan mental bukan sesuatu yang terjadi tiba-tiba, tetapi sesuatu yang dibangun perlahan melalui langkah-langkah sederhana yang dilakukan setiap hari.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Referensi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const _Bullet(text: 'Alsarrani, A., Hunter, R. F., Dunne, L., & Garcia, L. (2022). Association between friendship quality and subjective wellbeing among adolescents: a systematic review. BMC Public Health, 22, Article 2420.'),
                    const _Bullet(text: 'Chen, Y., & VanderWeele, T. J. (2018). Associations of religious upbringing with subsequent health and well-being from adolescence to young adulthood: An outcome-wide analysis. American Journal of Epidemiology, 187(11), 2355–2364.'),
                    const _Bullet(text: 'Fismen, A.-S., Aarø, L. E., Thorsteinsson, E., Ojala, K., Samdal, O., Helleve, A., & Eriksson, C. (2024). Associations between eating habits and mental health among adolescents in five Nordic countries: A cross-sectional survey. BMC Public Health, 24, 2640.'),
                    const _Bullet(text: 'Fu, Q., Li, L., Li, Q., & Wang, J. (2025). The effects of physical activity on the mental health of typically developing children and adolescents: a systematic review and meta-analysis. BMC Public Health, 25, 1514.'),
                    const _Bullet(text: 'Johri, K., Pillai, R., Kulkarni, A., & Balkrishnan, R. (2025). Effects of sleep deprivation on the mental health of adolescents: a systematic review. Sleep Science and Practice, 9, Article 9.'),
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



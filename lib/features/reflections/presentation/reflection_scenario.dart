import 'package:flutter/material.dart';
import 'package:sikap/features/scenarios/data/scenario_repository.dart';
import 'package:sikap/features/scenarios/domain/models/scenario_models.dart';
import 'reflection_list.dart';

class ReflectionScenarioPage extends StatefulWidget {
  const ReflectionScenarioPage({super.key});

  @override
  State<ReflectionScenarioPage> createState() => _ReflectionScenarioPageState();
}

class _ReflectionScenarioPageState extends State<ReflectionScenarioPage> {
  final ScenarioRepository _repo = ScenarioRepository();
  bool _loading = true;
  List<ScenarioItem> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await _repo.loadScenarios();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final grouped = <String, List<ScenarioItem>>{};
    for (final it in _items) grouped.putIfAbsent(it.level, () => []).add(it);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refleksi Skenario'),
        backgroundColor: const Color(0xFF7F55B1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF7F55B1),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final entry in grouped.entries)
                _Section(
                  title: entry.key,
                  items: entry.value,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<ScenarioItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...items.map((s) {
          final desc = s.stages.isNotEmpty ? s.stages.last.narration : '';
          final question = s.stages.isNotEmpty ? s.stages.last.question : '';
          return _ScenarioTile(item: s, description: desc, question: question);
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ScenarioTile extends StatelessWidget {
  const _ScenarioTile(
      {required this.item, required this.description, required this.question});
  final ScenarioItem item;
  final String description;
  final String question;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        title: Text(item.title,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReflectionListPage(
                scenarioTitle: item.title,
                scenarioDescription: description,
                question: question,
                scenarioId: item.remoteId,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReflectionScenarioDetailPage extends StatelessWidget {
  const ReflectionScenarioDetailPage(
      {super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Skenario'),
        backgroundColor: const Color(0xFF7F55B1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF7F55B1),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Text(description),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

 // @override
  // Widget build(BuildContext context) {
  //   final Map<String, List<String>> data = {
  //     'SD': [
  //       'Kotak Pensil Disembunyikan & Ejekan',
  //       'Merasa Sedih Karena Gagal Gambar',
  //       'Melihat Teman Didorong di Lapangan',
  //     ],
  //     'SMP': [
  //       'Dikeluarkan dari Grup WA & Rumor',
  //       'Tekanan Cepat Menyelesaikan Tugas Kelompok',
  //       'Melihat Siswa Lain Memaksa Junior Membayar Jajan',
  //     ],
  //     'SMA': [
  //       'Perselisihan Posting Medsos & Cancel Culture',
  //       'Dilema Menjadi Saksi Kecurangan Ujian',
  //       'Menghadapi Guru yang Memberikan Komentar Merendahkan',
  //     ],
  //   };

  //   final Map<String, String> descriptions = {
  //     // SD
  //     'Kotak Pensil Disembunyikan & Ejekan':
  //         'Di sini, kamu akan belajar mengenai tindakan berani yang aman. Selain itu, kamu juga akan mengidentifikasi bullying sederhana. Kamu akan tahu cara tepat meminta bantuan orang dewasa.',
  //     'Merasa Sedih Karena Gagal Gambar':
  //         'Di sini, kamu akan belajar mengenai cara mengelola perasaan frustrasi. Selain itu, kamu juga akan mencari bantuan saat kesulitan belajar. Kamu akan fokus pada proses usaha, bukan hanya hasil akhir.',
  //     'Melihat Teman Didorong di Lapangan':
  //         'Di sini, kamu akan belajar mengenai cara aman menjadi upstander. Selain itu, kamu juga akan mengutamakan keselamatan saat menolong. Kamu akan memahami bahwa melapor adalah tindakan keberanian.',
  //     // SMP
  //     'Dikeluarkan dari Grup WA & Rumor':
  //         'Di sini, kamu akan belajar mengenai mengendalikan emosi saat krisis daring. Selain itu, kamu juga akan memilih strategi pelaporan yang efektif. Kamu akan melindungi diri dari cyberbullying yang meluas.',
  //     'Tekanan Cepat Menyelesaikan Tugas Kelompok':
  //         'Di sini, kamu akan belajar mengenai komunikasi asertif. Selain itu, kamu juga akan menyusun perencanaan kerja yang realistis. Kamu akan menyelesaikan konflik akademik dengan kepala dingin.',
  //     'Melihat Siswa Lain Memaksa Junior Membayar Jajan':
  //         'Di sini, kamu akan belajar mengenai pengambilan keputusan etis. Selain itu, kamu juga akan menyelamatkan korban tanpa konfrontasi. Kamu akan mempertahankan nilai keadilan di sekolah.',
  //     // SMA
  //     'Perselisihan Posting Medsos & Cancel Culture':
  //         'Di sini, kamu akan belajar mengenai berpikir kritis saat krisis daring. Selain itu, kamu juga akan melindungi diri dari tekanan groupthink. Kamu akan menerapkan strategi manajemen krisis media sosial.',
  //     'Dilema Menjadi Saksi Kecurangan Ujian':
  //         'Di sini, kamu akan belajar mengenai pentingnya integritas akademik. Selain itu, kamu juga akan memilih saluran pelaporan anonim yang tepat. Kamu akan mengelola tekanan sosial setelah mengambil sikap jujur.',
  //     'Menghadapi Guru yang Memberikan Komentar Merendahkan':
  //         'Di sini, kamu akan belajar mengenai cara berkomunikasi secara asertif dengan figur otoritas. Selain itu, kamu juga akan mencari dukungan profesional di sekolah. Kamu akan memisahkan komentar destruktif dari nilai dirimu.',
  //   };

  //   final Map<String, String> questions = {
  //     // SD
  //     'Kotak Pensil Disembunyikan & Ejekan': 'Apa yang kamu pelajari tentang menjadi "pahlawan" yang baik hari ini?',
  //     'Merasa Sedih Karena Gagal Gambar': 'Apa yang kamu lakukan saat sedih/kesal agar bisa semangat lagi?',
  //     'Melihat Teman Didorong di Lapangan': 'Apa yang kamu lakukan saat kamu melihat teman butuh bantuan tetapi kamu merasa takut?',
  //     // SMP
  //     'Dikeluarkan dari Grup WA & Rumor': 'Apa yang kamu pelajari tentang menghadapi masalah di media sosial tanpa mengorbankan dirimu sendiri?',
  //     'Tekanan Cepat Menyelesaikan Tugas Kelompok': 'Apa yang kamu pelajari tentang pentingnya perencanaan dan berbicara jujur dalam kelompok?',
  //     'Melihat Siswa Lain Memaksa Junior Membayar Jajan': 'Apa yang membuatmu berani bertindak, meskipun ada risiko bahaya?',
  //     // SMA
  //     'Perselisihan Posting Medsos & Cancel Culture': 'Apa yang kamu pelajari tentang pentingnya berpikir kritis dan mengelola emosi dalam menghadapi tekanan sosial daring?',
  //     'Dilema Menjadi Saksi Kecurangan Ujian': 'Mengapa nilai kejujuran lebih penting daripada popularitas sosial di sekolah?',
  //     'Menghadapi Guru yang Memberikan Komentar Merendahkan': 'Apa yang kamu pelajari tentang pentingnya memisahkan kritik yang merusak (destruktif) dengan nilai dirimu sendiri?',
  //   };

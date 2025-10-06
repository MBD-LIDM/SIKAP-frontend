import 'package:flutter/material.dart';

class BullyingReportWizardPage extends StatefulWidget {
  const BullyingReportWizardPage({super.key});

  @override
  State<BullyingReportWizardPage> createState() => _BullyingReportWizardPageState();
}

class _BullyingReportWizardPageState extends State<BullyingReportWizardPage> {
  static const int totalSteps = 4;
  int currentStep = 1;

  // form state
  String? selectedCategory; // step 1
  final TextEditingController descriptionController = TextEditingController(); // step 2
  final List<String> evidences = []; // step 3 (placeholder path strings)
  bool anonymous = false; // step 4
  bool confirmTruth = false; // step 4

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  double get progress => currentStep / totalSteps;

  void next() {
    if (currentStep < totalSteps) {
      setState(() {
        currentStep += 1;
      });
    }
  }

  void previous() {
    if (currentStep > 1) {
      setState(() {
        currentStep -= 1;
      });
    }
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Langkah $currentStep dari $totalSteps', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _stepTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    );
  }

  Widget _step1() {
    final items = <Map<String, String>>[
      {'key': 'fisik', 'title': 'Secara fisik', 'hint': 'misalnya mendorong, memukul'},
      {'key': 'verbal', 'title': 'Secara verbal', 'hint': 'misalnya mengejek, menghina'},
      {'key': 'cyber', 'title': 'Cyberbullying', 'hint': 'di media sosial, pesan teks'},
      {'key': 'sosial', 'title': 'Pengucilan', 'hint': 'menyebarkan rumor, mengabaikan'},
      {'key': 'lainnya', 'title': 'Lainnya', 'hint': 'tipe lain'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTitle('Apa yang terjadi?'),
        const SizedBox(height: 8),
        const Text('Pilih sesuai kategori kejadian bullying', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 16),
        ...items.map((item) {
          final isSelected = selectedCategory == item['key'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => setState(() => selectedCategory = item['key']),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                  border: isSelected ? Border.all(color: const Color(0xFF7F55B1), width: 2) : null,
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: isSelected ? const Color(0xFF7F55B1) : Colors.grey.shade300),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(item['hint']!, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _step2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTitle('Ceritakan kepada kami apa yang terjadi'),
        const SizedBox(height: 8),
        const Text(
          'Jelaskan apa yang terjadi, siapa yang terlibat, dan kapan/di mana kejadian tersebut berlangsung. Jelaskan selengkap mungkin.',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
          ]),
          child: TextField(
            controller: descriptionController,
            maxLines: 10,
            decoration: const InputDecoration.collapsed(hintText: 'Tulis kronologi kejadian...'),
          ),
        ),
      ],
    );
  }

  Widget _step3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTitle('Apakah kamu punya bukti yang bisa dibagikan?'),
        const SizedBox(height: 8),
        const Text('Bukti dapat berupa foto, video, atau dokumen PDF. (Placeholder daftar)', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        ...evidences.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [const Icon(Icons.insert_drive_file, color: Color(0xFF7F55B1)), const SizedBox(width: 8), Expanded(child: Text(e)),
                    IconButton(onPressed: () => setState(() => evidences.remove(e)), icon: const Icon(Icons.close))],
                ),
              ),
            )),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              evidences.add('Bukti ${evidences.length + 1}');
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Tambah bukti (placeholder)'),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white70)),
        ),
      ],
    );
  }

  Widget _step4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTitle('Periksa kembali laporanmu'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kategori Bullying: ${selectedCategory ?? '-'}'),
              const SizedBox(height: 8),
              const Text('Penjelasan:'),
              Text(descriptionController.text.isEmpty ? '-' : descriptionController.text),
              const SizedBox(height: 8),
              const Text('Bukti:'),
              Wrap(spacing: 8, runSpacing: 8, children: evidences.map((e) => Chip(label: Text(e))).toList()),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: anonymous,
          onChanged: (v) => setState(() => anonymous = v ?? false),
          title: const Text('Laporkan secara anonim (identitas saya akan dirahasiakan).', style: TextStyle(color: Colors.white)),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Colors.white,
          checkColor: const Color(0xFF7F55B1),
        ),
        CheckboxListTile(
          value: confirmTruth,
          onChanged: (v) => setState(() => confirmTruth = v ?? false),
          title: const Text('Saya menyatakan bahwa informasi ini adalah kejadian yang benar-benar terjadi.', style: TextStyle(color: Colors.white)),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Colors.white,
          checkColor: const Color(0xFF7F55B1),
        ),
      ],
    );
  }

  Widget _content() {
    switch (currentStep) {
      case 1:
        return _step1();
      case 2:
        return _step2();
      case 3:
        return _step3();
      default:
        return _step4();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7F55B1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: _content(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: previous,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF7F55B1),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: currentStep < totalSteps
                        ? () {
                            if (currentStep == 1 && selectedCategory == null) return;
                            next();
                          }
                        : (confirmTruth
                            ? () {
                                Navigator.of(context).pop();
                              }
                            : null),
                    child: Text(currentStep < totalSteps ? 'Selanjutnya' : 'Kirim Laporan'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



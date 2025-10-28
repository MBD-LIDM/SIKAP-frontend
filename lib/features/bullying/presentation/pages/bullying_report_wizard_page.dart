import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    } else {
      // Jika di step pertama, kembali ke halaman sebelumnya
      Navigator.of(context).pop();
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

  Widget _bullyingTypeButton({
    required String key,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE6D7FF) : const Color(0xFFF5F5DC), // Purple tint when selected, beige when not
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF7F55B1) : const Color(0xFF7F55B1).withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                  ? const Color(0xFF7F55B1).withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.1),
                blurRadius: isSelected ? 12 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left section - Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF7F55B1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected 
                        ? const Color(0xFF7F55B1).withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : const Color(0xFF7F55B1),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Right section - Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top right - Bullying type title
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Color(0xFF8B4513), // Brownish color
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Bottom right - Type description
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4B5), // Light orange/peach background
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        description,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _step1() {
    final items = <Map<String, dynamic>>[
      {
        'key': 'fisik',
        'title': 'Secara fisik',
        'description': 'misalnya mendorong, memukul',
        'icon': Icons.pan_tool, // Fist icon
      },
      {
        'key': 'verbal',
        'title': 'Secara verbal',
        'description': 'misalnya mengejek, menghina',
        'icon': Icons.record_voice_over,
      },
      {
        'key': 'cyber',
        'title': 'Cyberbullying',
        'description': 'di media sosial, pesan teks',
        'icon': Icons.computer,
      },
      {
        'key': 'sosial',
        'title': 'Pengucilan',
        'description': 'menyebarkan rumor, mengabaikan',
        'icon': Icons.group_off,
      },
      {
        'key': 'lainnya',
        'title': 'Lainnya',
        'description': 'tipe lain',
        'icon': Icons.more_horiz,
      },
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
          return _bullyingTypeButton(
            key: item['key'],
            title: item['title'],
            description: item['description'],
            icon: item['icon'],
            isSelected: isSelected,
            onTap: () => setState(() => selectedCategory = item['key']),
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
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8),
          ]),
          child: TextField(
            controller: descriptionController,
            maxLines: 10,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            decoration: const InputDecoration.collapsed(
              hintText: 'Tulis kronologi kejadian...',
              hintStyle: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
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
    return PopScope(
      canPop: currentStep == 1,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop && currentStep > 1) {
          // Jika tidak di step pertama, kembali ke step sebelumnya
          previous();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF7F55B1), // Purple at 76%
                Color(0xFFFFDBB6), // Light peach/orange at 100%
              ],
              stops: [0.76, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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
                      ],
                    ),
                  ),
                ),
                // Footer dengan background SVG
                SizedBox(
                  height: 95, // Fixed height from SVG
                  child: Stack(
                    children: [
                      // SVG background
                      Positioned.fill(
                        child: SvgPicture.asset(
                          'assets/others/footer_form.svg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      // Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Back Button
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xAA9D6CFF), // Purple-ish color with opacity
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: previous,
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            
                            // Selanjutnya Button
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC89EFF), // Light purple color
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC89EFF), // Light purple color
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.zero, // Padding sudah diatur di Container
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0, // Remove default elevation since we're using custom shadow
                                ),
                                onPressed: currentStep < totalSteps
                                    ? () {
                                        if (currentStep == 1 && selectedCategory == null) {
                                          return;
                                        }
                                        next();
                                      }
                                    : (confirmTruth
                                        ? () {
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (_) => const BullyingReportSuccessPage(),
                                              ),
                                            );
                                          }
                                        : null),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      currentStep < totalSteps ? 'Selanjutnya' : 'Kirim Laporan',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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




class BullyingReportSuccessPage extends StatelessWidget {
  const BullyingReportSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7F55B1),
              Color(0xFFFFDBB6),
            ],
            stops: [0.76, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: Color(0xAA9D6CFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Terima kasih telah menjadi berani. Laporan anda akan segera kami tinjau',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC89EFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                      child: Text(
                        'Selesai',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


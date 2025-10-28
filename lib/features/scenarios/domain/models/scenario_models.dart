class ScenarioOption {
  ScenarioOption({
    required this.id,
    required this.answer,
    required this.feedback,
    required this.nextStage,
  });

  final String id;
  final String answer;
  final String feedback;
  final int nextStage; // tahap_ke tujuan (1-based)

  factory ScenarioOption.fromJson(Map<String, dynamic> json) {
    return ScenarioOption(
      id: json['id'] as String,
      answer: json['jawaban'] as String,
      feedback: json['umpan_balik'] as String,
      nextStage: (json['lanjut_ke_tahap'] as num).toInt(),
    );
  }
}

class ScenarioStage {
  ScenarioStage({
    required this.stageNumber,
    required this.narration,
    required this.question,
    required this.illustrationFile,
    required this.options,
  });

  final int stageNumber; // 1-based
  final String narration;
  final String question;
  final String illustrationFile; // e.g., sd_1_1.png
  final List<ScenarioOption> options; // kosong jika tahap refleksi

  bool get isReflection => options.isEmpty;

  factory ScenarioStage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawOptions = json['pilihan'] as List<dynamic>;
    return ScenarioStage(
      stageNumber: (json['tahap_ke'] as num).toInt(),
      narration: json['narasi'] as String,
      question: json['pertanyaan'] as String,
      illustrationFile: json['ilustrasi_file'] as String,
      options: rawOptions.map((e) => ScenarioOption.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class ScenarioItem {
  ScenarioItem({
    required this.level,
    required this.title,
    required this.srlLesson,
    required this.stages,
  });

  final String level; // SD/SMP/SMA
  final String title; // Nama skenario
  final String srlLesson; // pelajaran_srl
  final List<ScenarioStage> stages;

  factory ScenarioItem.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawStages = json['tahapan'] as List<dynamic>;
    return ScenarioItem(
      level: json['jenjang'] as String,
      title: json['skenario'] as String,
      srlLesson: json['pelajaran_srl'] as String,
      stages: rawStages.map((e) => ScenarioStage.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}




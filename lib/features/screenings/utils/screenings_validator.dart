class ScreeningsValidator {
  static String? validateTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'Judul tidak boleh kosong';
    }
    if (title.length < 5) {
      return 'Judul minimal 5 karakter';
    }
    if (title.length > 100) {
      return 'Judul maksimal 100 karakter';
    }
    return null;
  }

  static String? validateDescription(String? description) {
    if (description == null || description.isEmpty) {
      return 'Deskripsi tidak boleh kosong';
    }
    if (description.length < 10) {
      return 'Deskripsi minimal 10 karakter';
    }
    if (description.length > 500) {
      return 'Deskripsi maksimal 500 karakter';
    }
    return null;
  }

  static String? validateType(String? type) {
    if (type == null || type.isEmpty) {
      return 'Jenis skrining harus dipilih';
    }
    return null;
  }

  static String? validateQuestions(List<Map<String, dynamic>>? questions) {
    if (questions == null || questions.isEmpty) {
      return 'Minimal harus ada 1 pertanyaan';
    }
    if (questions.length > 50) {
      return 'Maksimal 50 pertanyaan';
    }
    return null;
  }

  static String? validateQuestionText(String? questionText) {
    if (questionText == null || questionText.isEmpty) {
      return 'Pertanyaan tidak boleh kosong';
    }
    if (questionText.length < 5) {
      return 'Pertanyaan minimal 5 karakter';
    }
    return null;
  }
}











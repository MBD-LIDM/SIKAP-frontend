class BullyingValidator {
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
    if (description.length > 1000) {
      return 'Deskripsi maksimal 1000 karakter';
    }
    return null;
  }

  static String? validateType(String? type) {
    if (type == null || type.isEmpty) {
      return 'Jenis bullying harus dipilih';
    }
    return null;
  }

  static String? validateSeverity(String? severity) {
    if (severity == null || severity.isEmpty) {
      return 'Tingkat keparahan harus dipilih';
    }
    return null;
  }
}










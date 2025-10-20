class VentingValidator {
  static String? validateTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'Judul tidak boleh kosong';
    }
    if (title.length < 3) {
      return 'Judul minimal 3 karakter';
    }
    if (title.length > 100) {
      return 'Judul maksimal 100 karakter';
    }
    return null;
  }

  static String? validateContent(String? content) {
    if (content == null || content.isEmpty) {
      return 'Isi curhat tidak boleh kosong';
    }
    if (content.length < 10) {
      return 'Isi curhat minimal 10 karakter';
    }
    if (content.length > 2000) {
      return 'Isi curhat maksimal 2000 karakter';
    }
    return null;
  }

  static String? validateMood(String? mood) {
    if (mood == null || mood.isEmpty) {
      return 'Mood harus dipilih';
    }
    return null;
  }

  static String? validatePrivacy(String? privacy) {
    if (privacy == null || privacy.isEmpty) {
      return 'Privasi harus dipilih';
    }
    return null;
  }

  static String? validateTags(String? tags) {
    if (tags != null && tags.isNotEmpty) {
      final tagList = tags.split(',').map((tag) => tag.trim()).toList();
      if (tagList.length > 10) {
        return 'Maksimal 10 tag';
      }
      for (final tag in tagList) {
        if (tag.length > 20) {
          return 'Setiap tag maksimal 20 karakter';
        }
      }
    }
    return null;
  }
}











class AccountsValidator {
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    if (username.length < 3) {
      return 'Username minimal 3 karakter';
    }
    if (username.length > 20) {
      return 'Username maksimal 20 karakter';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Username hanya boleh mengandung huruf, angka, dan underscore';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (password.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  static String? validateFullName(String? fullName) {
    if (fullName != null && fullName.isNotEmpty && fullName.length < 2) {
      return 'Nama lengkap minimal 2 karakter';
    }
    return null;
  }
}











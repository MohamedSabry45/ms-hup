class ValidationForm {
  static String? nameValidator(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return 'Required';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return 'Required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
      return 'Invalid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return 'Required';
    }
    if (v.length < 4) {
      return 'Too short';
    }
    return null;
  }
}

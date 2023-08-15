class Validators {
  static String? validatePassword(String? password, String? username) {
    if (password == null) return Validators.required("Password", password);
    RegExp oneUppercaseLetter = RegExp(r"[A-Z0-9]+");
    RegExp oneLowercaseLetter = RegExp(r"[a-z0-9]+");
    RegExp minLength = RegExp(r".{8,}");
    RegExp specialChar = RegExp(r"[@!#%&()^~{}]{1,}");

    // if (!oneUppercaseLetter.hasMatch(password)) {
    //   return "One uppercase letter";
    // }

    if (!oneLowercaseLetter.hasMatch(password)) {
      return "One lowercase letter";
    }
    if (!minLength.hasMatch(password)) {
      return "Minimum password length of 8 characters";
    }
    // if (!specialChar.hasMatch(password)) {
    //   return "One special characters";
    // }

    if (username != null) {
      if (password.contains(username)) {
        return "Password should not contain the username";
      }
    }

    return null;
  }

  static String? required(String fieldName, String? value) {
    if (value == null || (value.isEmpty)) return "$fieldName is required";
    return null;
  }

  static String? checkFieldEmpty(String? fieldContent) {
    if (fieldContent!.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? verifiedEmail(String email) {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      return 'This field is required';
    }
    return null;
  }
}

import 'package:contacts/util/strings.dart';

class FormValidation {
  static String? nameValidator(String? value) {
    Strings strings = Strings.instance;
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return strings.emptyName;
    }
    if (value.trim().split(" ").length < 2) return strings.notFullName;
    return null;
  }

  static String? phoneValidator(String? value) {
    Strings strings = Strings.instance;
    String regexPattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    var regExp = RegExp(regexPattern);
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return strings.emptyPhone;
    }
    if (!regExp.hasMatch(value)) {
      return strings.invalidNumber;
    }
    return null;
  }
}

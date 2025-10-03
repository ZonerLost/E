import 'package:flutter/services.dart';

class CvcInputFormatter extends TextInputFormatter {
  final int maxLength;

  CvcInputFormatter({this.maxLength = 3}); 

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // keep only digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // enforce max length
    if (digitsOnly.length > maxLength) {
      digitsOnly = digitsOnly.substring(0, maxLength);
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

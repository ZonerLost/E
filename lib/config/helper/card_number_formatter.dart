import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  final int maxDigits;

  CardNumberInputFormatter({this.maxDigits = 16});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Keep only digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Enforce max digits
    if (digitsOnly.length > maxDigits) {
      digitsOnly = digitsOnly.substring(0, maxDigits);
    }

    // Build formatted string with space after every 4 digits
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digitsOnly.length) {
        buffer.write(' ');
      }
    }
    final formatted = buffer.toString();

    // Calculate cursor position:
    // Count how many digits are before the original cursor position,
    // then add one space for each full group of 4 digits before it.
    int baseOffset = newValue.selection.baseOffset.clamp(0, newValue.text.length);
    String beforeCursor = newValue.text.substring(0, baseOffset);
    int digitsBeforeCursor = beforeCursor.replaceAll(RegExp(r'\D'), '').length;
    int spacesBeforeCursor = digitsBeforeCursor ~/ 4;
    int cursorPosition = digitsBeforeCursor + spacesBeforeCursor;

    cursorPosition = cursorPosition.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

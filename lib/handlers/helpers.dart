import 'package:flutter/services.dart';

class DecimalNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow empty input.
    if (newValue.text == '') return newValue;

    // Regex: can start with zero or more digits, maybe followed by a decimal
    // point, followed by zero, one, two, or three digits.
    return RegExp('^\\d*\\.?\\d?\\d?\\d?\$').hasMatch(newValue.text)
        ? newValue
        : oldValue;
  }
}

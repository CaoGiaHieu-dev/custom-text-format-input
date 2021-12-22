import 'package:flutter/services.dart';

import 'base_custom_input.dart';

class DateInputFormatter extends TextInputFormatter with BaseCustomInput {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var textEditting = newValue;
    //should be single char
    //if [inputChar.lenght > 1] it will throw error
    var inputChar = '';
    if (newValue.text.length > oldValue.text.length) {
      if (newValue.selection.baseOffset == newValue.text.length) {
        inputChar = newValue.text.substring(oldValue.text.length);
      } else {
        inputChar = newValue.text[newValue.selection.baseOffset - 1];
      }
    } else {
      inputChar = delete;
    }
    var newNumberInput = int.tryParse(inputChar);

    if (!inputChar.contains(delete)) {
      if (newValue.text.length > 10 || newNumberInput == null) {
        textEditting = oldValue;
      }
    }
    return textEditting;
  }
}

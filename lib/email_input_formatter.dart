import 'package:flutter/services.dart';

import 'base_custom_input.dart';

class EmailInputFormatter extends TextInputFormatter with BaseCustomInput {
  EmailInputFormatter({
    this.emailString = 'gmail.com',
  });
  final String emailString;
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
    var text = newValue.text;

    if (!inputChar.contains(delete)) {
      if (inputChar.contains('@')) {
        text = textEditting.text.substring(0, newValue.selection.baseOffset) +
            emailString +
            textEditting.text.substring(newValue.selection.baseOffset);
        textEditting = setNewTextInput(
          offset: newValue.selection.baseOffset,
          inputChar: emailString,
          text: text,
          textEditting: textEditting,
        );
      }
    }
    return textEditting;
  }
}

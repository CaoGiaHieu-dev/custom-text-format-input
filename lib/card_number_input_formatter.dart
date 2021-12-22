import 'package:flutter/services.dart';
import 'package:inputformat/base_custom_input.dart';

class CardNumberInputFormatter extends TextInputFormatter with BaseCustomInput {
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
    var text = newValue.text;
    var indexIncrease = 0;
    if (!inputChar.contains(delete)) {
      if (newValue.text.length > 19 || newNumberInput == null) {
        textEditting = oldValue;
      } else {
        if (' '.allMatches(newValue.text).isEmpty) {
          if (newValue.text.length == 4) {
            text += ' ';
          } else if (newValue.text.length > 4 &&
              ' '.allMatches(newValue.text).isEmpty) {
            text = text.replaceRange(4, 4, ' ');
          } else {
            indexIncrease = -1;
          }
        } else if (' '.allMatches(newValue.text).length == 1) {
          if (newValue.text.length == 9) {
            text += ' ';
          } else if (newValue.text.length > 9 &&
              ' '.allMatches(newValue.text).length == 1) {
            text = text.replaceRange(9, 9, ' ');
          } else {
            indexIncrease = -1;
          }
        } else if (' '.allMatches(newValue.text).length == 2) {
          if (newValue.text.length == 14) {
            text += ' ';
          } else if (newValue.text.length > 14 &&
              ' '.allMatches(newValue.text).length == 2) {
            text = text.replaceRange(14, 14, ' ');
          } else {
            indexIncrease = -1;
          }
        } else if (' '.allMatches(newValue.text).length == 3) {
          indexIncrease = -1;
        }
        textEditting = setNewTextInput(
            indexIncrease: indexIncrease,
            textEditting: textEditting,
            inputChar: inputChar,
            offset: newValue.selection.baseOffset,
            text: text);
      }
    } else {
      try {
        var preChar = text[newValue.selection.baseOffset - 1];
        if (preChar.contains(' ')) {
          indexIncrease = -1;
          text = newValue.text.replaceRange(newValue.selection.baseOffset - 1,
              newValue.selection.baseOffset, '');
          textEditting = setNewTextInput(
              offset: newValue.selection.baseOffset - 1,
              text: text,
              textEditting: textEditting);
        }
      } catch (_) {
        // if it throw error so that mean you are in the last of string
        // notthing go wrong
      }
    }
    return textEditting;
  }
}

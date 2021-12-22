import 'package:flutter/services.dart';

const String delete = 'Delete';

enum Type { email, phone, datetime, none, cardNumber, cardNumberDate }

class CustomInputFormat extends TextInputFormatter {
  CustomInputFormat({
    this.type = Type.none,
    this.emailString = 'gmail.com',
  });
  final Type type;
  final String emailString;
  TextEditingValue _setNewTextInput({
    required TextEditingValue textEditting,
    required String inputChar,
    int indexIncrease = 0,
    required int offset,
    required String text,
  }) {
    return TextEditingValue(
        composing: textEditting.composing,
        selection: TextSelection(
          baseOffset:
              (textEditting.text.substring(0, offset) + inputChar).length +
                  indexIncrease,
          extentOffset:
              (textEditting.text.substring(0, offset) + inputChar).length +
                  indexIncrease,
        ),
        text: text);
  }

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

    switch (type) {
      case Type.email:
        if (inputChar.contains('@')) {
          text = textEditting.text.substring(0, newValue.selection.baseOffset) +
              emailString +
              textEditting.text.substring(newValue.selection.baseOffset);
          textEditting = _setNewTextInput(
            offset: newValue.selection.baseOffset,
            inputChar: emailString,
            text: text,
            textEditting: textEditting,
          );
        }
        break;
      case Type.phone:
        if (!inputChar.contains(delete)) {
          if (newValue.text.length > 10 || newNumberInput == null) {
            textEditting = oldValue;
          }
        }
        break;
      case Type.datetime:
        var indexIncrease = 0;
        if (!inputChar.contains(delete)) {
          if (newValue.text.length > 10 || newNumberInput == null) {
            textEditting = oldValue;
          } else {
            if ('/'.allMatches(newValue.text).isEmpty) {
              if (newValue.text.length == 2) {
                text += '/';
              } else if (newValue.text.length > 2 &&
                  '/'.allMatches(newValue.text).isEmpty) {
                text = text.replaceRange(2, 2, '/');
                indexIncrease = 1;
              } else {
                indexIncrease = 0;
              }
              textEditting = _setNewTextInput(
                  offset: newValue.selection.baseOffset,
                  indexIncrease: indexIncrease,
                  text: text,
                  textEditting: textEditting,
                  inputChar: inputChar);
            } else if ('/'.allMatches(newValue.text).length == 1) {
              if (newValue.text.length == 5) {
                text += '/';
              } else if (newValue.text.length > 5 &&
                  '/'.allMatches(newValue.text).length == 1) {
                text = text.replaceRange(5, 5, '/');
                indexIncrease = 1;
              } else {
                indexIncrease = 0;
              }
              textEditting = _setNewTextInput(
                  indexIncrease: indexIncrease,
                  inputChar: inputChar,
                  offset: newValue.selection.baseOffset,
                  text: text,
                  textEditting: textEditting);
            }
          }
        } else {
          try {
            var preChar = text[newValue.selection.baseOffset - 1];
            if (preChar.contains('/')) {
              text = newValue.text.replaceRange(
                  newValue.selection.baseOffset - 1,
                  newValue.selection.baseOffset,
                  '');
              textEditting = _setNewTextInput(
                  inputChar: inputChar,
                  offset: newValue.selection.baseOffset,
                  text: text,
                  textEditting: textEditting);
            }
          } catch (_) {
            // if it throw error so that mean you are in the last of string
            // notthing go wrong
          }
        }
        break;
      case Type.cardNumber:
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
                indexIncrease = 1;
              } else {
                indexIncrease = 0;
              }
              textEditting = _setNewTextInput(
                  indexIncrease: indexIncrease,
                  textEditting: textEditting,
                  inputChar: inputChar,
                  offset: newValue.selection.baseOffset,
                  text: text);
            } else if (' '.allMatches(newValue.text).length == 1) {
              if (newValue.text.length == 9) {
                text += ' ';
              } else if (newValue.text.length > 9 &&
                  ' '.allMatches(newValue.text).length == 1) {
                text = text.replaceRange(9, 9, ' ');
                indexIncrease = 1;
              } else {
                indexIncrease = 0;
              }
              textEditting = _setNewTextInput(
                  indexIncrease: indexIncrease,
                  textEditting: textEditting,
                  inputChar: inputChar,
                  offset: newValue.selection.baseOffset,
                  text: text);
            } else if (' '.allMatches(newValue.text).length == 2) {
              if (newValue.text.length == 14) {
                text += ' ';
              } else if (newValue.text.length > 14 &&
                  ' '.allMatches(newValue.text).length == 2) {
                text = text.replaceRange(14, 14, ' ');
                indexIncrease = 1;
              } else {
                indexIncrease = 0;
              }
              textEditting = _setNewTextInput(
                  indexIncrease: indexIncrease,
                  textEditting: textEditting,
                  inputChar: inputChar,
                  offset: newValue.selection.baseOffset,
                  text: text);
            }
          }
        } else {
          try {
            var preChar = text[newValue.selection.baseOffset - 1];
            if (preChar.contains(' ')) {
              text = newValue.text.replaceRange(
                  newValue.selection.baseOffset - 1,
                  newValue.selection.baseOffset,
                  '');
              textEditting = TextEditingValue(
                  composing: textEditting.composing,
                  selection: TextSelection(
                    baseOffset: textEditting.text
                        .substring(0, newValue.selection.baseOffset)
                        .length,
                    extentOffset: (textEditting.text
                                .substring(0, newValue.selection.baseOffset) +
                            emailString)
                        .length,
                  ),
                  text: text);
            }
          } catch (_) {
            // if it throw error so that mean you are in the last of string
            // notthing go wrong
          }
        }

        break;
      case Type.cardNumberDate:
        var indexIncrease = 0;
        if (!inputChar.contains(delete)) {
          if (newValue.text.length > 5 || newNumberInput == null) {
            textEditting = oldValue;
          } else {
            if ('/'.allMatches(newValue.text).isEmpty) {
              if (newValue.text.length == 2) {
                text += '/';
              } else if (newValue.text.length > 2 &&
                  '/'.allMatches(newValue.text).isEmpty) {
                text = text.replaceRange(2, 2, '/');
                indexIncrease = 1;
              } else {
                indexIncrease = 0;
              }
              textEditting = _setNewTextInput(
                  offset: newValue.selection.baseOffset,
                  indexIncrease: indexIncrease,
                  text: text,
                  textEditting: textEditting,
                  inputChar: inputChar);
            }
          }
        } else {
          try {
            var preChar = text[newValue.selection.baseOffset - 1];
            if (preChar.contains('/')) {
              text = newValue.text.replaceRange(
                  newValue.selection.baseOffset - 1,
                  newValue.selection.baseOffset,
                  '');
              textEditting = _setNewTextInput(
                  inputChar: inputChar,
                  offset: newValue.selection.baseOffset,
                  text: text,
                  textEditting: textEditting);
            }
          } catch (_) {
            // if it throw error so that mean you are in the last of string
            // notthing go wrong
          }
        }
        break;
      default:
        textEditting = newValue;
    }
    return textEditting;
  }
}

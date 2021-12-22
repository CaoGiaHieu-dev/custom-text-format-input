import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String delete = 'Delete';

enum Type { email, phone, datetime, none, cardNumber, cardNumberDate }

class BaseCustomInput {
  TextEditingValue setNewTextInput({
    String inputChar = '',
    int indexIncrease = 0,
    required TextEditingValue textEditting,
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
}

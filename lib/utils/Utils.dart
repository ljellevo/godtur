

import 'package:flutter/cupertino.dart';

class Utils {
  
  void setTextInTextField(TextEditingController controller, String text){
    controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.fromPosition(
          TextPosition(offset: text.length),
        ),
      );
  }
}
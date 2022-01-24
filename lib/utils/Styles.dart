

import 'package:flutter/material.dart';

class Styles {
  
  ButtonStyle lowProfileRoundButton(bool withShadow) {
    if(withShadow) {
      return  ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Color(0xff0D2138)),
        fixedSize: MaterialStateProperty.all<Size>(Size.fromWidth(100)),
        shadowColor: MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.5)),
        elevation: MaterialStateProperty.all<double>(10),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        animationDuration: Duration.zero,
        splashFactory: NoSplash.splashFactory,
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
          color: Color(0xff0D2138),
          fontSize: 12
        ))
      );
    } else {
      return  ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Color(0xff0D2138)),
        fixedSize: MaterialStateProperty.all<Size>(Size.fromWidth(100)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        animationDuration: Duration.zero,
        splashFactory: NoSplash.splashFactory,
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
          color: Color(0xff0D2138),
          fontSize: 12
        ))
      );
    }
  }
  
  
  ButtonStyle roundButton(Color textColor, Color backgroundColor) {
    return  ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(15, 5, 15, 5)),
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        foregroundColor: MaterialStateProperty.all<Color>(textColor),
        //fixedSize: MaterialStateProperty.all<Size>(Size.fromWidth(150)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        animationDuration: Duration.zero,
        splashFactory: InkRipple.splashFactory,
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
          color: textColor,
          fontSize: 12
        ))
      );
  }
}
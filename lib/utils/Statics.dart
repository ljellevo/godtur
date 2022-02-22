
import 'package:flutter/material.dart';

class Statics {
  static const String LESS_THAN_TWO_LOCATIONS_MESSAGE = "Vennligst velg minimum to lokasjoner";
  static const String INFORMATION_DISSMISSABLE_CARD_MESSAGE = "hei, dette er en informasjons boks hvor man kan lese kjapt om hva som blir presentert på denne siden";
  static const String SEARCHFIELD_PLACEHOLDER_TEXT = "Søk etter lokasjon";
}

class Styles {
  static const Color primary = Color(0xff0D2138); //F83C3C
  static const Color secondary = Color(0xffF83C3C);
  static const Color blue = Color.fromRGBO(25, 118, 210, 1);
  static const Color red = Color.fromRGBO(211, 47, 47, 1);
  static const Color accent = Color.fromRGBO(117, 117, 117, 1);
  static const Color error = Color.fromRGBO(238, 132, 52, 1);
  
  static const Color primaryVariant = Color.fromRGBO(81, 91, 58, 1);
  
  
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
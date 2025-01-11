import 'package:flutter/material.dart';

class Custom {
  static const Color colorDefault = Colors.white;
  static Text header1(String txt,
      {Color color = colorDefault, bool isBold = false}) {
    return Text(
      txt,
      style: TextStyle(
          color: color,
          fontSize: 36,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500),
    );
  }

  static Text header2(String txt,
      {Color color = colorDefault, bool isBold = false}) {
    return Text(
      txt,
      style: TextStyle(
          color: color,
          fontSize: 32,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500),
    );
  }

  static Text header3(String txt,
      {Color color = colorDefault, bool isBold = false}) {
    return Text(
      txt,
      style: TextStyle(
          color: color,
          fontSize: 24,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500),
    );
  }

  static Text subheader1(String txt,
      {Color color = colorDefault, bool isBold = false}) {
    return Text(
      txt,
      style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500),
    );
  }

  static Text body1(String txt,
      {Color color = colorDefault, bool isBold = false, TextAlign? textAlign}) {
    return Text(
      txt,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500),
    );
  }

  static Text body2(String txt,
      {Color color = colorDefault, bool isBold = false}) {
    return Text(
      txt,
      style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500),
    );
  }

  static Text body3(String txt,
      {Color color = colorDefault, bool isBold = false}) {
    return Text(
      txt,
      style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500),
    );
  }
}

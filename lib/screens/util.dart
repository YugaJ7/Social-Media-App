import 'package:flutter/material.dart';
class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomText({
    required this.text,
    required this.color,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? Colors.white,
          fontSize: fontSize ?? 10,
          fontWeight: fontWeight),
    );
  }
}


class Button extends StatelessWidget {
  final String text;
  final String fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const Button({
    super.key,
    required this.text,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.onPressed,
    required this.backgroundColor,
    required this.borderRadius,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(
        color: Colors.white,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight
      ),),
    );
  }
}
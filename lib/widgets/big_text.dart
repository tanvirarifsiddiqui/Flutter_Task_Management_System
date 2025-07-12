import 'package:flutter/material.dart';

import '../utils/dimentions.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  final double size;
  // TextOverflow overflow;

  BigText({
    Key? key,
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 20,
    // this.overflow = TextOverflow.ellipsis, //
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size == 0 ? Dimentions.font20 : size,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

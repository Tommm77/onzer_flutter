import 'package:flutter/material.dart';

class MyCustomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();
    path.lineTo(0, size.height * 0.45);
    path.cubicTo(size.width * 0.33, size.height * 0.4, size.width * 0.66,
        size.height * 0.6, size.width, size.height * 0.45);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

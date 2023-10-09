import 'package:flutter/material.dart';

class OnBoardingTriangleClipper extends CustomClipper<Path> {
  // this method is used to draw triangle in disired way
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height - 100)
      ..lineTo(0, size.height - 100)
      ..lineTo(0, size.height - 100)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

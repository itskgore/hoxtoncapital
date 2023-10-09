import 'package:flutter/material.dart';
import 'package:wedge/core/utils/triangle_clipper.dart';

class TriangleOnboarding extends StatelessWidget {
  final top;
  final bottom;
  final color;
  final left;
  final right;
  const TriangleOnboarding(
      {this.top, this.bottom, this.color, this.left = 0.0, this.right = 0.0});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: ClipPath(
        clipper: OnBoardingTriangleClipper(),
        child: Container(
          color: color,
        ),
      ),
    );
  }
}

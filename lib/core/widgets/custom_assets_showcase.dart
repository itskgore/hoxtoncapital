import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../contants/theme_contants.dart';
import '../utils/wedge_func_methods.dart';

class ShowcaseContainer extends StatelessWidget {
  final GlobalKey showcaseKey;
  final Widget child;

  const ShowcaseContainer({
    super.key,
    required this.showcaseKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: showcaseKey,
      disposeOnTap: true,
      disableMovingAnimation: true,
      height: 50,
      width: 335,
      targetPadding: EdgeInsets.zero,
      container: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: CustomShowcaseShape(usePadding: false),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffEA943E).withOpacity(.1),
                      borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/icons/reconnect_icon.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  translate!.reconnectAccountLaterFromHere,
                  style: SubtitleHelper.h11.copyWith(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text("${translate!.okay}>>",
                style: TitleHelper.h11.copyWith(
                    color: const Color(0xFF192C63),
                    decoration: TextDecoration.underline))
          ],
        ),
      ),
      child: child,
    );
  }
}

class CustomShowcaseShape extends ShapeBorder {
  final bool usePadding;
  final double? arrowDistanceFromMiddle;
  CustomShowcaseShape({this.arrowDistanceFromMiddle, this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 20 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(rect.topLeft + const Offset(0, 5), rect.bottomRight);
    final middleX = rect.width / 2;
    final arrowX = middleX +
        (arrowDistanceFromMiddle ??
            size.width *
                .45); // Adjust this value to move the arrow closer to the top-right corner
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
          rect,
          const Radius.circular(
              8))) // Rounded rectangle with a border radius of 8
      ..moveTo(arrowX - 5,
          rect.top) // Move the arrow between the top-middle and top-right
      ..lineTo(arrowX,
          rect.top - 5) // Create the equilateral triangle (5 pixels in height)
      ..lineTo(arrowX + 5, rect.top)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerContainer extends StatelessWidget {
  final double? height;
  const CustomShimmerContainer({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black54,
      highlightColor: Colors.grey.withOpacity(0.2),
      child: Container(
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(10))),
    );
  }
}

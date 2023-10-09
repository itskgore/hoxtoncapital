import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

import '../../../../../core/utils/wedge_func_methods.dart';

class CustomStepper extends StatelessWidget {
  const CustomStepper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double lineLength = size.height * .025;
    double linePadding = 8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        step(title: "Personalising the app"),
        stapperLine(lineLength: lineLength, linePadding: linePadding),
        step(title: "Add assets & liabilities account", isCompleted: false),
        stapperLine(lineLength: lineLength, linePadding: linePadding),
        step(title: "Go to dashboard to view net-worth", isCompleted: false),
      ],
    );
  }

  Widget step({required String title, bool isCompleted = true}) {
    double emptyStepperSize = 9;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: isCompleted
                  ? const Color.fromRGBO(16, 145, 126, 1)
                  : const Color.fromRGBO(246, 247, 252, 1),
              border: isCompleted
                  ? null
                  : Border.all(color: appThemeColors!.primary!, width: 1.3),
              borderRadius: BorderRadius.circular(100)),
          child: isCompleted
              ? const Icon(
                  Icons.check_rounded,
                  size: 13,
                  color: Colors.white,
                )
              : SizedBox(
                  height: emptyStepperSize,
                  width: emptyStepperSize,
                ),
        ),
        Text(title, style: TitleHelper.h11.copyWith(color: Colors.black)),
      ],
    );
  }
}

class stapperLine extends StatelessWidget {
  const stapperLine({
    Key? key,
    required this.lineLength,
    required this.linePadding,
  }) : super(key: key);

  final double lineLength;
  final double linePadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: linePadding),
      child: Dash(
          direction: Axis.vertical,
          length: lineLength,
          dashLength: 2,
          dashThickness: 1.5,
          dashColor: Colors.black26),
    );
  }
}

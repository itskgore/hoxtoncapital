import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class CalculatorValueContainer extends StatefulWidget {
  final String title;
  final Function onPlusPressed;
  final Function onMinusPressed;
  final String text;

  const CalculatorValueContainer(
      {Key? key,
      required this.title,
      required this.onPlusPressed,
      required this.onMinusPressed,
      required this.text})
      : super(key: key);

  @override
  _CalculatorValueContainerState createState() =>
      _CalculatorValueContainerState();
}

class _CalculatorValueContainerState extends State<CalculatorValueContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: kfontMedium,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  widget.onMinusPressed();
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kborderRadius),
                      color: appThemeColors!.primary!.withOpacity(0.2)),
                  child: const Center(
                      child: Text(
                    "-",
                    style: TextStyle(
                        fontSize: kfontLarge, fontWeight: FontWeight.w600),
                  )),
                ),
              ),
            ),
            Expanded(
                child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kborderRadius),
                  color: Colors.white),
              child: Center(child: Text(widget.text)),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  widget.onPlusPressed();
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kborderRadius),
                      color: appThemeColors!.primary!.withOpacity(0.2)),
                  child: const Center(
                      child: Text(
                    "+",
                    style: TextStyle(
                        fontSize: kfontLarge, fontWeight: FontWeight.w600),
                  )),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

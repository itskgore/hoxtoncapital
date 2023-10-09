import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:lottie/lottie.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';

class WedgeSaveButton extends StatefulWidget {
  final Function()? onPressed;
  final String title;
  final bool isLoaing;
  final bool isLoaded;
  final isEnable;
  final TextStyle? textStyle;
  const WedgeSaveButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.isLoaded = false,
      required this.isLoaing,
      this.textStyle,
      this.isEnable})
      : super(key: key);

  @override
  State<WedgeSaveButton> createState() => _WedgeSaveButtonState();
}

class _WedgeSaveButtonState extends State<WedgeSaveButton>
    with TickerProviderStateMixin {
  late AnimationController _submitDoneController;

  @override
  void initState() {
    _submitDoneController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoaded) {
      _submitDoneController.reset();
      _submitDoneController.forward();
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: widget.isEnable ?? true ? null : 0,
          backgroundColor: widget.isLoaded
              ? const Color.fromRGBO(77, 155, 75, 1)
              : widget.isEnable ?? true
                  ? appThemeColors!.primary
                  : appThemeColors!.primary!.withOpacity(.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      onPressed: widget.isEnable ?? true ? widget.onPressed : () {},
      child: widget.isLoaing
          ? buildCircularProgressIndicator()
          : widget.isLoaded
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Lottie.asset(Icons8.check_circle_office_style,
                      controller: _submitDoneController,
                      height: 35,
                      width: 35,
                      fit: BoxFit.fill),
                )
              : Text(
                  widget.title,
                  style: widget.textStyle ??
                      TextStyle(
                          fontSize: appThemeSubtitleSizes!.h10,
                          color: appThemeColors!.buttonText),
                ),
    );
  }
}

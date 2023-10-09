import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class FooterButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final double? width;
  const FooterButton({required this.text, required this.onTap, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: width ?? double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: appThemeColors!.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            onPressed: () {
              onTap();
            },
            child: Text(text,
                style: SubtitleHelper.h10
                    .copyWith(color: appThemeColors!.buttonText)),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';

class CustomDialogBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String successMessage;
  final String notes;
  final Function onPressedPositive;
  final Function onPressedNegative;

  CustomDialogBox({
    required this.icon,
    required this.title,
    required this.successMessage,
    required this.notes,
    required this.onPressedPositive,
    required this.onPressedNegative,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 30.0,
            left: 16.0,
            right: 16.0,
          ),
          margin: const EdgeInsets.only(top: 16.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                "${appIcons.successIcon}",
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 16.0),
              Text(
                title,
                style: TitleHelper.h7.copyWith(
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                successMessage,
                textAlign: TextAlign.center,
                style: SubtitleHelper.h12,
              ),
              const SizedBox(height: 24.0),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Note: ', style: TitleHelper.h12),
                        TextSpan(text: notes, style: SubtitleHelper.h12),
                      ],
                    ),
                  )),
              const SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                              color: appThemeColors!.primary!, width: 2),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          fixedSize: const Size(0, 60),
                        ),
                        onPressed: () {
                          onPressedNegative();
                        },
                        child: Text(
                          translate!.viewDashboard,
                          style: SubtitleHelper.h12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                              color: appThemeColors!.primary!, width: 2),
                          backgroundColor: appThemeColors!.primary!,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          fixedSize: const Size(0, 60),
                        ),
                        onPressed: () {
                          onPressedPositive();
                        },
                        child: Text(
                          translate!.addMore,
                          style: SubtitleHelper.h12
                              .copyWith(color: appThemeColors!.textLight),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

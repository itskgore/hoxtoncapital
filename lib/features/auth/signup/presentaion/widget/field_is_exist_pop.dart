import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/contants/theme_contants.dart';
import '../../../../../core/utils/wedge_func_methods.dart';

class FieldIsExistPop extends StatelessWidget {
  const FieldIsExistPop({
    Key? key,
    this.userEmail,
  }) : super(key: key);

  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200, width: 1),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(
              "assets/icons/warning.png",
              height: 20,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                  text: translate!.itLooksLikeYouHaveAlreadySignedUp,
                  style:
                      SubtitleHelper.h10.copyWith(color: Colors.red.shade900),
                  children: [
                    TextSpan(
                        text: translate!.log_In,
                        style: TitleHelper.h9.copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            RootApplicationAccess()
                                .navigateToLogin(context, userEmail: userEmail);
                          }),
                    TextSpan(text: translate!.toYourAccount)
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

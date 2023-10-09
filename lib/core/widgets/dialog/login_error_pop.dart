import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';

import '../../../app.dart';
import '../../contants/string_contants.dart';
import '../../contants/theme_contants.dart';
import '../../utils/wedge_snackBar.dart';
import 'wedge_new_custom_dialog_box.dart';

void showLoginErrorPop({String? errorMsg}) {
  void _launchEmailApp(String emailAddress) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri).then((value) {
        Navigator.pop(navigatorKey.currentContext!);
      });
    } else {
      showSnackBar(
          context: navigatorKey.currentContext!,
          title: translate!.couldNotLaunchEmailApp);
      throw translate!.couldNotLaunchEmailApp;
    }
  }

  showDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          // Return false to restrict the back button when the dialog is visible
          return false;
        },
        child: NewCustomDialogBox(
          onPressedPrimary: () {
            Navigator.pop(navigatorKey.currentContext!);
          },
          showWarningIcon: true,
          primaryButtonText: translate!.tryAgain,
          title: translate!.error,
          description: errorMsg ?? translate!.loginErrorMessage,
          descriptionStyle:
              SubtitleHelper.h11.copyWith(color: Colors.red.shade900),
          content: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: translate!.loginIssue,
                style: SubtitleHelper.h11,
                children: [
                  TextSpan(
                    text: supportEmail,
                    style: SubtitleHelper.h11.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchEmailApp(supportEmail);
                      },
                  )
                ]),
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/widgets/dialog/wedge_new_custom_dialog_box.dart';

abstract class WedgeDialog {
  // to display an information with just ok button
  Future<void> info(BuildContext context, String title, String description);

  Future<void> success(
      {required BuildContext context,
      required String title,
      bool? showTitleOnly,
      String? buttonLabel,
      required String info,
      bool? isDissmisable,
      required Function onClicked});

  Future<void> failure(
      {required BuildContext context, required Function onClicked});

  //to confirm an action with customizable widgets ex: logout confirmation
  Future<void> confirm(BuildContext context, Widget alertDialog);

  Future<void> forgotPassword(context,
      {required Function onClicked, required String email});

  Future<void> resetPasswordSuccess(context, {required Function onClicked});
}

class WedgeDialogImpl implements WedgeDialog {
  @override
  Future<void> info(BuildContext context, String title, String description) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Return false to restrict the back button when the dialog is visible
            return false;
          },
          child: NewCustomDialogBox(
            title: title,
            description: description,
            onPressedPrimary: () {
              Navigator.of(context).pop();
            },
            primaryButtonText: translate!.ok,
          ),
        );
      },
    );
  }

  @override
  Future<void> confirm(BuildContext context, alertDialog) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              // Return false to restrict the back button when the dialog is visible
              return false;
            },
            child: alertDialog);
      },
    );
  }

  @override
  Future<void> success(
      {required BuildContext context,
      required String title,
      required String info,
      bool? showTitleOnly,
      String? buttonLabel,
      bool? isDissmisable,
      required Function onClicked}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Return false to restrict the back button when the dialog is visible
            return false;
          },
          child: NewCustomDialogBox(
              onPressedPrimary: () {
                onClicked();
              },
              title: showTitleOnly ?? false
                  ? title
                  : info == "" || info.isEmpty
                      ? translate!.success
                      : title,
              primaryButtonText: buttonLabel ?? translate!.continueWord,
              description: showTitleOnly ?? false
                  ? ""
                  : info == "" || info.isEmpty
                      ? title
                      : info),
        );
      },
    );
  }

  @override
  Future<void> failure(
      {required BuildContext context, required Function onClicked}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Return false to restrict the back button when the dialog is visible
            return false;
          },
          child: NewCustomDialogBox(
            isTitleIconVisible: true,
            showWarningIcon: true,
            title: "${translate?.oops} !",
            description: "${translate!.somethingWentWrong}!",
            primaryButtonText: translate!.ok,
            onPressedPrimary: () {
              onClicked();
            },
          ),
        );
      },
    );
  }

  @override
  Future<void> forgotPassword(context,
      {required Function onClicked, required String email}) {
    email = email.replaceAll(
        RegExp(r'(?<=.{1}).(?=.*@)'), '*'); //masking email with *
    // TODO: implement forgotPassword
    return showDialog<void>(
      barrierColor: Colors.black45,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Return false to restrict the back button when the dialog is visible
            return false;
          },
          child: NewCustomDialogBox(
            title: translate!.forgotYourPassword,
            description:
                "An email with a reset link will be sent to your registered email id $email",
            primaryButtonText: "Send Password Reset Link",
            onPressedPrimary: () {
              onClicked();
            },
          ),
        );
      },
    );
  }

  @override
  Future<void> resetPasswordSuccess(
    context, {
    required Function onClicked,
  }) {
    // TODO: implement forgotPassword
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Return false to restrict the back button when the dialog is visible
            return false;
          },
          child: NewCustomDialogBox(
            title: "Email sent successfully!",
            description:
                "We’ve just sent the reset instructions to your registered email id successfully.",
            onPressedPrimary: () {
              onClicked();
            },
            primaryButtonText: "OK",
          ),
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/widgets/dialog/wedge_new_custom_dialog_box.dart';

class WedgeConfirmDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String acceptText;
  final String deniedText;
  final Color? primaryButtonColor;
  final bool showReconnectIcon;
  final Function()? acceptedPress;
  final Function()? deniedPress;

  const WedgeConfirmDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.acceptedPress,
    required this.deniedPress,
    required this.acceptText,
    required this.deniedText,
    this.primaryButtonColor,
    this.showReconnectIcon = false,
  }) : super(key: key);

  @override
  StatelessWidget build(BuildContext context) {
    return NewCustomDialogBox(
      title: title,
      isTitleIconVisible: showReconnectIcon,
      description: subtitle,
      primaryButtonText: acceptText,
      onPressedPrimary: acceptedPress,
      secondaryButtonText: deniedText,
      showReconnectIcon: showReconnectIcon,
      primaryButtonColor: primaryButtonColor,
      onPressedSecondary: deniedPress,
    );
  }
}

// import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:custom_social_share/custom_social_share.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';

import '../../../../core/contants/theme_contants.dart';

class CopyLinkButton extends StatelessWidget {
  final String linkToCopy;
  final String userName;

  const CopyLinkButton(
      {super.key, required this.linkToCopy, required this.userName});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(width: 1, color: Colors.grey),
      ),
      onPressed: () async {
        CustomSocialShare().copy(linkToCopy);
        showSnackBar(context: context, title: translate!.linkCopiedToClipboard);
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Text(
            userName,
            overflow: TextOverflow.ellipsis,
            style: SubtitleHelper.h11.copyWith(
                color: appThemeColors!.loginColorTheme!.textSubtitleColor,
                fontWeight: FontWeight.w400),
          ),
        ),
        Image.asset(
          "assets/icons/copy_icon.png",
          scale: 3.5,
        )
      ]),
    );
  }
}

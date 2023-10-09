import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../contants/theme_contants.dart';
import '../utils/wedge_colors.dart';

class FolderTile extends StatelessWidget {
  const FolderTile(
      {required this.title,
      this.onTap,
      this.subTitle,
      this.buttonText,
      this.isSubtitleDate = false,
      super.key});

  final void Function()? onTap;
  final String title;
  final String? subTitle;
  final String? buttonText;
  final bool isSubtitleDate;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 9.9, spreadRadius: 0.5),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          onTap: onTap,
          minVerticalPadding: subTitle == null || subTitle!.isEmpty ? 20 : 0,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: lighten(WedgeColors.iconColor, .6),
                borderRadius: BorderRadius.circular(6)),
            child: Icon(
              Icons.folder,
              color: WedgeColors.iconColor.withOpacity(.8),
              size: 23,
            ),
          ),
          title: Text(
            title,
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: SubtitleHelper.h10.copyWith(
              color: appThemeColors!.textDark,
            ),
          ),
          subtitle: subTitle == null || subTitle!.isEmpty
              ? null
              : Text(
                  subTitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SubtitleHelper.h12.copyWith(
                    fontWeight: isSubtitleDate ? FontWeight.w600 : null,
                    color: Colors.black,
                  ),
                ),
          trailing: buttonText != null
              ? const UploadButton()
              : const Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
        ));
  }
}

class UploadButton extends StatelessWidget {
  const UploadButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 80,
      decoration: BoxDecoration(
        color: appThemeColors!.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      //Todo: static
      child: Center(
        child: Text(
          'Upload',
          style: SubtitleHelper.h12.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class BeneficiaryTextField extends StatelessWidget {
  final String title;
  final String placeholder;
  final String? Function(String?) validator;
  final TextEditingController controller;

  BeneficiaryTextField(
      {Key? key,
      required this.title,
      required this.placeholder,
      required this.validator,
      required this.controller})
      : super(key: key);
  AppLocalizations? translate;

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    var underlineInputBorder = UnderlineInputBorder(
        borderSide: BorderSide(
            width: 0.5, color: lighten(appThemeColors!.disableText!, .2)));
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          Text(
            "${title}",
            style: SubtitleHelper.h10,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: validator,
            controller: controller,
            textAlign: TextAlign.center,
            style: SubtitleHelper.h10.copyWith(
              color: appThemeColors!.outline,
              fontStyle: FontStyle.italic,
            ),
            decoration: InputDecoration(
              disabledBorder: underlineInputBorder,
              focusedBorder: underlineInputBorder,
              enabledBorder: underlineInputBorder,
              border: underlineInputBorder,
              hintStyle: SubtitleHelper.h10.copyWith(
                  fontStyle: FontStyle.italic,
                  color: lighten(appThemeColors!.textDark!, .5)),
              hintText: placeholder,
            ),
          ),
        ],
      ),
    );
  }
}

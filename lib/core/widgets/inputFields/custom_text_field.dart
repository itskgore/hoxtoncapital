import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/app_config.dart';
import '../../contants/theme_contants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  final String? hint;
  final bool? isRequired;
  final bool readOnly;
  final bool isFieldHaveError;
  final Function()? onTab;
  final Function()? onEditingComplete;
  final FocusNode? focusNode;
  final Function? onChanged;
  final String? Function(String?)? validator;
  final bool? showSuffixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final int? maxLength;
  final bool? obscureText;
  final Widget? suffix;

  const CustomTextField(
      {Key? key,
      required this.controller,
      this.title,
      this.validator,
      this.keyboardType,
      this.showSuffixIcon,
      this.hint,
      this.onTab,
      this.isFieldHaveError = false,
      this.readOnly = false,
      this.onEditingComplete,
      this.focusNode,
      this.onChanged,
      this.maxLength,
      this.inputFormatters,
      this.prefix,
      this.suffix,
      this.suffixIcon,
      this.obscureText,
      this.isRequired = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var border = ktextFeildOutlineInputBorder.copyWith(
        borderSide: BorderSide(
            color:
                isFieldHaveError ? Colors.red : appThemeColors!.disableLight!,
            width: 1));
    var focusBorder = ktextFeildOutlineInputBorder.copyWith(
        borderSide: BorderSide(
            color: isFieldHaveError ? Colors.red : appThemeColors!.primary!,
            width: isFieldHaveError ? 1 : 0.5));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RichText(
                  text: TextSpan(
                      text: "$title",
                      style: TitleHelper.h11.copyWith(
                          fontWeight: FontWeight.normal,
                          color: readOnly
                              ? appThemeColors!.primary!.withOpacity(.5)
                              : appThemeColors!.primary!),
                      children: [
                        TextSpan(
                          text: isRequired ?? false ? " * " : "",
                          style: SubtitleHelper.h10.copyWith(
                              color: readOnly
                                  ? Colors.redAccent.withOpacity(.5)
                                  : Colors.redAccent),
                        )
                      ]),
                )),
        TextFormField(
          controller: controller,
          onTap: onTab,
          obscureText: obscureText ?? false,
          validator: validator,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          onEditingComplete: onEditingComplete,
          readOnly: readOnly,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.done,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          style: TextStyle(
              color: appThemeColors!.loginColorTheme!.textFieldTextStyle),
          decoration: InputDecoration(
              prefixIcon: prefix,
              suffix: suffix,
              focusColor: appThemeColors!.textLight,
              hoverColor: appThemeColors!.textLight,
              suffixIcon: showSuffixIcon ?? false
                  ? suffixIcon ??
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: appThemeColors!.primary,
                      )
                  : null,
              filled: true,
              fillColor: appThemeColors!.loginColorTheme!.textFieldFillColor,
              border: border,
              enabledBorder: border,
              disabledBorder: border,
              focusedBorder: readOnly ? border : focusBorder,
              hintText: hint,
              hintStyle: SubtitleHelper.h11
                  .copyWith(color: appThemeColors!.disableDark),
              errorStyle: kerrorTextstyle,
              errorMaxLines: 3),
        ),
      ],
    );
  }
}

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;

    String formattedValue = '';

    for (int i = 0; i < newTextLength; i += 3) {
      final int endIndex = i + 3;
      if (endIndex < newTextLength) {
        formattedValue += '${newValue.text.substring(i, endIndex)},';
      } else {
        formattedValue += newValue.text.substring(i);
        break;
      }
    }

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: selectionIndex + 1),
    );
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return const TextEditingValue();
    } else if (int.parse(newValue.text) < 1) {
      return const TextEditingValue().copyWith(text: '1');
    }

    return int.parse(newValue.text) > 20
        ? const TextEditingValue().copyWith(text: '20')
        : newValue;
  }
}

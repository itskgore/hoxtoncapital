import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/widgets/inputFields/currency_text_feild.dart';

import '../../contants/theme_contants.dart';

class CustomFormTextField extends StatelessWidget {
  CustomFormTextField({
    required this.textEditingController,
    required this.hintText,
    this.validator,
    this.enabled,
    this.onTap,
    this.isDemicalAllowed,
    this.paddingBottom,
    this.onChanged,
    this.autoFocused,
    this.allowNum,
    this.readOnly,
    this.decimalAllowed,
    this.noRestriction,
    this.inputDecoration,
    this.suffixWidget,
    this.inputType = TextInputType.number,
    Key? key,
  }) : super(key: key);

  final String hintText;
  bool? enabled;
  bool? noRestriction;
  bool? autoFocused;
  bool? isDemicalAllowed;
  double? paddingBottom;
  int? decimalAllowed;
  bool? allowNum;
  bool? readOnly;
  Widget? suffixWidget;
  InputDecoration? inputDecoration;
  Function()? onTap;
  Function(String)? onChanged;
  final TextEditingController textEditingController;
  final TextInputType inputType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 73,
      padding: EdgeInsets.only(bottom: paddingBottom ?? 15),
      child: TextFormField(
          readOnly: readOnly ?? false,
          autofocus: autoFocused ?? false,
          onTap: onTap ?? () {},
          style: TextStyle(
            color: enabled ?? true ? Colors.black : Colors.black38,
            fontFamily: appThemeHeadlineFont,
          ),
          enabled: enabled ?? true,
          controller: textEditingController,
          inputFormatters: (inputType == TextInputType.number ||
                  inputType ==
                      const TextInputType.numberWithOptions(decimal: true))
              ? <TextInputFormatter>[
                  DecimalTextInputFormatter(decimalRange: decimalAllowed ?? 2),
                  isDemicalAllowed ?? true
                      ? FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
                      : FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                  FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)'))
                ]
              : allowNum ?? false
                  ? [
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z0-9. ]")),
                    ]
                  : noRestriction ?? false
                      ? null
                      : [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z ]")),
                        ],
          onChanged: onChanged,
          validator: validator,
          decoration: inputDecoration ??
              InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 17.0, horizontal: 12),
                  fillColor: enabled ?? true
                      ? Colors.white
                      : appThemeColors!.primary!.withOpacity(0.01),
                  filled: true,
                  suffixIcon: suffixWidget != null
                      ? SizedBox(
                          width: 60.0,
                          child: Center(
                            child: suffixWidget,
                          ),
                        )
                      : null,
                  labelText: hintText,
                  labelStyle: labelStyle,
                  enabledBorder: ktextFeildOutlineInputBorder,
                  focusedBorder: ktextFeildOutlineInputBorderFocused,
                  border: ktextFeildOutlineInputBorder),
          keyboardType: inputType),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class GenericTextField extends StatelessWidget {
  Key? key;
  String? Function(String?)? validator;
  dynamic Function(String?)? onSaved;
  Function(String)? onFieldSubmitted;
  Function(String)? onChanged;
  String? placeholder;
  TextInputType? type;
  double? borderRadius;
  bool? isFilled;
  Color? filledColor;
  TextStyle? hintTextStyle;
  bool? hasBorder;
  bool? obscureText;
  TextAlign? textAlign;
  Widget? suffixWidget;
  EdgeInsets? contentPadding;
  Widget? prefixWidget;
  TextEditingController? textController;
  bool? autoFocus;
  int? maxLength;
  InputDecoration? decoration;
  GenericTextField(
      {this.key,
      this.validator,
      this.onSaved,
      this.placeholder,
      this.type,
      this.prefixWidget,
      this.maxLength,
      this.onFieldSubmitted,
      this.obscureText,
      this.suffixWidget,
      this.borderRadius,
      this.isFilled,
      this.filledColor,
      this.hintTextStyle,
      this.hasBorder,
      this.textAlign,
      this.onChanged,
      this.textController,
      this.autoFocus,
      this.decoration})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: maxLength,
        autofocus: autoFocus ?? false,
        inputFormatters: type == TextInputType.number
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ]
            : null,
        controller: textController ?? null,
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.5),
        keyboardType: type ?? TextInputType.text,
        obscureText: obscureText ?? false,
        textAlign: textAlign ?? TextAlign.start,
        decoration: decoration ??
            InputDecoration(
              errorMaxLines: 3,
              contentPadding: contentPadding ??
                  const EdgeInsets.symmetric(vertical: 17.0, horizontal: 12),
              filled: true,
              suffixIcon: suffixWidget,
              prefixIcon: prefixWidget,
              fillColor: Colors.white,
              border: ktextFeildOutlineInputBorder,
              enabledBorder: ktextFeildOutlineInputBorder,
              focusedBorder: ktextFeildOutlineInputBorderFocused,
              labelStyle: labelStyle,
              labelText: placeholder,
            ),
        onChanged: onChanged ?? (_) {},
        validator: validator ?? (_) {},
        onSaved: onSaved ?? (_) {},
        onFieldSubmitted: onFieldSubmitted ?? (_) {});
  }
}

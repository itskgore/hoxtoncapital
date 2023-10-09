import 'package:flutter/material.dart';

import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../core/widgets/inputFields/custom_text_field.dart';
import 'circular_check_box.dart';

class NewPasswordField extends StatefulWidget {
  final bool readOnly;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function? onChanged;

  const NewPasswordField({
    super.key,
    this.readOnly = false,
    required this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  State<NewPasswordField> createState() => _NewPasswordFieldState();
}

class _NewPasswordFieldState extends State<NewPasswordField> {
  String passwordHidden = "assets/icons/passwordHidden.png";
  String passwordShow = "assets/icons/passwordShow.png";
  bool showPassword = true;
  bool isChecked = false;

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.removeListener(_passwordFocusChange);
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Widget _passwordFocusChange() {
    if (_passwordFocusNode.hasFocus) {
      //criteria
      return Visibility(
        visible: !_isPasswordValid() && !widget.readOnly,
        child: Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(1, 2), blurRadius: 5)
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isPasswordValid())
                Text("${translate!.passwordMustMeetTheFollowingRequirements}:"),
              const SizedBox(height: 7),
              Row(
                children: [
                  CircularCheckBox(
                    value: hasMinLength,
                  ),
                  Text(translate!.mustHaveMin8AndMax16characters),
                ],
              ),
              Row(
                children: [
                  CircularCheckBox(
                    value: hasDigit,
                  ),
                  Text(translate!.mustHave1Numeric),
                ],
              ),
              Row(
                children: [
                  CircularCheckBox(
                    value: hasSpecialChar,
                  ),
                  Text(translate!.mustHave1SpecialCharacter),
                ],
              ),
              Row(
                children: [
                  CircularCheckBox(
                    value: hasUppercase,
                  ),
                  Text(translate!.mustHave1UpperCase),
                ],
              ),
              Row(
                children: [
                  CircularCheckBox(
                    value: hasLowercase,
                  ),
                  Text(translate!.mustHave1LowerCase),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }

  changePasswordState() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  //passwordCheck
  bool hasMinLength = false;
  bool hasDigit = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasSpecialChar = false;

  void _checkPassword({required String password}) {
    setState(() {
      hasMinLength = password.length >= 8 && password.length <= 16;
      hasDigit = password.contains(RegExp(r'\d'));
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasLowercase = password.contains(RegExp(r'[a-z]'));
      hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  bool _isPasswordValid() {
    return hasMinLength &&
        hasDigit &&
        hasUppercase &&
        hasLowercase &&
        hasSpecialChar;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          title: translate!.password,
          hint: translate!.password,
          readOnly: widget.readOnly,
          isRequired: true,
          obscureText: showPassword,
          controller: widget.controller,
          keyboardType: TextInputType.visiblePassword,
          validator: widget.validator,
          showSuffixIcon: true,
          focusNode: _passwordFocusNode,
          suffixIcon: IconButton(
              onPressed: () {
                changePasswordState();
              },
              icon: Image.asset(
                !showPassword ? passwordShow : passwordHidden,
                width: 24,
              )),
          onChanged: (value) {
            setState(() {});
            _checkPassword(password: value);
          },
        ),
        _passwordFocusChange()
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/bloc/cubit/forgotpassword_cubit.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailtxtForgotPassword = TextEditingController();

  final _formKeyForgotPassword = GlobalKey<FormState>();

  TextFieldValidator validator = TextFieldValidator();

  submit(BuildContext context) async {
    context.read<ForgotpasswordCubit>().resetState();

    if (_formKeyForgotPassword.currentState!.validate()) {
      context
          .read<ForgotpasswordCubit>()
          .forgotPassword(_emailtxtForgotPassword.text);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailtxtForgotPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context)!;
    return Dialog(
      backgroundColor: appThemeColors!.bg,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: SingleChildScrollView(
        child: Container(
          // height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: appThemeColors!.bg,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Form(
            key: _formKeyForgotPassword,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(translate.forgotPassword,
                          textAlign: TextAlign.center, style: TitleHelper.h9),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(translate.forgotPasswordDescrip,
                          textAlign: TextAlign.center,
                          style: SubtitleHelper.h10.copyWith(
                              height: 1.8, color: appThemeColors!.textDark)),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailtxtForgotPassword,
                  validator: (value) => validator.validateUserName(value),
                  style: TextStyle(color: appThemeColors!.textDark),
                  // autofocus: true,
                  onFieldSubmitted: (_) {
                    submit(context);
                  },

                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                      focusColor: appThemeColors!.textLight,
                      hoverColor: appThemeColors!.textLight,
                      filled: true,
                      fillColor: appThemeColors!.textLight,
                      labelStyle: labelStyle,
                      enabledBorder: ktextFeildOutlineInputBorder,
                      focusedBorder: ktextFeildOutlineInputBorderFocused,
                      border: ktextFeildOutlineInputBorder,
                      labelText: translate.hoxtonEmail,
                      errorStyle: SubtitleHelper.h12.copyWith(color: kred),
                      errorBorder: kerrorTextfeildBorder,
                      focusedErrorBorder: kerrorTextfeildBorder),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<ForgotpasswordCubit, ForgotpasswordState>(
                  builder: (context, state) {
                    if (state is ForgotpasswordError) {
                      return Container(
                        width: double.infinity,
                        child: Text(
                          state.error,
                          textAlign: TextAlign.left,
                          style: SubtitleHelper.h11.copyWith(color: kred),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                BlocConsumer<ForgotpasswordCubit, ForgotpasswordState>(
                  listener: (context, state) {
                    if (state is ForgotpasswordLoaded) {
                      Navigator.of(context).pop();
                      showSnackBar(
                          context: context,
                          title: translate.resetPasswordSuccess(state.mail));
                    } else if (state is ForgotpasswordError) {
                      // showSnackBar(context: context, title: state.error);
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: state is ForgotpasswordLoading
                          ? null
                          : () {
                              submit(context);
                              // context.read<UserAccountCubit>().removeUserData();
                              // RootApplicationAccess().logoutAndClearData(isFromHome: true);
                            },
                      child: state is ForgotpasswordLoading
                          ? buildCircularProgressIndicator()
                          : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  border: Border(
                                top: BorderSide(
                                    color: Color(0xfffE5E5E5), width: 0.5),
                                bottom: BorderSide(
                                    color: Color(0xfffE5E5E5), width: 0.5),
                              )),
                              child: Text(
                                translate.submit.toString().toUpperCase(),
                                style: SubtitleHelper.h10.copyWith(
                                    color: const Color.fromARGB(255, 3, 2, 2)),
                              ),
                            ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    context.read<ForgotpasswordCubit>().resetState();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        border: Border(
                      top: BorderSide(color: Color(0xfffE5E5E5), width: 0.5),
                    )),
                    child: Text(
                      translate.cancel.toString().toUpperCase(),
                      style: SubtitleHelper.h10
                          .copyWith(color: const Color.fromARGB(255, 3, 2, 2)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/login_navigator.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/bloc/cubit/otp_cubit.dart';
import 'package:wedge/features/change_passcode/presentation/pages/change_passcode_page.dart';

class OTPPopUP extends StatefulWidget {
  // final Function onValidateClicked;
  final String email;
  final String mobile;
  final String maskedEmail;
  final bool? forMpine;

  const OTPPopUP(
      {Key? key,
      required this.maskedEmail,
      this.forMpine,
      required this.email,
      required this.mobile})
      : super(key: key);

  @override
  State<OTPPopUP> createState() => _OTPPopUPState();
}

class _OTPPopUPState extends State<OTPPopUP> {
  TextEditingController _otp = TextEditingController();

  final _formKeyOTPPopUP = GlobalKey<FormState>();

  TextFieldValidator validator = TextFieldValidator();

  bool disableVerify = true;

  // submit(BuildContext context) async {
  //   // context.read<Logincub>().resetState();

  //   if (_formKeyOTPPopUP.currentState!.validate()) {
  //     context.read<LoginCubit>().validateOTP(_otp.text, widget.email);
  //   }
  // }

  @override
  void initState() {
    log("called init");
    // TODO: implement initState
    super.initState();
    startCounter();
    context.read<OtpCubit>().resetOTPState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _otp.dispose();
    super.dispose();
  }

  Timer? timer;

  int _countdown = 60;

  startCounter() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown == 0) {
          _countdown = 0;
          timer.cancel();
        } else {
          _countdown -= 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context)!;
    return Dialog(
      backgroundColor: appThemeColors!.bg,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        // height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: appThemeColors!.bg,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKeyOTPPopUP,
          child: SingleChildScrollView(
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
                      Text("Verification",
                          textAlign: TextAlign.center, style: TitleHelper.h9),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          "Please enter the verification code we sent to your mobile No ${widget.mobile} and email ${widget.maskedEmail}",
                          textAlign: TextAlign.center,
                          style: SubtitleHelper.h10.copyWith(
                            height: 1.8,
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                BlocBuilder<OtpCubit, OtpState>(
                  builder: (context, state) {
                    return TextFormField(
                      readOnly: !(state is OtpInitial),
                      onChanged: (v) {
                        v = v.trim();
                        if (v.length >= 4) {
                          setState(() {
                            disableVerify = false;
                          });
                        } else {
                          setState(() {
                            disableVerify = true;
                          });
                        }
                      },
                      controller: _otp,
                      validator: (value) => validator.validateUserName(value),
                      style: TextStyle(color: appThemeColors!.textDark),
                      // autofocus: true,
                      onFieldSubmitted: (_) {
                        // submit(context);
                        // widget.onValidateClicked();
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
                          labelText: "OTP Code",
                          errorStyle: SubtitleHelper.h12.copyWith(color: kred),
                          errorBorder: kerrorTextfeildBorder,
                          focusedErrorBorder: kerrorTextfeildBorder),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                BlocConsumer<OtpCubit, OtpState>(
                  listener: (context, state) {
                    if (state is OtpSuccess) {
                      // Navigator.pop(context);
                      locator<SharedPreferences>().setBool(
                          RootApplicationAccess.isOTPVerifiedPreference, true);
                      if (widget.forMpine ?? false) {
                        cupertinoNavigator(
                            context: context,
                            screenName: CreatePasscodePage(
                                userMail: widget.email,
                                fromLogin: widget.forMpine),
                            type: NavigatorType.PUSHREMOVEUNTIL);
                      } else {
                        LoginNavigator(context, state.loginuserData);
                      }
                    }
                    if (state is OtpInitial) {
                      if (state.isresentCode) {
                        _countdown = 60;
                        timer?.cancel();
                        startCounter();
                      }

                      if (state.errorMessage ==
                          "You reached the maximum count of otp attempts. Please login again") {
                        Future.delayed(const Duration(seconds: 4), () {
                          Navigator.pop(context);
                        });
                      }
                    }

                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    if (state is OtpInitial) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                              child: Text(
                            state.errorMessage,
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.red),
                          )),
                          Visibility(
                              visible: (state.isresentCode),
                              child: Text(
                                "OTP has been successfully sent",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.green[400]),
                              )),
                          const SizedBox(
                            height: 25,
                          ),
                          GestureDetector(
                            onTap: () {
                              // context.read<ForgotpasswordCubit>().resetState();
                              if (!disableVerify) {
                                context.read<OtpCubit>().validateOTP(
                                    widget.email, _otp.text.trim());
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  border: Border(
                                top: BorderSide(
                                    color: Color(0xfffE5E5E5), width: 0.5),
                              )),
                              child: Text(
                                "Verify",
                                style: SubtitleHelper.h10.copyWith(
                                    color: disableVerify
                                        ? Colors.grey[400]
                                        : Colors.green),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _countdown == 0
                                ? () {
                                    context
                                        .read<OtpCubit>()
                                        .sendOTP(widget.email);
                                  }
                                : null,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  border: Border(
                                top: BorderSide(
                                    color: Color(0xfffE5E5E5), width: 0.5),
                              )),
                              child: Text("Resend OTP",
                                  style: SubtitleHelper.h10.copyWith(
                                      color: _countdown != 0
                                          ? Colors.grey[400]
                                          : Colors.black)
                                  // color: Color.fromARGB(255, 3, 2, 2)),
                                  ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: _countdown == 0 ? 0 : 20),
                            alignment: Alignment.center,
                            child: Text(
                                _countdown == 0
                                    ? ""
                                    : "Resend in 0:$_countdown seconds",
                                style: SubtitleHelper.h10
                                // color: Color.fromARGB(255, 3, 2, 2)),
                                ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: buildCircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

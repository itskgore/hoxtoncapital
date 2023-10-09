import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/biometrics_auth.dart';
import 'package:wedge/core/helpers/login_navigator.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/wedge_logo.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/app_passcode/create_passcode/presentation/pages/createPasscodeScreen.dart';
import 'package:wedge/features/auth/create_password/presentation/pages/create_password.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/bloc/cubit/login_cubit.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/widgets/forgotPassword.dart';
import 'package:wedge/features/change_passcode/presentation/pages/change_passcode_page.dart';

import '../../../../../core/widgets/dialog/login_error_pop.dart';
import '../../../../../core/widgets/inputFields/custom_text_field.dart';
import '../../../signup/presentaion/pages/signup_screen.dart';
import '../widgets/otp_popup.dart';

class OtherLoginPage extends StatefulWidget {
  final bool? forMpin;
  final bool? createNew;
  final bool? fromLoginViaEmailButton;
  final bool? shouldShowBioMetrics;
  final String? userEmail;

  const OtherLoginPage(
      {Key? key,
      this.forMpin,
      this.createNew,
      this.userEmail,
      this.fromLoginViaEmailButton,
      this.shouldShowBioMetrics})
      : super(key: key);

  @override
  _OtherLoginPageState createState() => _OtherLoginPageState();
}

class _OtherLoginPageState extends State<OtherLoginPage> {
  final TextEditingController _emailtxt = TextEditingController();
  final TextEditingController _passwordtxt = TextEditingController(text: "");
  final TextEditingController _otp = TextEditingController();

  bool verificationOnProgress = false;

  final _formKey = GlobalKey<FormState>();
  TextFieldValidator validator = TextFieldValidator();
  bool showPassword = true;
  String passwordHidden = "assets/icons/passwordHidden.png";
  String passwordShow = "assets/icons/passwordShow.png";

  changePasswordState() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  _setOnboarding() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(RootApplicationAccess.isFirstTimePreference, false);
  }

  bool isLoading = false;
  final bool _termsAndConditions = false;

  @override
  void initState() {
    _setOnboarding();
    _emailtxt.text = widget.userEmail ?? "";
    super.initState();
  }

  forgotPasswordDialog() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: appThemeColors!.primary,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async {
                // Return false to restrict the back button when the dialog is visible
                return false;
              },
              child: ForgotPassword());
        });
  }

  // checking local and current mail is same
  bool checkIfExistingUser(String currentEmail) {
    String? localUserEmail = locator<SharedPreferences>()
        .getString(RootApplicationAccess.passCodeMailPreferences);
    if (currentEmail == localUserEmail) {
      return locator<SharedPreferences>()
              .getBool(RootApplicationAccess.isOTPVerifiedPreference) ??
          false;
    } else {
      if (locator<SharedPreferences>().containsKey(
          RootApplicationAccess.didShowDeviceBioMetricBottomSheet)) {
        locator<SharedPreferences>()
            .remove(RootApplicationAccess.isUserBioMetricIsEnabledPreference);
        locator<SharedPreferences>()
            .remove(RootApplicationAccess.isDeviceBioMetricIsAvailable);
        locator<SharedPreferences>()
            .remove(RootApplicationAccess.didShowDeviceBioMetricBottomSheet);
      }
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailtxt.dispose();
    _passwordtxt.dispose();
    _otp.dispose();
    super.dispose();
  }

  createORUsePasscode(String? email) {
    // if (email == null) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: appThemeColors!.bg,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.60,
          child: CreatePasscodeScreen(
            isFromSplash: false,
            showBackButton: true,
          ),
        );
      },
    );
  }

  bool? checkifLoginViaPasscode() {
    if (!BioMetricsAuth().shouldOpenMpin()) {
      final passcode = locator<SharedPreferences>()
          .getString(RootApplicationAccess.passcodeLoginPreferences);
      if (passcode?.isNotEmpty ?? false) {
        final userData = LoginModel.fromJson(jsonDecode(passcode!));
        return userData.isMpineEnabled;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.fitWidth)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [getWireDashIcon(context)],
          centerTitle: false,
          title: Hero(
            tag: 1998,
            child: SizedBox(
              height: 25,
              child: WedgeLogo(
                height: 100.0,
                width: 150.0,
                darkLogo: appThemeColors!.loginColorTheme!.darkLogo,
              ),
            ),
          ),
        ),
        body: UpgradeAlert(
          upgrader: Upgrader(
              dialogStyle: UpgradeDialogStyle.cupertino,
              durationUntilAlertAgain: const Duration(hours: 1),
              showReleaseNotes: false,
              messages: MyEnglishMessages(),
              showIgnore: false,
              showLater: false,
              onUpdate: () {
                RootApplicationAccess().logoutAndClearData();
                return true;
              },
              canDismissDialog: false),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height:
                    size.height < 700 ? size.height * 0.13 : size.height * 0.19,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: appThemeColors!.textLight,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      )),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(
                              top: size.height * .02,
                              bottom: size.height * .012),
                          child: Text(
                            translate!.login,
                            style: TitleHelper.h1.copyWith(
                                color: appThemeColors!
                                    .loginColorTheme!.textTitleColor),
                          ),
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  title: translate!.emailID,
                                  hint: translate!.emailID,
                                  validator: (value) =>
                                      validator.validateUserName(value),
                                  isRequired: true,
                                  controller: _emailtxt,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  title: translate!.password,
                                  hint: translate!.password,
                                  validator: (value) =>
                                      validator.validatePassword(value),
                                  isRequired: true,
                                  controller: _passwordtxt,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  obscureText: showPassword,
                                  showSuffixIcon: true,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        changePasswordState();
                                      },
                                      icon: Image.asset(
                                        !showPassword
                                            ? passwordShow
                                            : passwordHidden,
                                        width: 24,
                                      )),
                                ),
                              ],
                            )),
                        BlocConsumer<LoginCubit, LoginState>(
                          listener: (context, state) async {
                            if (state is LoginInitial) {
                              if (state.errorMessage != "") {
                                // Show Error pop
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                showLoginErrorPop(errorMsg: state.errorMessage);
                              } else {
                                var res = json.encode(state.loginSuccess);
                                if (state.loginUserData.enableOTP) {
                                  if (/*checkIsOTPVerified(_emailtxt.text) &&*/
                                      res.contains("accessToken")) {
                                    // USER IS VISITING > 2 times.
                                    LoginModel userEntity =
                                        LoginModel.fromJson(jsonDecode(res));
                                    if (widget.createNew ?? false) {
                                      cupertinoNavigator(
                                          context: context,
                                          screenName: CreatePasscodePage(
                                              userMail: _emailtxt.text,
                                              fromLogin: widget.forMpin),
                                          type: NavigatorType.PUSHREMOVEUNTIL);
                                    } else {
                                      LoginNavigator(context, userEntity);
                                    }
                                  } else {
                                    final mobileNo = state.loginSuccess
                                            .containsKey('user')
                                        ? state.loginSuccess["user"]["mobileNo"]
                                        : "";
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        barrierColor: appThemeColors!.primary,
                                        builder: (BuildContext context) {
                                          return WillPopScope(
                                            onWillPop: () async {
                                              // Return false to restrict the back button when the dialog is visible
                                              return false;
                                            },
                                            child: OTPPopUP(
                                              mobile: mobileNo,
                                              maskedEmail: _emailtxt.text,
                                              email: state
                                                          .isPasscodeLogin ??
                                                      false
                                                  ? locator<SharedPreferences>()
                                                          .getString(
                                                              RootApplicationAccess
                                                                  .passCodeMailPreferences) ??
                                                      ""
                                                  : _emailtxt.text,
                                            ),
                                          );
                                        });
                                  }
                                } else {
                                  if (state.loginSuccess!["message"]
                                              .toString()
                                              .toLowerCase() ==
                                          "success" ||
                                      state.errorMessage.isEmpty) {
                                    ////: COMMENTED AS PER NEW REQUEST TO BE DEPENDENT ON ENABLEOTP KEY SUGGEST [SHAH & VIB]
                                    // if (checkIsOTPVerified(_emailtxt.text) &&
                                    //     res.contains("accessToken")) {
                                    //   // USER IS VISITING > 2 times.
                                    if (jsonDecode(res).isNotEmpty) {
                                      LoginModel userEntity =
                                          LoginModel.fromJson(jsonDecode(res));
                                      locator<SharedPreferences>().setString(
                                          RootApplicationAccess
                                              .loginUserPreferences,
                                          res);
                                      if (widget.createNew ?? false) {
                                        cupertinoNavigator(
                                            context: context,
                                            screenName: CreatePasscodePage(
                                                userMail: _emailtxt.text,
                                                fromLogin: widget.forMpin),
                                            type:
                                                NavigatorType.PUSHREMOVEUNTIL);
                                      } else {
                                        LoginNavigator(context, userEntity);
                                      }
                                    }

                                    // } else {
                                    //   isLoading = false;
                                    //   verificationOnProgress = false;

                                    //   final mobileNo = state.loginSuccess
                                    //           .containsKey('user')
                                    //       ? state.loginSuccess["user"]["mobileNo"]
                                    //       : "";
                                    //   showDialog(
                                    //       barrierDismissible: true,
                                    //       context: context,
                                    //       barrierColor: appThemeColors!.primary,
                                    //       builder: (BuildContext context) {
                                    //         return OTPPopUP(
                                    //           mobile: mobileNo,
                                    //           maskedEmail: _emailtxt.text,
                                    //           email: state.isPasscodeLogin ??
                                    //                   false
                                    //               ? locator<SharedPreferences>()
                                    //                       .getString(
                                    //                           RootApplicationAccess
                                    //                               .passCodeMail) ??
                                    //                   ""
                                    //               : _emailtxt.text,
                                    //         );
                                    //       });
                                    // }
                                  }
                                }
                              }
                            }
                          },
                          builder: (context, state) {
                            /*     if (state is LoginInitial) {
                              return Visibility(
                                visible: (state.errorMessage != ""),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text(state.errorMessage,
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                        style: SubtitleHelper.h11
                                            .copyWith(color: kred)),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }*/
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // checkifLoginViaPasscode() ?? false

                        Visibility(
                          visible: widget.fromLoginViaEmailButton ?? false,
                          child: Container(
                            margin:
                                const EdgeInsets.only(right: 25, bottom: 20),
                            width: double.infinity,
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                if (locator<SharedPreferences>()
                                        .getString(RootApplicationAccess
                                            .loginUserPreferences)
                                        ?.isEmpty ??
                                    true) {
                                  locator<SharedPreferences>().setString(
                                      RootApplicationAccess
                                          .loginUserPreferences,
                                      locator<SharedPreferences>().getString(
                                              RootApplicationAccess
                                                  .passcodeLoginPreferences) ??
                                          "");
                                }
                                BioMetricsAuth().appPasscodeOpen(
                                    locator<SharedPreferences>().getString(
                                            RootApplicationAccess
                                                .passcodeLoginPreferences) ??
                                        "",
                                    context: context,
                                    isFromSplash: true);
                              },
                              child: Text(
                                "Login via passcode",
                                style: SubtitleHelper.h12.copyWith(
                                    letterSpacing: 0.8,
                                    color: appThemeColors!.primary,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 25),
                          width: double.infinity,
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              forgotPasswordDialog();
                            },
                            child: Text(
                              "Forgot password?",
                              style: SubtitleHelper.h12.copyWith(
                                  letterSpacing: 0.8,
                                  color: appThemeColors!.primary,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),

                        (locator<SharedPreferences>().getBool(
                                        RootApplicationAccess
                                            .firstLoginPreference) ??
                                    true) ||
                                (widget.forMpin ?? false)
                            ? const SizedBox.shrink()
                            : Visibility(
                                visible:
                                    BioMetricsAuth().hasMpinForLogoutUser(),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    right: 25,
                                    top: 20,
                                  ),
                                  width: double.infinity,
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      downSlideNavigator(
                                          context: context,
                                          screenName: const OtherLoginPage(
                                            forMpin: true,
                                            createNew: true,
                                          ),
                                          type: NavigatorType.PUSH);
                                    },
                                    child: Text(
                                      "Create new passcode",
                                      style: SubtitleHelper.h12.copyWith(
                                          letterSpacing: 0.8,
                                          color: appThemeColors!.primary,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),

                        //TODO: Temporary Commit : Login with passcode
                        // locator<SharedPreferences>().getBool(RootApplicationAccess.isFirstTime) ??
                        //         true
                        //     ? SizedBox.shrink()
                        //     : Container(
                        //         margin: EdgeInsets.only(right: 25),
                        //         width: double.infinity,
                        //         alignment: Alignment.topRight,
                        //         child: GestureDetector(
                        //           onTap: () {},
                        //           child: Text(
                        //             "Login with passcode",
                        //             style: SubtitleHelper.h11.copyWith(
                        //                 letterSpacing: 1.1,
                        //                 color: appThemeColors!.primary,
                        //                 decoration: TextDecoration.underline,
                        //                 fontWeight: FontWeight.normal),
                        //           ),
                        //         ),
                        //       ),
                        // Spacer(),
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            BlocConsumer<LoginCubit, LoginState>(
                              listener: (context, state) {
                                if (state is LoginInitial) {
                                  if (!(state.isForceResetPassword ?? true)) {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                CreatePassword(
                                                  email: _emailtxt.text,
                                                )));
                                  }
                                  if (state.isForgotPasswordClicked) {
                                    locator<WedgeDialog>().forgotPassword(
                                        context,
                                        email: _emailtxt.text, onClicked: () {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);

                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      context
                                          .read<LoginCubit>()
                                          .sendresetPasswordLink(
                                              _emailtxt.text);
                                      Navigator.pop(context);
                                    });
                                  }
                                  if (state.isResetPasswordLinkSent) {
                                    showSnackBar(
                                        context: context,
                                        title: "Email sent successfully!");
                                  }
                                  if (state.errorMessage.isNotEmpty) {
                                    setState(() {
                                      isLoading = false;
                                      verificationOnProgress = false;
                                    });
                                  }
                                }
                              },
                              builder: (context, state) {
                                return SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: MaterialButton(
                                    disabledColor:
                                        const Color.fromRGBO(79, 79, 79, 1),
                                    disabledTextColor: Colors.white10,
                                    color: appThemeColors!
                                        .loginColorTheme!.buttonColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            kborderRadius)),
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              locator<SharedPreferences>()
                                                  .remove(RootApplicationAccess
                                                      .passcodeLoginPreferences);
                                              checkIfExistingUser(
                                                  _emailtxt.text);
                                              locator<SharedPreferences>()
                                                  .remove(RootApplicationAccess
                                                      .loginUserPreferences);
                                              context
                                                  .read<LoginCubit>()
                                                  .getLoginOTP(
                                                      _emailtxt.text,
                                                      _passwordtxt.text,
                                                      _termsAndConditions);
                                            }
                                          },
                                    child: isLoading
                                        ? buildCircularProgressIndicator()
                                        : const Text(
                                            LOGIN,
                                            style: TextStyle(
                                                fontSize: kfontLarge,
                                                color: kfontColorLight),
                                          ),
                                  ),
                                );
                              },
                            ),
                            widget.shouldShowBioMetrics ?? false
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final String userData = locator<
                                                      SharedPreferences>()
                                                  .getString(RootApplicationAccess
                                                      .loginUserPreferences) ??
                                              locator<SharedPreferences>()
                                                  .getString(RootApplicationAccess
                                                      .passcodeCreateSectionPreferences) ??
                                              locator<SharedPreferences>()
                                                  .getString(RootApplicationAccess
                                                      .passcodeLoginPreferences) ??
                                              "";
                                          if (userData.isNotEmpty) {
                                            BioMetricsAuth()
                                                .bioMetricsLogin(userData);
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          BioMetricsAuth
                                              .biometricTypeImagePasscode,
                                          width: 50,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(top: 20),
                                child: RichText(
                                    text: TextSpan(
                                        text: "Don’t have an account? ",
                                        style: SubtitleHelper.h11
                                            .copyWith(color: Colors.grey),
                                        children: [
                                      TextSpan(
                                        text: "Create account",
                                        style: SubtitleHelper.h11.copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w500,
                                            color: appThemeColors!.primary!),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            cupertinoNavigator(
                                                context: context,
                                                screenName:
                                                    const SignUpScreen(),
                                                type:
                                                    NavigatorType.PUSHREPLACE);
                                          },
                                      ),
                                    ]))),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "© Hoxton Capital Management 2016 - ${DateTime.now().year}\nAll Rights Reserved",
                              textAlign: TextAlign.center,
                              style: SubtitleHelper.h12
                                  .copyWith(color: appThemeColors!.disableText),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

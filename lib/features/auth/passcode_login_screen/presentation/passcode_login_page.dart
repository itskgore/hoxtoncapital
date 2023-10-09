import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
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
import 'package:wedge/features/auth/hoxton_login/presentation/bloc/cubit/login_cubit.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/widgets/forgotPassword.dart';

class PasscodeLoginPage extends StatefulWidget {
  final bool? forMpin;

  const PasscodeLoginPage({Key? key, this.forMpin}) : super(key: key);

  @override
  _PasscodeLoginPageState createState() => _PasscodeLoginPageState();
}

class _PasscodeLoginPageState extends State<PasscodeLoginPage> {
  TextEditingController _emailtxt = TextEditingController();
  TextEditingController _passwordtxt = TextEditingController();
  TextEditingController _otp = TextEditingController();

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
  bool _termsAndConditions = false;

  @override
  void initState() {
    _setOnboarding();
    context.read<LoginCubit>().resetLoginpage();
    // update(context);
    super.initState();
    // var i = locator<AppLocalizations>();
    // log(i.appTitle);
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
        return Container(
          height: MediaQuery.of(context).size.height * 0.60,
          child: CreatePasscodeScreen(
            isFromSplash: false,
            showBackButton: true,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var translate = AppLocalizations.of(context);
    var border = ktextFeildOutlineInputBorder.copyWith(
        borderSide: BorderSide(color: appThemeColors!.disableLight!, width: 1));
    var focusBorder = ktextFeildOutlineInputBorder.copyWith(
        borderSide: BorderSide(color: appThemeColors!.primary!, width: 0.5));
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
              onUpdate: () {
                RootApplicationAccess().logoutAndClearData();
                return true;
              },
              dialogStyle: UpgradeDialogStyle.cupertino,
              durationUntilAlertAgain: const Duration(hours: 1),
              showReleaseNotes: false,
              messages: MyEnglishMessages(),
              showIgnore: false,
              showLater: false,
              canDismissDialog: false),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.23,
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
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            translate!.login,
                            style: TitleHelper.h1.copyWith(
                                color: appThemeColors!
                                    .loginColorTheme!.textTitleColor),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   alignment: Alignment.topLeft,
                        //   child: Text(
                        //     translate.enterEmail,
                        //     style: SubtitleHelper.h10.copyWith(
                        //         color: appThemeColors!
                        //             .loginColorTheme!.textSubtitleColor),
                        //   ),
                        // ),
                        Form(
                            key: _formKey,
                            child: Container(
                              // padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Registered Email ID",
                                    style: SubtitleHelper.h10.copyWith(
                                        color: appThemeColors!.disableText),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _emailtxt,
                                    validator: (value) =>
                                        validator.validateUserName(value),
                                    style: TextStyle(
                                        color: appThemeColors!.loginColorTheme!
                                            .textFieldTextStyle),
                                    // autofocus: true,
                                    decoration: InputDecoration(
                                      focusColor: appThemeColors!.textLight,
                                      hoverColor: appThemeColors!.textLight,
                                      filled: true,
                                      fillColor: appThemeColors!
                                          .loginColorTheme!.textFieldFillColor,
                                      border: border,
                                      enabledBorder: border,
                                      disabledBorder: border,
                                      focusedBorder: focusBorder,
                                      hintText:
                                          translate.hoxtonEmailPlaceholder,
                                      hintStyle: SubtitleHelper.h11.copyWith(
                                          color: appThemeColors!.disableText),
                                      errorStyle: kerrorTextstyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Password",
                                    style: SubtitleHelper.h10.copyWith(
                                        color: appThemeColors!.disableText),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _passwordtxt,
                                    obscureText: showPassword,
                                    validator: (value) =>
                                        validator.validatePassword(value),
                                    style: TextStyle(
                                        color: appThemeColors!.loginColorTheme!
                                            .textFieldTextStyle),
                                    decoration: InputDecoration(
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
                                      filled: true,
                                      fillColor: appThemeColors!
                                          .loginColorTheme!.textFieldFillColor,
                                      border: border,
                                      enabledBorder: border,
                                      disabledBorder: border,
                                      focusedBorder: focusBorder,
                                      hintText: "•••••••••",
                                      hintStyle: SubtitleHelper.h10.copyWith(
                                          color: appThemeColors!
                                              .loginColorTheme!
                                              .textFieldPlaceholderColor),
                                      errorStyle: kerrorTextstyle,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        BlocConsumer<LoginCubit, LoginState>(
                          listener: (context, state) {
                            if (state is LoginInitial) {
                              if (state.loginSuccess!["message"]
                                      .toString()
                                      .toLowerCase() ==
                                  "success") {
                                isLoading = false;
                                verificationOnProgress = false;
                                // showDialog(
                                //     barrierDismissible: true,
                                //     context: context,
                                //     barrierColor: appThemeColors!.primary,
                                //     builder: (BuildContext context) {
                                //       return OTPPopUP(
                                //         forMpine: widget.forMpin,
                                //         mobile: state.loginSuccess!["user"]
                                //             ["mobileNo"],
                                //         maskedEmail: state.loginSuccess!["user"]
                                //             ["email"],
                                //         email: state.isPasscodeLogin ?? false
                                //             ? locator<SharedPreferences>()
                                //                     .getString(
                                //                         RootApplicationAccess
                                //                             .passCodeMail) ??
                                //                 ""
                                //             : _emailtxt.text,
                                //       );
                                //     });
                              }
                            }
                          },
                          builder: (context, state) {
                            if (state is LoginInitial) {
                              return Visibility(
                                visible: (state.errorMessage != ""),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  child: Row(
                                    children: [
                                      Text(state.errorMessage,
                                          style: SubtitleHelper.h10
                                              .copyWith(color: kred)),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(right: 25),
                        //   width: double.infinity,
                        //   alignment: Alignment.topRight,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       forgotPasswordDialog();
                        //     },
                        //     child: Text(
                        //       "Forgot password?",
                        //       style: SubtitleHelper.h11.copyWith(
                        //           letterSpacing: 1.1,
                        //           color: appThemeColors!.primary,
                        //           decoration: TextDecoration.underline,
                        //           fontWeight: FontWeight.normal),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // widget.forMpin ?? false
                        //     ? Container(
                        //         margin: EdgeInsets.only(right: 25),
                        //         width: double.infinity,
                        //         alignment: Alignment.topRight,
                        //         child: GestureDetector(
                        //           onTap: () {
                        //             // forgotPasswordDialog();
                        //           },
                        //           child: Text(
                        //             "Create password",
                        //             style: SubtitleHelper.h11.copyWith(
                        //                 letterSpacing: 1.1,
                        //                 color: appThemeColors!.primary,
                        //                 decoration: TextDecoration.underline,
                        //                 fontWeight: FontWeight.normal),
                        //           ),
                        //         ),
                        //       )
                        //     : SizedBox.shrink(),
                        // Spacer(),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
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
                                                context
                                                    .read<LoginCubit>()
                                                    .getLoginOTP(
                                                      _emailtxt.text,
                                                      _passwordtxt.text,
                                                      _termsAndConditions,
                                                      isOTPVerified: false,
                                                    );
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
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "© Hoxton Capital Management 2016 - ${DateTime.now().year}\nAll Rights Reserved",
                                textAlign: TextAlign.center,
                                style: SubtitleHelper.h12.copyWith(
                                    color: appThemeColors!.disableText),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 70,
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

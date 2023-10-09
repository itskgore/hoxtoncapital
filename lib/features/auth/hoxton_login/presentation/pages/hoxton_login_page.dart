import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/biometrics_auth.dart';
import 'package:wedge/core/helpers/login_navigator.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/wedge_logo.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/create_password/presentation/pages/create_password.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/bloc/cubit/login_cubit.dart';
import 'package:wedge/features/change_passcode/presentation/pages/change_passcode_page.dart';

class WedgeLoginPage extends StatefulWidget {
  final bool? forMpin;
  final bool? isShowCreateNewPassCode;

  const WedgeLoginPage({Key? key, this.forMpin, this.isShowCreateNewPassCode})
      : super(key: key);

  @override
  _WedgeLoginPageState createState() => _WedgeLoginPageState();
}

class _WedgeLoginPageState extends State<WedgeLoginPage> {
  // bool state.isEmailVerified = false;
  bool _termsAndConditions = false;

  TextEditingController _emailtxt = TextEditingController();
  TextEditingController _passwordtxt = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextFieldValidator validator = TextFieldValidator();

  @override
  void initState() {
    super.initState();
    _setOnboarding();
    context.read<LoginCubit>().resetLoginpage();
    log(appTheme.colors!.bg.toString());
    // var i = locator<AppLocalizations>();
    // log(i.appTitle);
  }

  _setOnboarding() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(RootApplicationAccess.isFirstTimePreference, false);
  }

  @override
  void dispose() {
    _emailtxt.dispose();
    _passwordtxt.dispose();
    super.dispose();
  }

  String passwordHidden = "assets/icons/passwordHidden.png";
  String passwordShow = "assets/icons/passwordShow.png";
  bool showPassword = true;

  changePasswordState() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  LoginModel? checkIfLoginViaPasscode() {
    if (locator<SharedPreferences>()
        .containsKey(RootApplicationAccess.passcodeLoginPreferences)) {
      final data = locator<SharedPreferences>()
              .getString(RootApplicationAccess.passcodeLoginPreferences) ??
          "";
      if (data.isNotEmpty) {
        return LoginModel.fromJson(json.decode(data));
      }
    } else {
      return null;
    }
    return null;
  }

  bool isLoading = false;

  LoginModel? checkifLoginViaPasscode() {
    if (locator<SharedPreferences>()
        .containsKey(RootApplicationAccess.passcodeLoginPreferences)) {
      final data = locator<SharedPreferences>()
              .getString(RootApplicationAccess.passcodeLoginPreferences) ??
          "";
      if (data.isNotEmpty) {
        return LoginModel.fromJson(json.decode(data));
      }
    } else {
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var translate = AppLocalizations.of(context);
    var checking = locator<SharedPreferences>()
        .containsKey(RootApplicationAccess.isMPinEnabledPreference);
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginInitial) {
          if (!(state.isForceResetPassword ?? true)) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => CreatePassword(
                          email: _emailtxt.text,
                        )));
          } else if (state.isForgotPasswordClicked) {
            locator<WedgeDialog>()
                .forgotPassword(context, email: _emailtxt.text, onClicked: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              context.read<LoginCubit>().sendresetPasswordLink(_emailtxt.text);
              Navigator.pop(context);
            });
          } else if (state.isResetPasswordLinkSent) {
            showSnackBar(context: context, title: "Email sent successfully!");
          } else if (state.errorMessage.isNotEmpty) {
            setState(() {
              isLoading = false;
            });
          } else if (widget.forMpin ?? false) {
            if (state.loginUserData.accessToken.isNotEmpty) {
              cupertinoNavigator(
                  context: context,
                  screenName: CreatePasscodePage(
                      userMail: _emailtxt.text, fromLogin: true),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            }
          } else {
            LoginNavigator(context, state.loginUserData);
          }
        }
      },
      builder: (context, state) {
        if (state is LoginInitial) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  appThemeColors!.primary!.withOpacity(1.0),
                  appThemeColors!.primary!.withOpacity(0.95),
                ],
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,

              appBar: AppBar(
                backgroundColor: Colors.transparent,
                actions: [getWireDashIcon(context)],
                title: const SizedBox(
                  height: 25,
                  child: WedgeLogo(
                    height: 100.0,
                    width: 150.0,
                    darkLogo: false,
                  ),
                ),
                leading: state.isEmailVerified
                    ? IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: kfontColorLight,
                        ),
                        onPressed: () {
                          _passwordtxt.text = "";
                          context.read<LoginCubit>().goBack();
                        },
                      )
                    : Container(),
              ),
              backgroundColor: Colors.transparent,
              body: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // Center(
                  //   child: WedgeLogo(
                  //     height: 100.0,
                  //     width: 150.0,
                  //     darkLogo: false,
                  //   ),
                  // ),
                  Visibility(
                      visible: (state.isloading),
                      child: const LinearProgressIndicator()),
                  const SizedBox(
                    height: 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      translate!.login,
                      style: SubtitleHelper.h1Second.copyWith(
                          color: appThemeColors!.textLight,
                          fontFamily: kSecondortfontFamily),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      state.isEmailVerified
                          ? translate.enterPassword
                          : translate.enterEmail,
                      style: SubtitleHelper.h10.copyWith(color: Colors.white38),
                      // TextStyle(
                      //     fontSize: kfontMedium, color: Colors.white38),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kpadding),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Visibility(
                            visible: (!state.isEmailVerified),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailtxt,
                                  validator: (value) =>
                                      validator.validateUserName(value),
                                  style: TextStyle(
                                      color: appThemeColors!.textLight),
                                  // autofocus: true,
                                  decoration: InputDecoration(
                                      focusColor: appThemeColors!.textLight,
                                      hoverColor: appThemeColors!.textLight,
                                      filled: true,
                                      fillColor: appThemeColors!.textDark!
                                          .withOpacity(0.259),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      hintText: translate.hoxtonEmail,
                                      hintStyle: TextStyle(
                                          color: appThemeColors!.disableDark,
                                          fontSize: appThemeHeadlineSizes!.h10),
                                      errorStyle: kerrorTextstyle,
                                      errorBorder: kerrorTextfeildBorder,
                                      focusedErrorBorder:
                                          kerrorTextfeildBorder),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                BioMetricsAuth().hasMpinForLogoutUser() ||
                                        BioMetricsAuth().hasPassCode() ==
                                                false &&
                                            !BioMetricsAuth().isFirstTimeInApp()
                                    ? Visibility(
                                        visible:
                                            widget.isShowCreateNewPassCode ??
                                                true,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 25),
                                          width: double.infinity,
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              cupertinoNavigator(
                                                  context: context,
                                                  screenName:
                                                      const WedgeLoginPage(
                                                    forMpin: true,
                                                    isShowCreateNewPassCode:
                                                        false,
                                                  ),
                                                  type: NavigatorType
                                                      .PUSHREMOVEUNTIL);
                                            },
                                            child: Text(
                                              "Create new passcode",
                                              style: SubtitleHelper.h12
                                                  .copyWith(
                                                      letterSpacing: 0.8,
                                                      color: appThemeColors!
                                                          .textLight,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: (state.isEmailVerified),
                            child: TextFormField(
                              controller: _passwordtxt,
                              obscureText: showPassword,
                              validator: (value) =>
                                  validator.validatePassword(value),
                              style:
                                  TextStyle(color: appThemeColors!.textLight),
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
                                  fillColor: appThemeColors!.textDark!
                                      .withOpacity(0.259),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintText: translate.password,
                                  hintStyle: SubtitleHelper.h10.copyWith(
                                      color: appThemeColors!.disableDark),
                                  errorStyle: kerrorTextstyle,
                                  errorBorder: kerrorTextfeildBorder),
                            ),
                          ),
                          Visibility(
                            visible: (state.errorMessage != ""),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(state.errorMessage,
                                      style: SubtitleHelper.h10
                                          .copyWith(color: kred)),
                                ],
                              ),
                            ),
                          ),
                          checkIfLoginViaPasscode() != null &&
                                  !(BioMetricsAuth().hasMpinForLogoutUser())
                              ? Visibility(
                                  visible: (!state.isEmailVerified),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 5, bottom: 20, top: 20),
                                    width: double.infinity,
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        locator<SharedPreferences>().setString(
                                            RootApplicationAccess
                                                .loginUserPreferences,
                                            locator<SharedPreferences>().getString(
                                                    RootApplicationAccess
                                                        .passcodeLoginPreferences) ??
                                                "");
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
                                        style: SubtitleHelper.h11.copyWith(
                                            letterSpacing: 1.1,
                                            color: appThemeColors!.textLight,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),

                  Container(
                    color: Colors.transparent,
                    height: state.isEmailVerified ? 150 : 110,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Visibility(
                            visible: (state.isEmailVerified),
                            child: Visibility(
                              visible: !state
                                  .emailUserData.isTermsAndConditionsAccepted,
                              //should be changed to !
                              child: Row(
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                        unselectedWidgetColor:
                                            appThemeColors!.textLight),
                                    child: Checkbox(
                                      activeColor: lighten(
                                          appThemeColors!.primary ??
                                              Colors.green,
                                          .3),
                                      hoverColor: Colors.black,
                                      overlayColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      focusColor: appThemeColors!.textLight,
                                      value: _termsAndConditions,
                                      onChanged: (val) {
                                        setState(() {
                                          _termsAndConditions = val!;
                                        });
                                      },
                                      // value: this.value,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(translate.iAgreeTo,
                                          style: TextStyle(
                                              color: appThemeColors!.textLight,
                                              fontSize: kfontMedium)),
                                      TextButton(
                                        child: Text(
                                          translate.termsAndConditions,
                                          style: const TextStyle(
                                              color: kblue,
                                              fontSize: kfontMedium),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),

                          const Spacer(),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Visibility(
                            // first button
                            visible: (!state.isEmailVerified),
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                color: appThemeColors!.textDark!
                                    .withOpacity(0.451),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(kborderRadius)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<LoginCubit>()
                                        .verifyEmailAddress(
                                            _emailtxt.text.toLowerCase());
                                  } else {}
                                },
                                child: Text(
                                  translate.next,
                                  style: TextHelper.h1Second.copyWith(
                                      fontSize: kfontLarge,
                                      color: kfontColorLight),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            //second button (password)
                            visible: (state.isEmailVerified),
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                disabledColor:
                                    const Color.fromRGBO(79, 79, 79, 1),
                                disabledTextColor: Colors.white10,
                                color: appThemeColors!.textDark!
                                    .withOpacity(0.451),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(kborderRadius)),
                                // style: ElevatedButton.styleFrom(
                                //     primary: Colors.black45),
                                onPressed: !_termsAndConditions &&
                                        !state.emailUserData
                                            .isTermsAndConditionsAccepted
                                    ? null
                                    : isLoading
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              context.read<LoginCubit>().login(
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
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              // bottomNavigationBar:
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

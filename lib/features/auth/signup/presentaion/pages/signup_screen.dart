import 'package:country_currency_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/signup/presentaion/cubit/signup_state.dart';
import 'package:wedge/features/auth/signup/presentaion/cubit/validate_user_detaills_state.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/contants/string_contants.dart';
import '../../../../../core/contants/theme_contants.dart';
import '../../../../../core/helpers/textfeild_validator.dart';
import '../../../../../core/utils/wedge_app_bar.dart';
import '../../../../../core/utils/wedge_country_code_picker.dart';
import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../core/widgets/buttons/wedge_button.dart';
import '../../../../../core/widgets/inputFields/custom_text_field.dart';
import '../../../../../core/widgets/inputFields/input_done_button.dart';
import '../../../terms_and_condition/presentation/pages/terms_and_condi_page.dart';
import '../cubit/signup_cubit.dart';
import '../cubit/validate_user_details_cubit.dart';
import '../widget/field_is_exist_pop.dart';
import '../widget/new_password_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  TextFieldValidator validator = TextFieldValidator();
  final _signUpFormKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  String? selectedContactNumberPrefix = DEFAULT_COUNTRY_CODE;
  ValueNotifier isButtonEnabled = ValueNotifier<bool>(false);
  ValueNotifier<bool> isEmailValid = ValueNotifier<bool>(false);
  String existValue = "";
  bool _isEmailFormatCorrect = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  //controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isPolicyChecked = ValueNotifier<bool>(false);
  late AnimationController _emailCheckController;

  @override
  void initState() {
    BlocProvider.of<SignUpCubit>(context, listen: false).emit(SignUpInitial());
    _setOnboarding();
    _emailFocusNode.addListener(_onEmailFocusChange);
    _phoneFocusNode.addListener(_onPhoneFocusChange);
    _phoneFocusNode.addListener(() {
      bool hasFocus = _phoneFocusNode.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });

    _emailCheckController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onEmailFocusChange);
    _emailFocusNode.dispose();
    _phoneFocusNode.removeListener(_onPhoneFocusChange);
    _phoneFocusNode.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    contactNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _setOnboarding() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    prefs.setBool(RootApplicationAccess.isFirstTimePreference, false);
  }

  void _onEmailFocusChange() {
    if (!_emailFocusNode.hasFocus) {
      context.read<ValidateUserDetailsCubit>().updateValidateUserDetailsDetails(
          {"email": emailController.text, "phone": ""});
    }
  }

  void _onPhoneFocusChange() {
    if (!_emailFocusNode.hasFocus) {
      context
          .read<ValidateUserDetailsCubit>()
          .updateValidateUserDetailsDetails({
        "email": "",
        "phone": "$selectedContactNumberPrefix${contactNumberController.text}"
      });
    }
  }

  void submitForm() {
    if (_signUpFormKey.currentState!.validate()) {
      checkIfExistingUser(emailController.text);
      context.read<SignUpCubit>().updateSignUpDetails({
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "password": passwordController.text,
        "tandc": isPolicyChecked.value ? "1" : "0",
        "primary_email": emailController.text,
        "mobile_phone":
            "$selectedContactNumberPrefix${contactNumberController.text}"
      });
    }
  }

  // checking local and current mail is same
  checkIfExistingUser(String currentEmail) {
    locator<SharedPreferences>()
        .remove(RootApplicationAccess.isUserBioMetricIsEnabledPreference);
    locator<SharedPreferences>()
        .remove(RootApplicationAccess.isDeviceBioMetricIsAvailable);
    locator<SharedPreferences>()
        .remove(RootApplicationAccess.didShowDeviceBioMetricBottomSheet);
  }

  void _validateForm() {
    isButtonEnabled.value = emailController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        contactNumberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        isPolicyChecked.value == true;
    isButtonEnabled.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeColors!.textLight,
      appBar: wedgeAppBar(
          context: context, backgroundColor: Colors.white, title: ""),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder<bool>(
              valueListenable: isEmailValid,
              builder: (context, isValidValue, _) {
                return Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: size.height * 0.026),
                          child: Text(
                            translate!.createAccount,
                            style: TitleHelper.h4.copyWith(
                                color: isValidValue
                                    ? appThemeColors!
                                        .loginColorTheme!.textTitleColor!
                                        .withOpacity(.5)
                                    : appThemeColors!
                                        .loginColorTheme!.textTitleColor),
                          ),
                        ),
                        Form(
                            key: _signUpFormKey,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              runSpacing: 14,
                              children: [
                                BlocListener<ValidateUserDetailsCubit,
                                    ValidateUserDetailsState>(
                                  listener: (context, state) {
                                    if (state is ValidateUserDetailsLoaded) {
                                      isEmailValid.value =
                                          state.validateUserDetailsModel[
                                                  'isExist'] ??
                                              false;
                                      existValue =
                                          state.validateUserDetailsModel[
                                              'existValue'];
                                    } else {
                                      isEmailValid.value = false;
                                    }
                                    isEmailValid.notifyListeners();
                                  },
                                  child: IgnorePointer(
                                    ignoring: existValue == "email"
                                        ? false
                                        : isValidValue,
                                    child: CustomTextField(
                                      title: translate!.emailID,
                                      hint: translate!.emailID,
                                      showSuffixIcon: true,
                                      isRequired: true,
                                      focusNode: _emailFocusNode,
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      isFieldHaveError: existValue == "email",
                                      suffixIcon: _isEmailFormatCorrect &&
                                              _emailFocusNode.hasFocus
                                          ? FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Lottie.asset(
                                                  Icons8.check_circle_win10,
                                                  controller:
                                                      _emailCheckController,
                                                  height: 25,
                                                  width: 25,
                                                  fit: BoxFit.fill),
                                            )
                                          : const SizedBox(),
                                      readOnly: existValue == "email"
                                          ? false
                                          : isValidValue,
                                      validator: (_) {
                                        final value = _ ?? "";
                                        return validator
                                            .validateEmail(value.trim());
                                      },
                                      onChanged: (value) {
                                        _validateForm();
                                        _emailCheckController.reset();
                                        _emailCheckController.forward();
                                        setState(() {
                                          _isEmailFormatCorrect =
                                              validator.validateEmail(
                                                      value.trim()) ==
                                                  null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      isValidValue && existValue == "email",
                                  child: FieldIsExistPop(
                                      userEmail: emailController.text),
                                ),
                                CustomTextField(
                                  title: translate!.firstName,
                                  hint: translate!.firstName,
                                  validator: (value) =>
                                      validator.validateUserName(value),
                                  isRequired: true,
                                  readOnly: isValidValue,
                                  controller: firstNameController,
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) {
                                    _validateForm();
                                  },
                                ),
                                CustomTextField(
                                  title: translate!.lastName,
                                  hint: translate!.lastName,
                                  readOnly: isValidValue,
                                  validator: (value) =>
                                      validator.validateUserName(value),
                                  isRequired: true,
                                  controller: lastNameController,
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) {
                                    _validateForm();
                                  },
                                ),
                                IgnorePointer(
                                  ignoring: existValue != "phone"
                                      ? isValidValue
                                      : false,
                                  child: CustomTextField(
                                    title: translate!.contactNumber,
                                    hint: translate!.contactNumber,
                                    readOnly: existValue != "phone"
                                        ? isValidValue
                                        : false,
                                    isFieldHaveError: existValue == "phone",
                                    isRequired: true,
                                    focusNode: _phoneFocusNode,
                                    prefix: contactNumberPrefix(isValidValue),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: contactNumberController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _validateForm();
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      isValidValue && existValue == "phone",
                                  child: FieldIsExistPop(),
                                ),
                                NewPasswordField(
                                    readOnly: isValidValue,
                                    controller: passwordController,
                                    validator: (value) {
                                      return validator.validateStrongPassword(
                                          value,
                                          showValidationMsg: false);
                                    },
                                    onChanged: _validateForm),
                                termsAndConditionsCheck(isValidValue, context),
                                BlocConsumer<SignUpCubit, SignUpState>(
                                  listener: (context, state) {
                                    if (state is SignUpLoaded) {
                                      context
                                          .read<SignUpCubit>()
                                          .getLoginWithToken(
                                              token:
                                                  state.signUpModel["token"]);
                                    }
                                  },
                                  builder: (context, state) {
                                    return ValueListenableBuilder(
                                        valueListenable: isButtonEnabled,
                                        builder: (context, isButtonEnabledValue,
                                            child) {
                                          return SizedBox(
                                            height: 45,
                                            width: size.width,
                                            child: WedgeSaveButton(
                                              onPressed: () {
                                                submitForm();
                                              },
                                              textStyle: TitleHelper.h9
                                                  .copyWith(
                                                      color: Colors.white),
                                              title: translate!.createAccount,
                                              isEnable: isButtonEnabledValue,
                                              isLoaing: state is SignUpLoading,
                                              isLoaded: state is SignUpLoaded,
                                            ),
                                          );
                                        });
                                  },
                                ),
                                alreadyHaveAccountRoute(context)
                              ],
                            )),
                      ],
                    ),
                  ),
                ));
              })
        ],
      ),
    );
  }

  // Country Phone code picker
  Widget contactNumberPrefix(bool isValidValue) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: () {
          WedgeCountryCodePicker(
              context: context,
              popTitle: translate!.selectCountryPhoneCode,
              countryPicked: (Country country) {
                setState(() {
                  selectedContactNumberPrefix = country.phoneCode!;
                });
                // _validateForm();
              });
        },
        child: SizedBox(
          width: 70,
          child: Row(
            children: [
              Text("+$selectedContactNumberPrefix",
                  style: SubtitleHelper.h11.copyWith(
                      color: isValidValue ? Colors.grey : Colors.black)),
              const SizedBox(width: 5),
              Icon(Icons.keyboard_arrow_down_outlined,
                  color: isValidValue ? Colors.grey : Colors.black)
            ],
          ),
        ),
      ),
    );
  }

  Row termsAndConditionsCheck(bool isValidValue, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
          child: ValueListenableBuilder<bool>(
              valueListenable: isPolicyChecked,
              builder: (BuildContext context, bool value, Widget? child) {
                return Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  checkColor: Colors.white,
                  value: isPolicyChecked.value,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  activeColor: appThemeColors!.primary!,
                  side: BorderSide(color: appThemeColors!.primary!),
                  onChanged: isValidValue
                      ? null
                      : (bool? value) {
                          isPolicyChecked.value = value ?? false;
                          isPolicyChecked.notifyListeners();
                          _validateForm();
                        },
                );
              }),
        ),
        Expanded(
          child: RichText(
              text: TextSpan(
                  text: translate!.iAgreeWithThe,
                  style: SubtitleHelper.h12.copyWith(color: Colors.grey),
                  children: [
                TextSpan(
                  text: translate!.privacyPolicy,
                  style: SubtitleHelper.h12.copyWith(
                      decoration: TextDecoration.underline,
                      color: appThemeColors!.primary!),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => TermsConditionPage(
                                    hideAcceptButton: true,
                                    displayUrl: appTheme.privacyPolicy!,
                                  )));
                    },
                ),
                const TextSpan(text: " & "),
                TextSpan(
                  text: translate!.termsConditions,
                  style: SubtitleHelper.h12.copyWith(
                      decoration: TextDecoration.underline,
                      color: appThemeColors!.primary!),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => TermsConditionPage(
                                    hideAcceptButton: true,
                                    displayUrl: appTheme.termsCondition!,
                                  )));
                    },
                )
              ])),
        )
      ],
    );
  }

  Container alreadyHaveAccountRoute(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 15, bottom: 30),
        child: RichText(
            text: TextSpan(
                text: translate!.alreadyHaveAnAccount,
                style: SubtitleHelper.h11.copyWith(color: Colors.grey),
                children: [
              TextSpan(
                text: translate!.login,
                style: SubtitleHelper.h11.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    color: appThemeColors!.primary!),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    RootApplicationAccess().navigateToLogin(context);
                  },
              ),
            ])));
  }
}

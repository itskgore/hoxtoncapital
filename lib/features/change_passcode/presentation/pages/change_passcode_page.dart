import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/biometrics_auth.dart';
import 'package:wedge/core/helpers/login_navigator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/bottom_button_widget.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/inputFields/generic_textField.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/app_passcode/create_passcode/presentation/cubit/create_passcode_cubit.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

import '../../../account/my_account/presentation/cubit/get_tenant_cubit.dart';

class CreatePasscodePage extends StatefulWidget {
  final String userMail;
  bool? fromLogin;

  CreatePasscodePage({Key? key, required this.userMail, this.fromLogin})
      : super(key: key);

  @override
  State<CreatePasscodePage> createState() => _ChangePasscodePageState();
}

class _ChangePasscodePageState extends State<CreatePasscodePage> {
  final ValueNotifier<bool> _newPasscode = ValueNotifier<bool>(true);

  final ValueNotifier<bool> _confirmPasscode = ValueNotifier<bool>(true);

  final ValueNotifier<bool> _oldPasscode = ValueNotifier<bool>(true);

  TextEditingController _oldPasscodetxt = TextEditingController();

  TextEditingController _newPasscodetxt = TextEditingController();

  TextEditingController _confirmPasscodetxt = TextEditingController();

  CreatePasscodeCubit getBloc() => context.read<CreatePasscodeCubit>();

  final _formKey = GlobalKey<FormState>();

  submitPasscode(
    BuildContext context,
    String? url,
  ) {
    final userdata = locator<SharedPreferences>()
            .getString(RootApplicationAccess.loginUserPreferences) ??
        "";
    final data = LoginModel.fromJson(json.decode(userdata));
    final String passcode = locator<SharedPreferences>()
            .getString(RootApplicationAccess.appPasscodePreferences) ??
        "";
    if (_formKey.currentState!.validate()) {
      if (_confirmPasscodetxt.text != _newPasscodetxt.text) {
        showSnackBar(
            context: context,
            title: "The passcode & confirmation passcode do not match");
      } else if (widget.fromLogin != null && widget.fromLogin == false) {
        if (_oldPasscodetxt.text.toLowerCase() ==
            _newPasscodetxt.text.toLowerCase()) {
          showSnackBar(
              context: context,
              title: "The passcode should not be same as the old passcode");
        }
      } else if (widget.fromLogin != null && widget.fromLogin == false) {
        if (passcode == _newPasscodetxt.text) {
          showSnackBar(context: context, title: "Old passcode is not correct");
        }
      } else {
        _formKey.currentState!.save();
        if (widget.fromLogin == null && BioMetricsAuth().shouldOpenMpin()) {
          getBloc().createPasscode({
            "oldPassCode": "${_oldPasscodetxt.text}",
            "passCode": "${_newPasscodetxt.text}",
            "confirmPassCode": "${_confirmPasscodetxt.text}",
            "email": widget.userMail,
            "url": url,
          });
        } else {
          getBloc().createPasscode({
            "passCode": "${_newPasscodetxt.text}",
            "confirmPassCode": "${_confirmPasscodetxt.text}",
            "email": widget.userMail,
            "url": url,
          });
        }
      }
    }
  }

  validatePasscode(
      {required String regexText,
      required String value,
      required String errorText}) {
    RegExp regex = new RegExp(regexText);
    if (!regex.hasMatch(value))
      return errorText;
    else
      return null;
  }

  @override
  void initState() {
    context.read<GetTenantCubit>().getTanent();
    context.read<CreatePasscodeCubit>().emit(CreatePasscodeInitial());
    super.initState();
  }

  LoginModel getUserDetails() {
    final userdata = locator<SharedPreferences>()
            .getString(RootApplicationAccess.loginUserPreferences) ??
        "";
    return LoginModel.fromJson(json.decode(userdata));
  }

  int passcodeLength = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(context: context, title: "New Passcode"),
        body: BlocConsumer<CreatePasscodeCubit, CreatePasscodeState>(
          listener: (context, passwordState) {
            if (passwordState is CreatePasscodeLoaded) {
              locator.get<WedgeDialog>().success(
                  context: context,
                  title: "Passcode created successfully",
                  // "In some cases it may take a while to establish a secure connection to the banking institution. So, if you have added your bank and don't see the information in the home screen, don't worry. We'll be working fast to fetch the details and show you the comprehensive financial data as soon as possible.",
                  info: "",
                  onClicked: () async {
                    if (widget.fromLogin != null && widget.fromLogin == true) {
                      context
                          .read<CreatePasscodeCubit>()
                          .emit(CreatePasscodeLoading());
                      LoginNavigator(context, getUserDetails());
                      showSnackBar(context: context, title: "Loading....");
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  });
            } else if (passwordState is CreatePasscodeError) {
              showSnackBar(context: context, title: passwordState.errorMsg);
            }
          },
          builder: (context, passwordState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Text(
                      //     "${state.tenantEntity.preferences?.passcode?.instructions?.mobile}"),
                      widget.fromLogin ?? false
                          ? SizedBox.shrink()
                          : BioMetricsAuth().shouldOpenMpin()
                              ? ValueListenableBuilder<bool>(
                                  valueListenable: _oldPasscode,
                                  builder: (context, value, _) {
                                    return GenericTextField(
                                      type: TextInputType.number,
                                      maxLength: passcodeLength,
                                      placeholder: "Old passcode",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your old passcode";
                                        }
                                        return null;
                                      },
                                      textController: _oldPasscodetxt,
                                      obscureText: _oldPasscode.value,
                                      suffixWidget: GestureDetector(
                                          onTap: () {
                                            _oldPasscode.value =
                                                !_oldPasscode.value;
                                            _oldPasscode.notifyListeners();
                                          },
                                          child: Icon(_oldPasscode.value
                                              ? Icons.visibility_off
                                              : Icons.visibility)),
                                    );
                                  })
                              : const SizedBox.shrink(),
                      const SizedBox(
                        height: 30,
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: _newPasscode,
                          builder: (context, value, _) {
                            return GenericTextField(
                              type: TextInputType.number,
                              maxLength: passcodeLength,
                              placeholder: "Passcode",
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "Passcode Required";
                                } else if (value?.length != passcodeLength) {
                                  return "$passcodeLength digits are required";
                                }
                              },
                              textController: _newPasscodetxt,
                              obscureText: value,
                              suffixWidget: GestureDetector(
                                  onTap: () {
                                    _newPasscode.value = !_newPasscode.value;
                                    _newPasscode.notifyListeners();
                                  },
                                  child: Icon(value
                                      ? Icons.visibility_off
                                      : Icons.visibility)),
                            );
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: _confirmPasscode,
                          builder: (context, value, _) {
                            return GenericTextField(
                              maxLength: passcodeLength,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "Confirmation passcode required";
                                } else if (value?.length != passcodeLength) {
                                  return "$passcodeLength digits are required";
                                }
                              },
                              placeholder: "Confirm passcode",
                              textController: _confirmPasscodetxt,
                              obscureText: value,
                              suffixWidget: GestureDetector(
                                  onTap: () {
                                    _confirmPasscode.value =
                                        !_confirmPasscode.value;
                                    _confirmPasscode.notifyListeners();
                                  },
                                  child: Icon(value
                                      ? Icons.visibility_off
                                      : Icons.visibility)),
                            );
                          }),

                      // Spacer(),
                      const SizedBox(
                        height: 60,
                      ),
                      passwordState is CreatePasscodeLoading
                          ? buildCircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: WedgeButton(
                                  text: "Submit",
                                  onPressed: () {
                                    submitPasscode(context, null);
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }),
                            ),
                      const SizedBox(
                        height: 30,
                      ),
                      widget.fromLogin != null && widget.fromLogin == true
                          ? passwordState is CreatePasscodeLoading
                              ? const SizedBox.shrink()
                              : GestureDetector(
                                  onTap: () {
                                    showSnackBar(
                                        context: context, title: "Loading....");
                                    LoginNavigator(context, getUserDetails());
                                  },
                                  child: Text(
                                    "Skip",
                                    style: TitleHelper.h10.copyWith(
                                      color: appThemeColors!.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}

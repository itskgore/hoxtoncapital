import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/bottom_button_widget.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/inputFields/generic_textField.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/change_password/domain/model/change_password_params_model.dart';
import 'package:wedge/features/change_password/presentation/cubit/change_password_cubit.dart';

import '../../../account/my_account/presentation/cubit/get_tenant_cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  final String userMail;

  ChangePasswordPage({Key? key, required this.userMail}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final ValueNotifier<bool> _newPassword = ValueNotifier<bool>(true);

  final ValueNotifier<bool> _confirmPassword = ValueNotifier<bool>(true);

  final ValueNotifier<bool> _oldPassword = ValueNotifier<bool>(true);

  TextEditingController _oldPasswordtxt = TextEditingController();

  TextEditingController _newPasswordtxt = TextEditingController();

  TextEditingController _confirmPasswordtxt = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  submitPassword(BuildContext context, String url) {
    if (_formKey.currentState!.validate()) {
      if (_confirmPasswordtxt.text != _newPasswordtxt.text) {
        showSnackBar(
            context: context,
            title: "The password & confirmation password do not match");
      } else if (_oldPasswordtxt.text.toLowerCase() ==
          _newPasswordtxt.text.toLowerCase()) {
        showSnackBar(
            context: context,
            title: "The password should not be same as the old password");
      } else {
        _formKey.currentState!.save();
        context
            .read<ChangePasswordCubit>()
            .changePassword(ChangePasswordParams(body: {
              "oldPassword": _oldPasswordtxt.text,
              "password": _newPasswordtxt.text,
              "confirmPassword": _confirmPasswordtxt.text,
              "email": widget.userMail,
              "accessToken": Repository().getToken().replaceAll("bearer ", ""),
            }, url: url));
      }
    }
  }

  validatePassword(
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var style2 = Style(
      fontSize: FontSize(15),
      whiteSpace: WhiteSpace.normal,
    );
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(context: context, title: "Change Password"),
      body: BlocBuilder<GetTenantCubit, GetTenantState>(
        builder: (context, state) {
          if (state is GetTenantLoading) {
            return Center(child: buildCircularProgressIndicator(width: 150));
          } else if (state is GetTenantLoaded) {
            return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
              listener: (context, passwordState) {
                if (passwordState is ChangePasswordLoaded) {
                  locator.get<WedgeDialog>().success(
                      context: context,
                      title: "Password changed successfully",
                      // "In some cases it may take a while to establish a secure connection to the banking institution. So, if you have added your bank and don't see the information in the home screen, don't worry. We'll be working fast to fetch the details and show you the comprehensive financial data as soon as possible.",
                      info: "",
                      onClicked: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                } else if (passwordState is ChangePasswordError) {
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
                          //     "${state.tenantEntity.preferences?.password?.instructions?.mobile}"),
                          ValueListenableBuilder<bool>(
                              valueListenable: _oldPassword,
                              builder: (context, value, _) {
                                return GenericTextField(
                                  placeholder: "Old password",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your old password";
                                    }
                                    return null;
                                    // return validatePassword(
                                    //     regexText: state.tenantEntity.preferences
                                    //             ?.password?.regExp
                                    //             ?.replaceAll('"', "") ??
                                    //         "",
                                    //     value: value ?? "",
                                    //     errorText: "Enter valid old password");
                                  },
                                  textController: _oldPasswordtxt,
                                  obscureText: _oldPassword.value,
                                  suffixWidget: GestureDetector(
                                      onTap: () {
                                        _oldPassword.value =
                                            !_oldPassword.value;
                                        _oldPassword.notifyListeners();
                                      },
                                      child: Icon(_oldPassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility)),
                                );
                              }),
                          const SizedBox(
                            height: 30,
                          ),
                          ValueListenableBuilder<bool>(
                              valueListenable: _newPassword,
                              builder: (context, value, _) {
                                return GenericTextField(
                                  placeholder: "Password",
                                  validator: (value) {
                                    return validatePassword(
                                        regexText: state.tenantEntity
                                                .preferences?.password?.regExp
                                                ?.replaceAll('"', "") ??
                                            "",
                                        value: value ?? "",
                                        errorText:
                                            "The password does not meet the password requirements.");
                                  },
                                  textController: _newPasswordtxt,
                                  obscureText: value,
                                  suffixWidget: GestureDetector(
                                      onTap: () {
                                        _newPassword.value =
                                            !_newPassword.value;
                                        _newPassword.notifyListeners();
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
                              valueListenable: _confirmPassword,
                              builder: (context, value, _) {
                                return GenericTextField(
                                  type: TextInputType.text,
                                  placeholder: "Confirm password",
                                  textController: _confirmPasswordtxt,
                                  // validator: (value) {
                                  //   return validatePassword(
                                  //       regexText: state.tenantEntity
                                  //               .preferences?.password?.regExp
                                  //               ?.replaceAll('"', "") ??
                                  //           "",
                                  //       value: value ?? "",
                                  //       errorText: "");
                                  // },
                                  obscureText: value,
                                  suffixWidget: GestureDetector(
                                      onTap: () {
                                        _confirmPassword.value =
                                            !_confirmPassword.value;
                                        _confirmPassword.notifyListeners();
                                      },
                                      child: Icon(value
                                          ? Icons.visibility_off
                                          : Icons.visibility)),
                                );
                              }),
                          const SizedBox(
                            height: 30,
                          ),
                          Html(
                            data: state.tenantEntity.preferences?.password
                                ?.instructions?.mobile,
                            style: {
                              "li": style2,
                              "ol": style2,
                              "ul": style2,
                            },
                            onCssParseError: (css, messages) {
                              log("css that errored: $css");
                              log("error messages:");
                              messages.forEach((element) {
                                log(element.toString());
                              });
                            },
                          ),
                          // Spacer(),
                          const SizedBox(
                            height: 60,
                          ),
                          passwordState is ChangePasswordLoading
                              ? buildCircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  child: WedgeButton(
                                      text: "Submit",
                                      onPressed: () {
                                        if (state
                                                .tenantEntity
                                                .preferences
                                                ?.portal
                                                ?.authentication
                                                ?.isSSO ??
                                            false) {
                                          submitPassword(
                                              context,
                                              state
                                                      .tenantEntity
                                                      .preferences
                                                      ?.portal
                                                      ?.authentication
                                                      ?.changePasswordURL ??
                                                  "");
                                        } else {
                                          submitPassword(
                                              context,
                                              state
                                                      .tenantEntity
                                                      .preferences
                                                      ?.portal
                                                      ?.authentication
                                                      ?.changePasswordURL ??
                                                  "${identityEndpoint}/auth/changePassword");
                                        }
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      }),
                                ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

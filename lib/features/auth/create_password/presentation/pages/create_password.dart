import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/firebase_analytics.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/wedge_logo.dart';
import 'package:wedge/features/auth/create_password/presentation/cubit/create_password_cubit.dart';

class CreatePassword extends StatefulWidget {
  final String email;

  CreatePassword({Key? key, required this.email}) : super(key: key);

  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  //Controllers
  TextEditingController _passwordtxt = TextEditingController();
  TextEditingController _confirmPasswordTxt = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextFieldValidator validator = TextFieldValidator();

  submitData() {
    if (_formKey.currentState!.validate()) {
      if (_passwordtxt.text != _confirmPasswordTxt.text) {
        showSnackBar(
            context: context,
            title: "Password and confirm password do not match");
      } else {
        AppAnalytics().trackEvent(
            eventName: "sign_up_reset_password",
            parameters: {"email": "${widget.email}"});
        // submit Data
        BlocProvider.of<CreatePasswordCubit>(context, listen: false)
            .resetPassword({
          'email': widget.email.toLowerCase(),
          'password': _passwordtxt.text
        });
      }
    }
  }

  String passwordHidden = "assets/icons/passwordHidden.png";
  String passwordShow = "assets/icons/passwordShow.png";

  bool showPassword = true;
  bool showConfirmPassword = true;

  changePasswordState(bool isConfirmPassword) {
    setState(() {
      if (isConfirmPassword) {
        showConfirmPassword = !showConfirmPassword;
      } else {
        showPassword = !showPassword;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordtxt.dispose();
    _confirmPasswordTxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(),
          actions: [
            getWireDashIcon(context),
          ],
          title: const SizedBox(
            height: 25,
            child: WedgeLogo(
              height: 100.0,
              width: 150.0,
              darkLogo: false,
            ),
          ),
        ),
        bottomNavigationBar:
            BlocConsumer<CreatePasswordCubit, CreatePasswordState>(
          listener: (context, state) {
            if (state is CreatePasswordError) {
              showSnackBar(context: context, title: state.errorMsg);
            } else if (state is CreatePasswordLoaded) {
              showSnackBar(
                  context: context, title: "Password created successfully");
              Navigator.pop(context);
              // push to next screen
            } else if (state is CreatePasswordLoading) {}
          },
          builder: (context, state) {
            bool isLoading = state is CreatePasswordLoading;
            return Container(
              margin: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: appThemeColors!.textDark!.withOpacity(0.451),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kborderRadius)),
                  elevation: 0,
                  fixedSize: const Size(0, 60),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        submitData();
                      },
                child: isLoading
                    ? buildCircularProgressIndicator()
                    : Text(
                        "Create password",
                        style: TextHelper.h1Second.copyWith(
                            fontWeight: FontWeight.normal,
                            fontFamily: kfontFamily,
                            fontSize: kfontLarge,
                            color: kfontColorLight),
                      ),
              ),
            );
          },
        ),
        body: WillPopScope(
          onWillPop: () async {
            showSnackBar(
                context: context, title: "Please create a password to proceed");
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create new password",
                        style: TitleHelper.h3.copyWith(
                          color: kfontColorLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Please enter a new password",
                        style: SubtitleHelper.h10
                            .copyWith(color: appThemeColors!.disableDark),
                        // TextStyle(
                        //     fontSize: kfontMedium, color: Colors.white38),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _passwordtxt,
                              obscureText: showPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter new password";
                                }
                                if (value.length < 6) {
                                  return "Minimum 6 length required";
                                }
                              },
                              style:
                                  TextStyle(color: appThemeColors!.textLight),
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        changePasswordState(false);
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
                                  hintText: "Enter new password",
                                  hintStyle: TextHelper.h5.copyWith(
                                      color: appThemeColors!.disableDark),
                                  errorStyle: kerrorTextstyle,
                                  errorBorder: kerrorTextfeildBorder),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _confirmPasswordTxt,
                              obscureText: showConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter confirm password";
                                }
                                if (value.length < 6) {
                                  return "Minimum 6 length required";
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  filled: true,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        changePasswordState(true);
                                      },
                                      icon: Image.asset(
                                        !showConfirmPassword
                                            ? passwordShow
                                            : passwordHidden,
                                        width: 24,
                                      )),
                                  fillColor: appThemeColors!.textDark!
                                      .withOpacity(0.259),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintText: "Confirm password",
                                  hintStyle: SubtitleHelper.h10.copyWith(
                                      color: appThemeColors!.disableDark),
                                  errorStyle: kerrorTextstyle,
                                  errorBorder: kerrorTextfeildBorder),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(left: 5),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "The password must have a minimum of 6 characters.",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: SubtitleHelper.h11.copyWith(
                                  color: appThemeColors!.disableDark!
                                      .withOpacity(0.60),
                                ),
                                // TextStyle(
                                //     fontSize: kfontMedium, color: Colors.white38),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

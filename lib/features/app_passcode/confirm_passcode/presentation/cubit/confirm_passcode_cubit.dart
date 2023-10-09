import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/domain/usecases/login.dart';
import 'package:wedge/features/auth/hoxton_login/domain/usecases/login_with_otp.dart';

import '../../../../../core/helpers/login_navigator.dart';
import '../../../../auth/hoxton_login/data/models/login_model.dart';

part 'confirm_passcode_state.dart';

class ConfirmPasscodeCubit extends Cubit<ConfirmPasscodeState> {
  final LoginWithOTP loginWithOTP;

  ConfirmPasscodeCubit(this.loginWithOTP) : super(ConfirmPasscodeInitial());
  List<Map<String, dynamic>> numbers = [
    {"no": 1, "actions": "no"},
    {"no": 2, "actions": "no"},
    {"no": 3, "actions": "no"},
    {"no": 4, "actions": "no"},
    {"no": 5, "actions": "no"},
    {"no": 6, "actions": "no"},
    {"no": 7, "actions": "no"},
    {"no": 8, "actions": "no"},
    {"no": 9, "actions": "no"},
    {"no": "Done", "actions": "Done"},
    {"no": 0, "actions": "no"},
    {"no": "<-", "actions": "yes"},
  ];

  confirmPasscode(
    dynamic email,
    dynamic password,
    dynamic isTermsAndConditionsAccepted, {
    required bool fromSplash,
    required BuildContext context,
    String? passcode,
    bool? isOTPVerified,
  }) async {
    emit(ConfirmPasscodeLoading());
    final result = loginWithOTP(LoginParams(
        email: email,
        password: password,
        passCode: passcode,
        isOTPVerified: isOTPVerified,
        isTermsAndConditionsAccepted: isTermsAndConditionsAccepted));
    result.then((value) => value.fold((l) {
          emit(ConfirmPasscodeError(
              errorMsg: l.apiMsg ?? l.displayErrorMessage()));
          Future.delayed(const Duration(milliseconds: 900), () {
            emit(ConfirmPasscodeInitial());
          });
        }, (r) {
          locator<SharedPreferences>()
              .setBool(RootApplicationAccess.isMPinEnabledPreference, true);
          locator<SharedPreferences>()
              .setBool(RootApplicationAccess.isSkippedPreference, true);
          locator<SharedPreferences>()
              .setBool(RootApplicationAccess.firstLoginPreference, false);
          if (fromSplash) {
            navigateToLogin(context);
          } else {
            emit(ConfirmPasscodeLoaded(passcode: passcode ?? ""));
          }
        }));
  }

  navigateToLogin(BuildContext context) {
    emit(ConfirmPasscodeLoading());
    final data = LoginModel.fromJson(json.decode(locator<SharedPreferences>()
            .getString(RootApplicationAccess.loginUserPreferences) ??
        locator<SharedPreferences>()
            .getString(RootApplicationAccess.passcodeLoginPreferences) ??
        ""));
    LoginNavigator(context, data);
  }
}

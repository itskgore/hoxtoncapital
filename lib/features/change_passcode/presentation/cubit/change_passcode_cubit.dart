import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

import '../../domain/model/change_passcode_params_model.dart';
import '../../domain/usecases/change_passcode_usecase.dart';

part 'change_passcode_state.dart';

class ChangePasscodeCubit extends Cubit<ChangePasscodeState> {
  ChangePasscodeCubit(this.changePasscodeUsecase)
      : super(ChangePasscodeInitial());
  final ChangePasscodeUsecase changePasscodeUsecase;

  changePasscode(ChangePasscodeParams params) {
    emit(ChangePasscodeLoading());
    final res = changePasscodeUsecase(params);
    res.then((value) => value.fold((l) {
          if (l is TokenExpired) {
            changePasscode(params);
          } else {
            emit(ChangePasscodeError(l.responseMsg ?? l.displayErrorMessage()));
          }
        }, (r) {
          locator<SharedPreferences>()
              .setBool(RootApplicationAccess.isMPinEnabledPreference, true);
          final userdata = locator<SharedPreferences>()
                  .getString(RootApplicationAccess.loginUserPreferences) ??
              "";
          final data = LoginModel.fromJson(json.decode(userdata));
          final newData = LoginModel(
              isMpineEnabled: true,
              enableOTP: data.enableOTP,
              isProfileCompleted: data.isProfileCompleted,
              accessToken: data.accessToken,
              refreshToken: data.refreshToken,
              isOnboardingCompleted: data.isOnboardingCompleted,
              isTermsAndConditionsAccepted: data.isTermsAndConditionsAccepted,
              lastLogin: data.lastLogin);
          locator<SharedPreferences>().setString(
              RootApplicationAccess.loginUserPreferences, json.encode(newData));
          emit(ChangePasscodeLoaded(r));
        }));
  }
}

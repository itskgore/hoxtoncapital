import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/app_passcode/create_passcode/domain/usecase/create_passcode_usecase.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

part 'create_passcode_state.dart';

class CreatePasscodeCubit extends Cubit<CreatePasscodeState> {
  final CreatePasscodeUseCase createPasscodeUsecase;

  CreatePasscodeCubit(this.createPasscodeUsecase)
      : super(CreatePasscodeInitial());
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
    {"no": "<-", "actions": "no"},
    {"no": 0, "actions": "no"},
    {"no": "Done", "actions": "Done"},
  ];

  createPasscode(Map<String, dynamic> body) async {
    emit(CreatePasscodeLoading());
    final result = createPasscodeUsecase(body);
    result.then((value) => value.fold(
            (l) => emit(CreatePasscodeError(
                passcodeEntered: body['passCode'],
                errorMsg: "${l.apiMsg}")), (r) async {
          await locator<SharedPreferences>().setString(
              RootApplicationAccess.appPasscodePreferences, body['passCode']);
          await locator<SharedPreferences>()
              .setBool(RootApplicationAccess.isMPinEnabledPreference, true);
          await locator<SharedPreferences>().remove(
            RootApplicationAccess.passcodeCreateSectionPreferences,
          );

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
          emit(CreatePasscodeLoaded(passcodeEntered: body['passCode']));
        }));
  }
}

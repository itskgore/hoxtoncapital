import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/auth/terms_and_condition/domain/usecase/accept_term_condition_usecase.dart';

part 'terms_and_conditions_state.dart';

class TermsAndConditionsCubit extends Cubit<TermsAndConditionsState> {
  TermsAndConditionsCubit(this.acceptTermConditionUsecase)
      : super(TermsAndConditionsInitial());
  final AcceptTermConditionUseCase acceptTermConditionUsecase;

  acceptTermCondition() {
    emit(TermsAndConditionsLoading());
    final result = acceptTermConditionUsecase(NoParams());
    result.then((value) => value
            .fold((l) => emit(TermsAndConditionsError(l.displayErrorMessage())),
                (r) async {
          final loginData = locator<SharedPreferences>()
              .getString(RootApplicationAccess.loginUserPreferences);
          final data = LoginModel.fromJson(json.decode(loginData ?? ""));
          data.isTermsAndConditionsAccepted = true;
          await locator<SharedPreferences>().setString(
              RootApplicationAccess.loginUserPreferences, json.encode(data));
          await RootApplicationAccess().storeAssets();
          await RootApplicationAccess().storeLiabilities();
          await RootApplicationAccess().refreshFCMToken();
          emit(TermsAndConditionsLoaded());
        }));
  }

  rejectTermCondition() async {
    emit(TermsAndConditionsLoading());
    emit(TermsAndConditionsInitial());
    await RootApplicationAccess().logoutAndClearData();
  }
}

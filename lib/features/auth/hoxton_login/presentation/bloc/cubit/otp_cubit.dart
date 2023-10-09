import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_entity.dart';
import 'package:wedge/features/auth/hoxton_login/domain/usecases/validate_otp_usecase.dart';

import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/resend_code_usecase.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  ValidateOTPUsecase validateOTPUsecase;
  ResendOTPusecase resendOTPusecase;
  final LoginUserEntity _loginuserData = LoginUserEntity(
      accessToken: "",
      isOnboardingCompleted: false,
      enableOTP: false,
      isProfileCompleted: false,
      isTermsAndConditionsAccepted: false,
      refreshToken: "",
      lastLogin: "",
      isMpineEnabled: false);

  OtpCubit({required this.validateOTPUsecase, required this.resendOTPusecase})
      : super(OtpInitial(
            isresentCode: false,
            isResendPasswordLoading: false,
            isValidationLoading: false,
            errorMessage: "",
            loginuserData: LoginUserEntity(
              isMpineEnabled: false,
              enableOTP: false,
              isProfileCompleted: false,
              accessToken: "",
              isOnboardingCompleted: false,
              isTermsAndConditionsAccepted: false,
              refreshToken: "",
              lastLogin: "",
            )));

  Future validateOTP(email, password) async {
    emit(OtpLoading());
    //  _displayLoading(isEmailVerified: true);
    final _result = validateOTPUsecase(LoginParams(
        email: email, password: password, isTermsAndConditionsAccepted: true));

    _result.then((value) {
      value.fold(
          //if failed
          (failure) => emit(OtpInitial(
                isresentCode: false,
                errorMessage: failure.displayErrorMessage(),
                loginuserData: _loginuserData,
                isResendPasswordLoading: false,
                isValidationLoading: false,
              )),
          //if success
          (loginuserData) {
        locator<SharedPreferences>()
            .remove(RootApplicationAccess.passcodeLoginPreferences);
        emit(OtpSuccess(
          loginuserData: loginuserData,
        ));
      });
    });
  }

  Future sendOTP(email) async {
    emit(OtpLoading());
    final _result = resendOTPusecase(LoginParams(
        email: email, password: "", isTermsAndConditionsAccepted: true));

    _result.then((value) {
      value.fold(
          //if failed
          (failure) => emit(OtpInitial(
                isresentCode: false,
                errorMessage: failure.displayErrorMessage(),
                loginuserData: _loginuserData,
                isResendPasswordLoading: false,
                isValidationLoading: false,
              )),
          //if success
          (data) => emit(OtpInitial(
                isresentCode: true,
                errorMessage: "",
                loginuserData: _loginuserData,
                isResendPasswordLoading: false,
                isValidationLoading: false,
              )));
    });
  }

  resetOTPState() {
    emit(OtpLoading());
    emit(OtpInitial(
      isresentCode: false,
      errorMessage: "",
      loginuserData: _loginuserData,
      isResendPasswordLoading: false,
      isValidationLoading: false,
    ));
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_email_entity.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_entity.dart';
import 'package:wedge/features/auth/hoxton_login/domain/usecases/login.dart';
import 'package:wedge/features/auth/hoxton_login/domain/usecases/login_with_otp.dart';
import 'package:wedge/features/auth/hoxton_login/domain/usecases/reset_password.dart';
import 'package:wedge/features/auth/hoxton_login/domain/usecases/validate_otp_usecase.dart';
import 'package:wedge/features/auth/hoxton_login/domain/usecases/verify_email_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  ///usecases
  final VerifyEmail verifyEmail;
  final LoginUser userLogin;
  final ResetPassword resetPassword;
  final LoginWithOTP loginWithOTP;
  final ValidateOTPUsecase validateOTPUsecase;

  LoginEmailEntity _verifyEmailData = LoginEmailEntity(
    email: "",
    firstName: '',
    isOnboardingCompleted: false,
    isTermsAndConditionsAccepted: false,
    isForceResetPassword: true,
    lastName: '',
  );

  LoginUserEntity _loginuserData = LoginUserEntity(
    isMpineEnabled: false,
    accessToken: "",
    enableOTP: false,
    isProfileCompleted: false,
    isOnboardingCompleted: false,
    isTermsAndConditionsAccepted: false,
    refreshToken: "",
    lastLogin: "",
  );

  ///load initial state
  LoginCubit(
      {required this.verifyEmail,
      required this.userLogin,
      required this.resetPassword,
      required this.loginWithOTP,
      required this.validateOTPUsecase})
      : super(LoginInitial(
            isloading: false,
            errorMessage: "",
            isEmailVerified: false,
            isPasswordVerified: false,
            emailUserData: LoginEmailEntity(
              email: "",
              firstName: '',
              isOnboardingCompleted: false,
              isTermsAndConditionsAccepted: false,
              lastName: '',
            ),
            loginUserData: LoginUserEntity(
              lastLogin: "",
              isMpineEnabled: false,
              enableOTP: false,
              isProfileCompleted: false,
              refreshToken: "",
              accessToken: "",
              isTermsAndConditionsAccepted: false,
              isOnboardingCompleted: false,
            ),
            isForgotPasswordClicked: false,
            isResetPasswordLinkSent: false,
            loginSuccess: {}));

//verify email address
  Future verifyEmailAddress(email) async {
    // _displayLoading(isEmailVerified: false);
    final _result = verifyEmail(EmailParams(email: email));
    _result.then((value) {
      value.fold(
          //if failed
          (failure) => emit(LoginInitial(
              isloading: false,
              errorMessage: failure.displayErrorMessage(),
              isEmailVerified: false,
              isPasswordVerified: false,
              emailUserData: _verifyEmailData,
              loginUserData: _loginuserData,
              isForgotPasswordClicked: false,
              isResetPasswordLinkSent: false,
              loginSuccess: {})),
          //if success
          (data) {
        _verifyEmailData = data;
        emit(LoginInitial(
            isloading: false,
            errorMessage: "",
            isForceResetPassword: data.isForceResetPassword,
            isEmailVerified: true,
            isPasswordVerified: false,
            emailUserData: data,
            loginUserData: _loginuserData,
            isForgotPasswordClicked: false,
            isResetPasswordLinkSent: false,
            loginSuccess: {}));
      });
    });
  }

  Future login(email, password, isTermsAndConditionsAccepted) async {
    //  _displayLoading(isEmailVerified: true);
    final _result = userLogin(LoginParams(
        email: email,
        password: password,
        isTermsAndConditionsAccepted: isTermsAndConditionsAccepted));

    _result.then((value) {
      value.fold(
          //if failed
          (failure) => emit(LoginInitial(
              loginSuccess: {},
              //only for otp
              isloading: false,
              errorMessage: failure.apiMsg ?? failure.displayErrorMessage(),
              isEmailVerified: true,
              isPasswordVerified: false,
              emailUserData: _verifyEmailData,
              loginUserData: _loginuserData,
              isForgotPasswordClicked: false,
              isResetPasswordLinkSent: false)),
          //if success
          (loginuserData) => emit(LoginInitial(
              loginSuccess: {},
              isloading: false,
              errorMessage: "",
              isEmailVerified: true,
              isPasswordVerified: true,
              emailUserData: _verifyEmailData,
              loginUserData: loginuserData,
              isForgotPasswordClicked: false,
              isResetPasswordLinkSent: false)));
    });
  }

  Future validateOTP(email, password) async {
    //  _displayLoading(isEmailVerified: true);
    final _result = validateOTPUsecase(LoginParams(
        email: email, password: password, isTermsAndConditionsAccepted: true));

    _result.then((value) {
      value.fold(
          //if failed
          (failure) => emit(LoginInitial(
              loginSuccess: {},
              //only for otp
              isloading: false,
              errorMessage: failure.apiMsg ?? failure.displayErrorMessage(),
              isEmailVerified: true,
              isPasswordVerified: false,
              emailUserData: _verifyEmailData,
              loginUserData: _loginuserData,
              isForgotPasswordClicked: false,
              isResetPasswordLinkSent: false)),
          //if success
          (loginuserData) => emit(LoginInitial(
              loginSuccess: {},
              isloading: false,
              errorMessage: "",
              isEmailVerified: true,
              isPasswordVerified: true,
              emailUserData: _verifyEmailData,
              loginUserData: loginuserData,
              isForgotPasswordClicked: false,
              isResetPasswordLinkSent: false)));
    });
  }

  Future getLoginOTP(email, password, isTermsAndConditionsAccepted,
      {String? passcode, bool? isOTPVerified = true}) async {
    //  _displayLoading(isEmailVerified: true);
    final _result = loginWithOTP(LoginParams(
        email: email,
        password: password,
        passCode: passcode,
        isOTPVerified: isOTPVerified,
        isTermsAndConditionsAccepted: isTermsAndConditionsAccepted));

    _result.then((value) {
      value.fold(
          //if failed
          (failure) => emit(LoginInitial(
                isloading: false,
                errorMessage: failure.apiMsg ?? failure.displayErrorMessage(),
                isEmailVerified: true,
                isPasswordVerified: false,
                loginSuccess: {},
                emailUserData: _verifyEmailData,
                loginUserData: _loginuserData,
                isForgotPasswordClicked: false,
                isResetPasswordLinkSent: false,
              )),
          //if success
          (loginUserData) {
        emit(LoginInitial(
            isloading: false,
            isEmailVerified: true,
            isPasswordVerified: true,
            errorMessage: "",
            loginSuccess: loginUserData,
            emailUserData: _verifyEmailData,
            loginUserData: LoginModel.fromJson(loginUserData),
            isPasscodeLogin: passcode != null,
            isForgotPasswordClicked: false,
            isResetPasswordLinkSent: false));
      });
    });
  }

  _displayLoading({isEmailVerified}) {
    // show loading indicator
    emit(LoginInitial(
        loginSuccess: {},
        isloading: true,
        errorMessage: "",
        isEmailVerified: isEmailVerified,
        isPasswordVerified: false,
        isOTPVerified: false,
        emailUserData: _verifyEmailData,
        loginUserData: _loginuserData,
        isForgotPasswordClicked: false,
        isResetPasswordLinkSent: false));
  }

  goBack() {
    emit(LoginInitial(
        loginSuccess: {},
        isloading: false,
        errorMessage: "",
        isEmailVerified: false,
        isPasswordVerified: false,
        isOTPVerified: false,
        emailUserData: LoginEmailEntity(
          email: "",
          firstName: '',
          isOnboardingCompleted: false,
          isTermsAndConditionsAccepted: false,
          lastName: '',
        ),
        loginUserData: LoginUserEntity(
          lastLogin: "",
          isMpineEnabled: false,
          refreshToken: "",
          enableOTP: false,
          isProfileCompleted: false,
          accessToken: "",
          isOnboardingCompleted: false,
          isTermsAndConditionsAccepted: false,
        ),
        isForgotPasswordClicked: false,
        isResetPasswordLinkSent: false));
  }

  void forgotPassword() {
    emit(LoginInitial(
        loginSuccess: 0,
        isloading: false,
        errorMessage: "",
        isEmailVerified: true,
        isPasswordVerified: false,
        isOTPVerified: false,
        emailUserData: _verifyEmailData,
        loginUserData: LoginUserEntity(
          lastLogin: "",
          refreshToken: "",
          isMpineEnabled: false,
          enableOTP: false,
          isProfileCompleted: false,
          accessToken: "",
          isOnboardingCompleted: false,
          isTermsAndConditionsAccepted: false,
        ),
        isForgotPasswordClicked: true,
        isResetPasswordLinkSent: false));
  }

  Future sendresetPasswordLink(email) async {
    final _result = resetPassword(EmailParams(email: email));

    _result.then((value) {
      value.fold(
          //if failed
          (failure) => emit(LoginInitial(
              loginSuccess: {},
              isloading: false,
              errorMessage: failure.apiMsg ?? failure.displayErrorMessage(),
              isEmailVerified: true,
              isPasswordVerified: false,
              emailUserData: _verifyEmailData,
              loginUserData: _loginuserData,
              isOTPVerified: false,
              isForgotPasswordClicked: false,
              isResetPasswordLinkSent: false)),
          //if success
          (data) => emit(LoginInitial(
              loginSuccess: 0,
              isloading: false,
              errorMessage: "",
              isEmailVerified: true,
              isPasswordVerified: false,
              emailUserData: _verifyEmailData,
              loginUserData: _loginuserData,
              isForgotPasswordClicked: false,
              isResetPasswordLinkSent: true)));
    });
  }

  resetLoginpage() {
    emit(LoginInitial(
        loginSuccess: {},
        isloading: false,
        errorMessage: "",
        isEmailVerified: false,
        isPasswordVerified: false,
        isOTPVerified: false,
        emailUserData: LoginEmailEntity(
          email: "",
          firstName: '',
          isOnboardingCompleted: false,
          isTermsAndConditionsAccepted: false,
          lastName: '',
        ),
        loginUserData: LoginUserEntity(
          lastLogin: "",
          isMpineEnabled: false,
          enableOTP: false,
          isProfileCompleted: false,
          refreshToken: "",
          accessToken: "",
          isOnboardingCompleted: false,
          isTermsAndConditionsAccepted: false,
        ),
        isForgotPasswordClicked: false,
        isResetPasswordLinkSent: false));
  }
}

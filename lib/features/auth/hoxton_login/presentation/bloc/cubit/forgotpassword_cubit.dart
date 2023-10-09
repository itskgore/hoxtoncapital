import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/features/auth/hoxton_login/domain/usecases/reset_password.dart';
import 'package:wedge/features/auth/hoxton_login/domain/usecases/verify_email_usecase.dart';

part 'forgotpassword_state.dart';

class ForgotpasswordCubit extends Cubit<ForgotpasswordState> {
  ForgotpasswordCubit(this.resetPassword) : super(ForgotpasswordInitial());

  final ResetPassword resetPassword;

  resetState() {
    emit(ForgotpasswordInitial());
  }

  forgotPassword(String email) {
    final _result = resetPassword(EmailParams(email: email));
    emit(ForgotpasswordLoading());
    _result.then((value) {
      value.fold(
          //if failed
          (failure) => emit(ForgotpasswordError(failure.displayErrorMessage())),
          //if success
          (data) => emit(ForgotpasswordLoaded(data, email)));
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/helpers/login_navigator.dart';
import 'package:wedge/features/auth/signup/domain/usecases/login_with_token.dart';
import 'package:wedge/features/auth/signup/presentaion/cubit/signup_state.dart';

import '../../domain/usecases/signup_details_usecase.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.signUpUseCase, required this.loginWithToken})
      : super(SignUpInitial());
  final SignUpUseCase signUpUseCase;
  final LoginWithToken loginWithToken;

  updateSignUpDetails(dynamic body) {
    emit(SignUpLoading());
    final result = signUpUseCase(body);
    result.then((value) => value.fold((l) {
          if (l is TokenExpired) {
            updateSignUpDetails(body);
          } else {
            emit(SignUpError(l.displayErrorMessage()));
          }
        }, (r) {
          emit(SignUpLoaded(
            signUpModel: r,
          ));
        }));
  }

  getLoginWithToken({required String token}) {
    final result = loginWithToken(token);
    result.then((value) => value.fold((l) {
          if (l is TokenExpired) {
            getLoginWithToken(token: token);
          } else {
            emit(SignUpError(l.displayErrorMessage()));
          }
        }, (r) {
          LoginNavigator(navigatorKey.currentContext, r);
        }));
  }
}

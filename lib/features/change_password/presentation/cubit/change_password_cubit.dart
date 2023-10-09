import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/change_password/domain/model/change_password_params_model.dart';
import 'package:wedge/features/change_password/domain/usecases/change_password_usecase.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this.changePasswordUsecase)
      : super(ChangePasswordInitial());
  final ChangePasswordUsecase changePasswordUsecase;

  changePassword(ChangePasswordParams params) {
    emit(ChangePasswordLoading());
    final res = changePasswordUsecase(params);
    res.then((value) => value.fold((l) {
          if (l is TokenExpired) {
            changePassword(params);
          } else {
            emit(ChangePasswordError(l.responseMsg ?? l.displayErrorMessage()));
          }
        }, (r) => emit(ChangePasswordLoaded(r))));
  }
}

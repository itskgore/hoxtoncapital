import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/entities/user_account_data_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../../domain/usecase/edit_user_account_usecase.dart';
import '../../domain/usecase/get_user_account_usecase.dart';
import '../../domain/usecase/params/edit_user_account_params.dart';

part 'user_account_state.dart';

class UserAccountCubit extends Cubit<UserAccountState> {
  final GetUserAccountUseCase getUserAccountUseCase;
  final EditUserAccountUseCase editUserAccountUseCase;

  UserAccountCubit(
      {required this.getUserAccountUseCase,
      required this.editUserAccountUseCase})
      : super(UserAccountInitial());
  UserAccountDataEntity? userData;

  getUserDetials() {
    if (userData == null) {
      emit(UserAccountLoading());
    }
    final result = getUserAccountUseCase(NoParams());

    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getUserDetials();
        } else {
          emit(UserAccountError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        userData = r;
        return emit(
            UserAccountLoaded(userAccountDataEntity: r, isUpdated: false));
      });
    });
  }

  removeUserData() {
    userData = null;
  }

  eidtUserAccountData(EditUserAccountParams params) {
    final result = editUserAccountUseCase(params);
    emit(UserAccountLoading());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          eidtUserAccountData(params);
        } else {
          emit(UserAccountLoaded(
              userAccountDataEntity: userData!,
              isUpdated: false,
              errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        userData = null;
        emit(UserAccountLoaded(userAccountDataEntity: r, isUpdated: true));
      });
    });
  }
}

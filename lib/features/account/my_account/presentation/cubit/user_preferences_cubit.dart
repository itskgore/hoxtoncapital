import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/entities/user_preferences_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../../domain/usecase/edit_user_preference_usecase.dart';
import '../../domain/usecase/get_user_preference_usecase.dart';

part 'user_preferences_state.dart';

class UserPreferencesCubit extends Cubit<UserPreferencesState> {
  final GetUserPreferenceUseCase getUserPreferenceUseCase;
  final EditUserPreferencesUseCase editUserPreferencesUseCase;

  UserPreferencesCubit(
      {required this.getUserPreferenceUseCase,
      required this.editUserPreferencesUseCase})
      : super(UserPreferencesInitial());

  getUserPreferenceDetails() {
    final result = getUserPreferenceUseCase(NoParams());
    emit(UserPreferencesLoading());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getUserPreferenceDetails();
        } else {
          emit(UserPreferencesError(errorMsg: l.displayErrorMessage()));
        }
      },
          (r) => emit(UserPreferencesLoaded(
                userPreferencesEntity: r,
                isPreferencesUpdated: false,
              )));
    });
  }

  editUserPreferenceDetails(Map<String, dynamic> body) {
    final result = editUserPreferencesUseCase(body);
    emit(UserPreferencesLoading());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          editUserPreferenceDetails(body);
        } else {
          emit(UserPreferencesError(errorMsg: l.displayErrorMessage()));
        }
      },
          (r) => emit(UserPreferencesLoaded(
                userPreferencesEntity: r,
                isPreferencesUpdated: true,
              )));
    });
  }
}

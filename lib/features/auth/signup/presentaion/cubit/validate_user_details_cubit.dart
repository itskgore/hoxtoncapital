import 'package:bloc/bloc.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/auth/signup/presentaion/cubit/validate_user_detaills_state.dart';

import '../../domain/usecases/validate_user_details_usecase.dart';

class ValidateUserDetailsCubit extends Cubit<ValidateUserDetailsState> {
  ValidateUserDetailsCubit({required this.validateUserDetailsUseCase})
      : super(ValidateUserDetailsInitial());
  final ValidateUserDetailsUseCase validateUserDetailsUseCase;

  updateValidateUserDetailsDetails(dynamic body) {
    emit(ValidateUserDetailsLoading());
    final result = validateUserDetailsUseCase(body);
    result.then((value) => value.fold((l) {
          if (l is TokenExpired) {
            updateValidateUserDetailsDetails(body);
          } else {
            emit(ValidateUserDetailsError(l.displayErrorMessage()));
          }
        }, (r) {
          emit(ValidateUserDetailsLoaded(
            validateUserDetailsModel: r,
          ));
        }));
  }
}

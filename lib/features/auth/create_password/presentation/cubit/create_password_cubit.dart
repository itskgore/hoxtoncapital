import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/features/auth/create_password/domain/usecases/create_password_usecase.dart';

part 'create_password_state.dart';

class CreatePasswordCubit extends Cubit<CreatePasswordState> {
  CreatePasswordUsecase createPasswordUsecase;

  CreatePasswordCubit({required this.createPasswordUsecase})
      : super(CreatePasswordInitial());

  resetPassword(Map<String, dynamic> body) {
    emit(CreatePasswordLoading());
    final data = createPasswordUsecase(body);
    data.then((value) {
      value.fold((l) {
        emit(CreatePasswordError(l.displayErrorMessage()));
      }, (r) => emit(CreatePasswordLoaded(statusCode: r['status'])));
    });
  }
}

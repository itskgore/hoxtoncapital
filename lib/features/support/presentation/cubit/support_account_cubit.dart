import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/support/domain/usecases/add_support_account_usecase.dart';

part 'support_account_state.dart';

class SupportAccountCubit extends Cubit<SupportAccountState> {
  SupportAccountCubit({required this.accountUsecase})
      : super(SupportAccountInitial());
  final AddSupportAccountUsecase accountUsecase;

  void addSupport(Map<String, dynamic> body) {
    final result = accountUsecase(body);
    emit(SupportAccountLoading());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          addSupport(body);
        } else {
          emit(SupportAccountError(errorMsg: failure.displayErrorMessage()));
        }
      },
          (data) => {
                emit(SupportAccountLoaded(
                    status: true, message: "Feedback Recieved successfully"))
              });
    });
  }

  void reportUser() {}
}

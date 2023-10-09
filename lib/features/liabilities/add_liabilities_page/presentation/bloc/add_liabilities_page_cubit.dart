import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/domain/usecase/get_liabilities_usecase.dart';

part 'add_liabilities_page_state.dart';

class AddLiabilitiesPageCubit extends Cubit<AddLiabilitiesPageState> {
  final GetLiabilities getLiabilities;

  AddLiabilitiesPageCubit({required this.getLiabilities})
      : super(AddLiabilitiesPageInitial());

  getMainLiabilities() {
    final result = getLiabilities(NoParams());
    emit(AddLiabilitiesPageLoading());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          getMainLiabilities();
        } else {
          emit(
              AddLiabilitiesPageError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) {
        emit(AddLiabilitiesPageLoaded(liabilitiesEntity: data));
      });
    });
  }
}

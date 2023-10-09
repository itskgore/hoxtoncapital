import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/domain/usercase/add_manual_pension.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/domain/usercase/params/add_manual_pension_params.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/domain/usercase/update_manual_pension.dart';

part 'add_manual_pension_state.dart';

class AddManualPensionCubit extends Cubit<AddManualPensionState> {
  AddManualPensionCubit(
      {required this.addManualPensionUseCase,
      required this.updateManualPensionsUseCase})
      : super(AddManualPensionInitial(
            changeType: false,
            pensionType: "Defined Benefit",
            isLoading: false));
  final AddManualPensionUsecase addManualPensionUseCase;
  final UpdateManualPensionsUseCase updateManualPensionsUseCase;

  void changePensionType(String pensionType) {
    emit(AddManualPensionLoading());
    emit(AddManualPensionInitial(
        changeType: true,
        pensionType: pensionType.toString(),
        isLoading: false));
  }

  void savePensionData(Map<String, dynamic> bodyToSend) async {
    final result =
        addManualPensionUseCase(AddManualPensionParams.fromJson(bodyToSend));
    emit(AddManualPensionInitial(
        changeType: false,
        pensionType: bodyToSend['pensionType'],
        isLoading: true));
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          savePensionData(bodyToSend);
        } else {
          emit(AddManualPensionError(
            errorMsg: failure.displayErrorMessage(),
          ));
          emit(AddManualPensionInitial(
              changeType: false,
              pensionType: "Defined Benefit",
              isLoading: false));
        }
      },
          //if success
          (data) {
        emit(AddManualPensionLoaded(data: data));
        emit(AddManualPensionInitial(
            changeType: false,
            pensionType: "Defined Benefit",
            isLoading: false));
      });
    });
  }

  void updatePensionData(Map<String, dynamic> bodyToSend) async {
    final result = updateManualPensionsUseCase(
        AddManualPensionParams.fromJson(bodyToSend));
    emit(AddManualPensionInitial(
        changeType: false,
        pensionType: bodyToSend['pensionType'],
        isLoading: true));
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          updatePensionData(bodyToSend);
        } else {
          emit(AddManualPensionError(
            errorMsg: failure.displayErrorMessage(),
          ));
        }

        emit(AddManualPensionInitial(
            changeType: false,
            pensionType: bodyToSend["pensionType"],
            isLoading: false));
      }, (data) {
        emit(AddManualPensionLoaded(data: data));
        emit(AddManualPensionInitial(
            changeType: false,
            pensionType: bodyToSend["pensionType"],
            isLoading: false));
      });
    });
  }
}

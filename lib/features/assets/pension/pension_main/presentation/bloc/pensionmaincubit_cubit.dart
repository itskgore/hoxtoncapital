import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/pension/pension_main/domain/usecases/delete_pension_usecase.dart';
import 'package:wedge/features/assets/pension/pension_main/domain/usecases/get_pension_usecase.dart';

part 'pensionmaincubit_state.dart';

class PensionMaincubitCubit extends Cubit<PensionMainCubitState> {
  final GetPensionsUseCase getPensionsUseCase;
  final DeletePensionUsecase deletePensionUsecase;

  PensionMaincubitCubit(
      {required this.getPensionsUseCase, required this.deletePensionUsecase})
      : super(PensionMainCubitInitial());

  getPensionsData() {
    final result = getPensionsUseCase(NoParams());
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getPensionsData();
        } else {
          emit(PensionMainCubitError(errorMsg: failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        _assetsEntity = data;
        emit(PensionMainCubitLoaded(assets: data, hasDeleted: false));
      });
    });
  }

  late AssetsEntity _assetsEntity;

  void deletePension(String id) async {
    final result = deletePensionUsecase(DeleteParams(id: id));
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          deletePension(id);
        } else {
          emit(PensionMainCubitError(errorMsg: failure.displayErrorMessage()));
          emit(PensionMainCubitInitial());
        }
      }, (data) {
        emit(PensionMainCubitLoaded(assets: _assetsEntity, hasDeleted: true));
      });
    });
  }
}

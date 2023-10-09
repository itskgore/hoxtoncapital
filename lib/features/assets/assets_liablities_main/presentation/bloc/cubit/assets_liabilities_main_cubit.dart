import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/assets_liablities_main/domain/usecases/get_all_assets.dart';
import 'package:wedge/features/assets/assets_liablities_main/domain/usecases/get_all_liabilities.dart';

part 'assets_liabilities_main_state.dart';

class AssetsLiabilitiesMainCubit extends Cubit<AssetsLiabilitiesMainState> {
  GetAllAssetsMain getAssets;
  GetAllLiabilitiesMain getLiabilities;

  AssetsLiabilitiesMainCubit(
      {required this.getAssets, required this.getLiabilities})
      : super(AssetsLiabilitiesMainInitial());

  getData() {
    final result = getAssets(NoParams());
    emit(AssetsLiabilitiesMainLoading());
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(AssetsLiabilitiesMainError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        final liabResult = getLiabilities(NoParams());
        liabResult.then((liabValue) {
          liabValue.fold(
              //if failed
              (failure) {
            if (failure is TokenExpired) {
              getData();
            } else {
              emit(AssetsLiabilitiesMainError(failure.displayErrorMessage()));
            }
          },
              //if success
              (liabdata) {
            emit(AssetsLiabilitiesMainLoaded(
                liabilitiesData: liabdata, assetsData: data));
          });
        });
      });
    });
  }
}

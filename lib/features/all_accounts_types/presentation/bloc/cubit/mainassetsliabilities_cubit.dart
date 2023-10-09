import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../../../../assets/assets_liablities_main/data/Models/assets_liabilities_model.dart';
import '../../../../assets/assets_liablities_main/domain/usecases/get_all_assets_libilities.dart';

part 'mainassetsliabilities_state.dart';

class MainAssetsLiabilitiesCubit extends Cubit<MainAssetsLiabilitiesState> {
  GetAllAssetsLiabilitiesMain getAssetsLiabilities;

  MainAssetsLiabilitiesCubit({required this.getAssetsLiabilities})
      : super(MainAssetsLiabilitiesInitial());

  getData() {
    final assetsLiabilitiesResult = getAssetsLiabilities(NoParams());
    emit(MainAssetsLiabilitiesLoading());
    assetsLiabilitiesResult.then((value) => value.fold((failure) {
          if (failure is TokenExpired) {
            getData();
          } else {
            emit(MainAssetsLiabilitiesError(failure.displayErrorMessage()));
          }
        }, (assetsLiabilitiesData) {
          emit(MainAssetsLiabilitiesLoaded(
              assetsLiabilitiesData: assetsLiabilitiesData));
        }));
  }
}

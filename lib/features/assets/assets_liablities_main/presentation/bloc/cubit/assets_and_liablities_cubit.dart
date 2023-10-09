import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/features/assets/assets_liablities_main/presentation/bloc/cubit/assets_and_liabilities_state.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_all_assets_libilities.dart';

class AssetsAndLiabilitiesCubit extends Cubit<AssetsAndLiabilitiesState> {
  GetAllAssetsLiabilitiesMain getAssetsLiabilities;

  AssetsAndLiabilitiesCubit({required this.getAssetsLiabilities})
      : super(AssetsAndLiabilitiesInitial());

  getAssetsAndLiabilities({bool? coldUpdate}) {
    final assetsLiabilitiesResult = getAssetsLiabilities(NoParams());
    if (coldUpdate ?? false) {
    } else {
      emit(AssetsAndLiabilitiesLoading());
    }

    assetsLiabilitiesResult.then((value) => value.fold((failure) {
          if (failure is TokenExpired) {
            getAssetsAndLiabilities();
          } else {
            emit(AssetsAndLiabilitiesError(failure.displayErrorMessage()));
          }
        }, (assetsLiabilitiesData) {
          if ((coldUpdate ?? false) == true) {
            emit(AssetsAndLiabilitiesLoading());
          }
          emit(AssetsAndLiabilitiesLoaded(
              assetsLiabilitiesData: assetsLiabilitiesData));
        }));
  }
}

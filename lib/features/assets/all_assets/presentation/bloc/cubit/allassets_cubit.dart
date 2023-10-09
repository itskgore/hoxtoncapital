import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/all_assets/domain/usecases/get_all_assets.dart';

part 'allassets_state.dart';

class AllAssetsCubit extends Cubit<AllAssetsState> {
  final GetAllAssets getAllAssets;

  AllAssetsCubit({required this.getAllAssets}) : super(AllAssetsInitial());

  getData() {
    final result = getAllAssets(NoParams());
    emit(AllAssetsLoading());
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(AllAssetsError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        emit(AllAssetsLoaded(data: data));
      });
    });
  }
}

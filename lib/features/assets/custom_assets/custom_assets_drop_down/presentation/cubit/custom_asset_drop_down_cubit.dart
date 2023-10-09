import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_drop_down/domain/usecases/get_custom_assets_drop_down.dart';

part 'custom_asset_drop_down_state.dart';

class CustomAssetDropDownCubit extends Cubit<CustomAssetDropDownState> {
  final GetCustomAssetsDropDown getCustomAssetsDropDown;

  CustomAssetDropDownCubit({required this.getCustomAssetsDropDown})
      : super(CustomAssetDropDownInitial());

  getCustomAssetsDropDownData() {
    final result = getCustomAssetsDropDown(NoParams());
    result.then((value) {
      emit(CustomAssetDropDownLoading());
      value.fold((l) {
        if (l is TokenExpired) {
          getCustomAssetsDropDownData();
        } else {
          emit(CustomAssetDropDownError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) => emit(CustomAssetDropDownLoaded(data: r)));
    });
  }
}

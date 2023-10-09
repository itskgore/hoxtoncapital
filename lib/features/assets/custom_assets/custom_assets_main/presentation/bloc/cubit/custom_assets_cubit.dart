import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/domain/usecases/delete_custom_assets.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/domain/usecases/get_custom_assets.dart';

part 'custom_assets_state.dart';

class CustomAssetsCubit extends Cubit<CustomAssetsState> {
  final GetCustomAssets getCustomAssets;
  final DeleteCustomAssets deleteCustomAssets;

  CustomAssetsCubit(
      {required this.getCustomAssets, required this.deleteCustomAssets})
      : super(CustomAssetsInitial());

  late AssetsEntity _assetsEntity;
  getData() {
    final result = getCustomAssets(NoParams());
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(CustomAssetsError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        _assetsEntity = data;
        emit(CustomAssetsLoaded(assets: data, deleteMessageSent: false));
      });
    });
  }

  addToDataModel(OtherAssetsEntity data) {
    _assetsEntity.otherAssets.add(data);
    _assetsEntity.summary.otherAssets.amount += data.value.amount;
    emit(CustomAssetsLoaded(assets: _assetsEntity, deleteMessageSent: false));
  }

  updateModel(OtherAssetsEntity data) {
    int i = _assetsEntity.otherAssets.indexWhere((e) => e.id == data.id);
    //===================================
    _assetsEntity.summary.otherAssets.amount -=
        _assetsEntity.otherAssets[i].value.amount;

    _assetsEntity.summary.otherAssets.amount += data.value.amount;
//update total ===============================
    _assetsEntity.otherAssets[i] = data;
    emit(CustomAssetsLoaded(assets: _assetsEntity, deleteMessageSent: false));
  }

  deleteOtherAssets(id) {
    final result = deleteCustomAssets(DeleteParams(id: id));
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          deleteOtherAssets(id);
        } else {
          emit(CustomAssetsError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        int i = _assetsEntity.otherAssets.indexWhere((e) => e.id == data.id);
        _assetsEntity.otherAssets.removeAt(i);
        _assetsEntity.summary.otherAssets.amount -= data.value.amount;

        emit(
            CustomAssetsLoaded(assets: _assetsEntity, deleteMessageSent: true));
      });
    });
  }
}

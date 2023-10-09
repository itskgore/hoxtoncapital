import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/domain/usecases/add_custom_assets_usecase.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/domain/usecases/update_custom_assets_usecase.dart';

part 'add_custom_assets_state.dart';

class AddCustomAssetsCubit extends Cubit<AddCustomAssetsState> {
  final AddCustomAssets addCustomAssets;
  final UpdateCustomAssets updateCustomAssets;

  AddCustomAssetsCubit({
    required this.addCustomAssets,
    required this.updateCustomAssets,
  }) : super(AddCustomAssetsInitial(
            status: false,
            message: "",
            data: OtherAssetsEntity(
              country: "",
              name: "",
              type: "",
              value: ValueEntity(amount: 0, currency: ""),
              id: '',
              source: '',
            )));

  final _otherAsset = OtherAssetsEntity(
    country: "",
    name: "",
    type: '',
    value: ValueEntity(amount: 0, currency: ""),
    id: '',
    source: '',
  );

  addAsset(name, country, type, currentAmount, currency) {
    final _result = addCustomAssets(CustomAssetsParams(
        name: name,
        country: country,
        type: type,
        value: ValueEntity(
            amount: double.parse(currentAmount), currency: currency),
        id: ""));
    emit(AddCustomAssetsLoading());
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          addAsset(name, country, type, currentAmount, currency);
        } else {
          emit(AddCustomAssetsInitial(
              status: false,
              message: failure.displayErrorMessage(),
              data: _otherAsset));
        }
      },
          //if success
          (data) {
        emit(AddCustomAssetsInitial(status: true, message: "", data: data));
      });
    });
  }

  updateAsset(name, country, type, currentAmount, id, currency) {
    final _result = updateCustomAssets(CustomAssetsParams(
        name: name,
        country: country,
        type: type,
        value: ValueEntity(
            amount: double.parse(currentAmount), currency: currency),
        id: id));
    emit(AddCustomAssetsLoading());

    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          updateAsset(name, country, type, currentAmount, id, currency);
        } else {
          emit(
            AddCustomAssetsInitial(
                status: false,
                message: failure.displayErrorMessage(),
                data: _otherAsset),
          );
        }
      },
          //if success
          (data) {
        emit(AddCustomAssetsInitial(status: true, message: "", data: data));
      });
    });
  }
}

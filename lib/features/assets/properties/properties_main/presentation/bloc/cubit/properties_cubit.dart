import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/properties/properties_main/domain/usecases/delete_properties.dart';
import 'package:wedge/features/assets/properties/properties_main/domain/usecases/get_properties.dart';
import 'package:wedge/features/assets/properties/properties_main/domain/usecases/unlink_properties_usecase.dart';

part 'properties_state.dart';

class PropertiesCubit extends Cubit<PropertiesState> {
  final GetProperties getProperties;
  final DeleteProperties deleteProperties;
  final UnlinkProperties unlinkProperties;

  PropertiesCubit(
      {required this.getProperties,
      required this.deleteProperties,
      required this.unlinkProperties})
      : super(PropertiesInitial());

  late AssetsEntity
      _assetsEntity; // = AssetsEntity(Properties: [], otherAssets: [], summary: ,);
  getData() {
    final _result = getProperties(NoParams());
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(PropertiesError(errorMsg: failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        _assetsEntity = data;
        emit(PropertiesLoaded(assets: data, deleteMessageSent: false));
      });
    });
  }

  deleteProperty(id) {
    final _result = deleteProperties(DeleteParams(id: id));
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          deleteProperty(id);
        } else {
          emit(PropertiesError(errorMsg: failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        _assetsEntity.properties.removeWhere((element) => element.id == id);
        emit(PropertiesLoaded(assets: _assetsEntity, deleteMessageSent: true));
      });
    });
  }

  void unlinkProperty(UnlinkParams params) {
    final result = unlinkProperties(params);
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          unlinkProperty(params);
        } else {
          emit(PropertiesError(
              errorMsg: failure.displayErrorMessage(), id: params.vehicleId));
        }
      }, (data) {
        emit(PropertiesUnlink(id: params.vehicleId));
      });
    });
  }
}

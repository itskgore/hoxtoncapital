import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/domain/repositories/add_custom_assets_repository.dart';

class AddCustomAssets
    implements UseCase<OtherAssetsEntity, CustomAssetsParams> {
  final AddCustomAssetsRepository repository;

  AddCustomAssets(this.repository);

  @override
  Future<Either<Failure, OtherAssetsEntity>> call(
      CustomAssetsParams params) async {
    return await repository.addCustomAssets(
        params.name, params.country, params.type, params.value);
  }
}

class CustomAssetsParams extends Equatable {
  final String name;
  final String country;
  final String type;
  final ValueEntity value;
  final String id;

  const CustomAssetsParams(
      {required this.name,
      required this.country,
      required this.type,
      required this.value,
      required this.id});

  @override
  List<Object> get props => [name, country, id];
}

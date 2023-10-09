import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_drop_down/data/datasource/remote_custom_assets_drop_down.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_drop_down/domain/repository/custom_assets_repository.dart';

class CustomAssetDropDownRepoImp implements CustomAssetsDropDownRepo {
  final RemoteCustomAssetsDropDown remoteCustomAssetsDropDown;

  CustomAssetDropDownRepoImp({required this.remoteCustomAssetsDropDown});

  @override
  Future<Either<Failure, List>> getData() async {
    try {
      final result = await remoteCustomAssetsDropDown.getData();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

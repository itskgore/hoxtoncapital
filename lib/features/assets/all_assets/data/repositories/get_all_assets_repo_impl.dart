import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/all_assets/data/data_sources/local_get_all_assets_data_source.dart';
import 'package:wedge/features/assets/all_assets/domain/repositories/get_all_assets_repository.dart';

class GetAllAssetsRepositoryImpl implements GetAllAssetsRepository {
  final LocalAllAssetsDataSource localDataSource;

  GetAllAssetsRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AssetsEntity>> getAssets() async {
    try {
      final result = await localDataSource.getAssets();
      return Right(result);
    } on CacheFailure {
      return const Left(CacheFailure());
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/provider_records_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/data/data_sources/get_provider_records_datasource.dart.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/domain/repositories/get_providers_repository.dart';

class GetProvidersRepositoryImpl implements GetProvidersRepository {
  final GetProviderRecordsdataSource dataSource;

  GetProvidersRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, ProviderResponseModel>> getProviders(
      String name) async {
    try {
      final result = await dataSource.getproviders(name);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, ProviderResponseModel>> getTopInstitutes(
      String country) async {
    try {
      final result = await dataSource.getTopInstitutes(country);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

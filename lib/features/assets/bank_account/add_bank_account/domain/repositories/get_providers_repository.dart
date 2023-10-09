import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/provider_records_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class GetProvidersRepository {
  Future<Either<Failure, ProviderResponseModel>> getProviders(String name);

  Future<Either<Failure, ProviderResponseModel>> getTopInstitutes(
      String country);
}

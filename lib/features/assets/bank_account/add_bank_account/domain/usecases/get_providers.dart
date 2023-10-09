import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/provider_records_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/domain/repositories/get_providers_repository.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/domain/usecases/params.dart';

class GetProviders implements UseCase<ProviderResponseEntity, ProviderParams> {
  final GetProvidersRepository repository;

  GetProviders(this.repository);

  @override
  Future<Either<Failure, ProviderResponseEntity>> call(
      ProviderParams params) async {
    return await repository.getProviders(params.param);
  }
}

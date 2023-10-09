import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/domain/repositories/add_manualbank_repository.dart';

class AddManualBankAccount
    implements UseCase<ManualBankAccountsEntity, ManualBankAccountsParams> {
  final AddManualBankRepository repository;

  AddManualBankAccount(this.repository);

  @override
  Future<Either<Failure, ManualBankAccountsEntity>> call(
      ManualBankAccountsParams params) async {
    return await repository.addManualBank(
        params.name, params.country, params.currency, params.currentAmount);
  }
}

class ManualBankAccountsParams extends Equatable {
  final String name;
  final String country;
  final String currency;
  final ValueEntity currentAmount;
  final String id;

  const ManualBankAccountsParams(
      {required this.name,
      required this.country,
      required this.currency,
      required this.currentAmount,
      required this.id});

  @override
  List<Object> get props => [name, country, currency, currentAmount, id];
}

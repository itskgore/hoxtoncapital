import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/data/data_sources/add_manual_bank_data_source.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/domain/repositories/add_manualbank_repository.dart';

class AddManualBankRepositoryImpl implements AddManualBankRepository {
  final AddManualBankDataSource addManualBankDataSource;

  AddManualBankRepositoryImpl({required this.addManualBankDataSource});

  @override
  Future<Either<Failure, ManualBankAccountsEntity>> addManualBank(String name,
      String country, String currency, ValueEntity currentAmount) async {
    // TODO: implement addManualBank
    try {
      final verifiedUser = await addManualBankDataSource.addManualBankAccount(
          name, country, currency, currentAmount);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, ManualBankAccountsEntity>> updateManualBank(
      String name,
      String country,
      String currency,
      ValueEntity currentAmount,
      String id) async {
    try {
      final verifiedUser = await addManualBankDataSource
          .updateManualBankAccount(name, country, currency, currentAmount, id);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

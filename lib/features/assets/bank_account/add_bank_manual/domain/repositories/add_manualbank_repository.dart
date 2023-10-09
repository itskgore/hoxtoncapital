import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddManualBankRepository {
  Future<Either<Failure, ManualBankAccountsEntity>> addManualBank(
      String name, String country, String currency, ValueEntity currentAmount);

  Future<Either<Failure, ManualBankAccountsEntity>> updateManualBank(
      String name,
      String country,
      String currency,
      ValueEntity currentAmount,
      String id);
}

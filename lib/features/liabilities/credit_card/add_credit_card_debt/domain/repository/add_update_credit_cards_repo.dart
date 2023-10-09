import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/params/credit_cards_params.dart';

abstract class AddUpdateCreditCardsRepo {
  Future<Either<Failure, CreditCardsEntity>> addCreditCard(
      AddUpdateCreditCardsParams params);

  Future<Either<Failure, CreditCardsEntity>> udpateCreditCard(
      AddUpdateCreditCardsParams params);
}

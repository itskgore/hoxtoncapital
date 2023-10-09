import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/data/datasource/remote_add_update_credit_cards_.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/params/credit_cards_params.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/repository/add_update_credit_cards_repo.dart';

class AddUpdateCreditCardsRepoImp implements AddUpdateCreditCardsRepo {
  AddUpdateCreditCardsRepoImp({required this.remoteAddUpadteCreditCards});

  final RemoteAddUpadteCreditCards remoteAddUpadteCreditCards;

  @override
  Future<Either<Failure, CreditCardsEntity>> addCreditCard(
      AddUpdateCreditCardsParams params) async {
    try {
      final result = await remoteAddUpadteCreditCards.addCreditCard(params);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, CreditCardsEntity>> udpateCreditCard(
      AddUpdateCreditCardsParams params) async {
    try {
      final result = await remoteAddUpadteCreditCards.updateCreditCard(params);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

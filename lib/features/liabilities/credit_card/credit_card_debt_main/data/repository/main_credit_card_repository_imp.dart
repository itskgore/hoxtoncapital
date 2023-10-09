import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/data/datasource/local_credit_card_datasource.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/data/datasource/remote_credit_card_datasource.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/data/model/credit_card_transaction_model.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/domain/repository/credit_card_repository.dart';

import '../model/credit_card_pie_performance_model.dart';

class MainCreditCardRepoImp implements MainCreditCardRepo {
  MainCreditCardRepoImp(
      {required this.localCreditCardDatasource,
      required this.remoteCreditCardDatasource});

  final LocalCreditCardDatasource localCreditCardDatasource;
  final RemoteCreditCardDatasource remoteCreditCardDatasource;

  @override
  Future<Either<Failure, CreditCardsEntity>> deleteCreditCard(String id) async {
    try {
      final result = await remoteCreditCardDatasource.deleteCreditCards(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, LiabilitiesEntity>> getCreditCardsData() async {
    try {
      final result = await localCreditCardDatasource.getCreditCardData();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, CardAndCashTransactionModel>> getCreditCardTransaction(
      {required String source,
      required String date,
      required String page,
      required String aggregatorAccountId}) async {
    try {
      final result = await remoteCreditCardDatasource.getCreditCardTransactions(
          source, date, page, aggregatorAccountId);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<CreditCardPiePerformanceModel>>>
      getCreditCardPiePerformance(
          {required String month, required String aggregatorAccountId}) async {
    try {
      final result = await remoteCreditCardDatasource
          .getCreditCardPiePerformance(aggregatorAccountId, month);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

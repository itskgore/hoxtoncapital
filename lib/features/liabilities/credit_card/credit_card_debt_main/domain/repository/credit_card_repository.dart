import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/usecases/usecase.dart';
import '../../data/model/credit_card_pie_performance_model.dart';
import '../../data/model/credit_card_transaction_model.dart';

abstract class MainCreditCardRepo {
  Future<Either<Failure, LiabilitiesEntity>> getCreditCardsData();

  Future<Either<Failure, CreditCardsEntity>> deleteCreditCard(String id);

  Future<Either<Failure, List<CreditCardPiePerformanceModel>>>
      getCreditCardPiePerformance(
          {required String month, required String aggregatorAccountId});

  Future<Either<Failure, CardAndCashTransactionModel>> getCreditCardTransaction(
      {required String source,
      required String date,
      required String page,
      required String aggregatorAccountId});
}

class GetCreditCardPiePerformance
    extends UseCase<List<CreditCardPiePerformanceModel>, Map<String, dynamic>> {
  final MainCreditCardRepo mainCreditCardRepo;

  GetCreditCardPiePerformance(this.mainCreditCardRepo);

  @override
  Future<Either<Failure, List<CreditCardPiePerformanceModel>>> call(
      Map<String, dynamic> params) {
    return mainCreditCardRepo.getCreditCardPiePerformance(
      month: params['month'],
      aggregatorAccountId: params['aggregatorAccountId'],
    );
  }
}

class GetCreditCardTransaction
    extends UseCase<CardAndCashTransactionModel, Map<String, dynamic>> {
  final MainCreditCardRepo mainCreditCardRepo;

  GetCreditCardTransaction(this.mainCreditCardRepo);

  @override
  Future<Either<Failure, CardAndCashTransactionModel>> call(
      Map<String, dynamic> params) {
    return mainCreditCardRepo.getCreditCardTransaction(
        source: params['source'],
        date: params['date'],
        page: params['page'],
        aggregatorAccountId: params['aggregatorAccountId']);
  }
}

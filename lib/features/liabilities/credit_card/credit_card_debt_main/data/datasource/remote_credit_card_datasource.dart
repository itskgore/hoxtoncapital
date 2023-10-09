import 'dart:math';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/credit_cards_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../model/credit_card_pie_performance_model.dart';
import '../model/credit_card_transaction_model.dart';

abstract class RemoteCreditCardDatasource {
  Future<CreditCardsModel> deleteCreditCards(String id);

  Future<CardAndCashTransactionModel> getCreditCardTransactions(
      String source, String date, String page, String aggregatorAccountId);

  Future<List<CreditCardPiePerformanceModel>> getCreditCardPiePerformance(
      String month, String aggregatorAccountId);
}

class RemoteCreditCardDatasourceImp extends Repository
    implements RemoteCreditCardDatasource {
  RemoteCreditCardDatasourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<CreditCardsModel> deleteCreditCards(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '$financialInformationEndpoint/liabilities/creditCards/$id',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final creditCardsData = CreditCardsModel.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        if (creditCardsData.source.toString().toLowerCase() != 'manual') {
          await RootApplicationAccess().storeAssets();
        }
        return creditCardsData;
      } else {
        // print("failed");
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<CardAndCashTransactionModel> getCreditCardTransactions(String source,
      String date, String page, String aggregatorAccountId) async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.get(
            '$financialInformationEndpoint/transactions?source=$source&date=$date&page=$page&aggregatorAccountId=$aggregatorAccountId',
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        CardAndCashTransactionModel data =
            CardAndCashTransactionModel.fromJson(result.data);
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  Color getRandomColor() {
    Random random = Random();
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);
    return Color.fromARGB(255, r, g, b).withOpacity(.8);
  }

  @override
  Future<List<CreditCardPiePerformanceModel>> getCreditCardPiePerformance(
      String aggregatorAccountId, String month) async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.get(
          '$insightsEndpoint/reports/transactionsByCategory/fetchData?aggregatorAccountId=$aggregatorAccountId&month=$month');
      final status = await hanldeStatusCode(result);
      if (status.status) {
        List<CreditCardPiePerformanceModel> data = List.from(result.data)
            .map((e) => CreditCardPiePerformanceModel.fromJson(e))
            .toList();
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

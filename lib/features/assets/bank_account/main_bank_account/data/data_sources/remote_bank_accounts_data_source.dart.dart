import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/manual_bank_accounts_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../liabilities/credit_card/credit_card_debt_main/data/model/credit_card_transaction_model.dart';
import '../model/cash_account_pie_performance_model.dart';

abstract class RemoteBankAccountDataSource {
  Future<ManualBankAccountsModel> deleteBankAccount(String id);

  Future<CardAndCashTransactionModel> getCashAccountTransactions(
      String source, String date, String page, String aggregatorAccountId);

  Future<List<CashAccountPiePerformanceModel>> getCashAccountPiePerformance(
      String month, String aggregatorAccountId);

  Future<List<dynamic>> getCashAccountBarPerformance();
}

class RemoteBankAccountDataSourceImpl extends Repository
    implements RemoteBankAccountDataSource {
  final SharedPreferences sharedPreferences;

  RemoteBankAccountDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ManualBankAccountsModel> deleteBankAccount(String id) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.delete(
            '$financialInformationEndpoint/assets/bankAccounts/$id',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final bankModel = ManualBankAccountsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        if (bankModel.source.toString().toLowerCase() != 'manual') {
          await RootApplicationAccess().storeLiabilities();
        }

        return bankModel;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<CardAndCashTransactionModel> getCashAccountTransactions(String source,
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

  @override
  Future<List<CashAccountPiePerformanceModel>> getCashAccountPiePerformance(
      String aggregatorAccountId, String month) async {
    try {
      await isConnectedToInternet();

      final result = await Repository().dio.get(
          '$insightsEndpoint/reports/transactionsByCategory/fetchData?aggregatorAccountId=$aggregatorAccountId&month=$month');

      final status = await hanldeStatusCode(result);
      if (status.status) {
        List<CashAccountPiePerformanceModel> data = List.from(result.data)
            .map((e) => CashAccountPiePerformanceModel.fromJson(e))
            .toList();
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<List<dynamic>> getCashAccountBarPerformance() async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.get(
          '$insightsEndpoint/dashboards/insights-performance-mobile/cumulativeMonthlyCashFlow');
      final status = await hanldeStatusCode(result);
      if (status.status) {
        List<dynamic> data = List.from(result.data);
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

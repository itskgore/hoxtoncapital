import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/manual_bank_accounts_model.dart';
import 'package:wedge/core/data_models/manual_bank_transactions_model.dart';
import 'package:wedge/core/data_models/yodlee_bank_transaction_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteHomeBankAccountDataSource {
  Future<ManualBankAccountsModel> deleteBankAccount(String id);

  Future<List<YodleeBankTransactionModel>> getYodleeBankTransactions(
      Map<String, dynamic> body);

  Future<List<ManualBankTransactionModel>> getManualBankTransactions(
      Map<String, dynamic> body);

  Future<bool> updateManualBankBalanceSheet(Map<String, dynamic> body);

  Future<Map<String, dynamic>> refreshAggregatorAccount(
    Map<String, dynamic> body,
  );
}

class RemoteHomeBankAccountDataSourceImpl extends Repository
    implements RemoteHomeBankAccountDataSource {
  final SharedPreferences sharedPreferences;

  RemoteHomeBankAccountDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ManualBankAccountsModel> deleteBankAccount(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '/financialInformation/assets/bankAccounts/$id',
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
  Future<List<YodleeBankTransactionModel>> getYodleeBankTransactions(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.get(
          '${financialInformationEndpoint}/transactions?aggregatorAccountId=${body['aggregatorAccountId']}&date=${body['date']}&page=${body['page']}');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final List<YodleeBankTransactionModel> data = [];
        response.data['records'].forEach((e) {
          data.add(YodleeBankTransactionModel.fromJson(e));
        });
        response.data['cursor']['isEmpty'] = response.data['records'].isEmpty;
        YodleeBankTransactionModel.cursor = response.data['cursor'] ?? {};
        YodleeBankTransactionModel.summary = response.data['summary'] ?? {};
        //print(YodleeBankTransactionModel.summary);
        return data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<List<ManualBankTransactionModel>> getManualBankTransactions(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.get(
          '${financialInformationEndpoint}/bankHistory?page=${body['page']}&bankAccountId=${body['bankAccountId']}');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final List<ManualBankTransactionModel> data = [];
        response.data['records'].forEach((e) {
          data.add(ManualBankTransactionModel.fromJson(e));
        });
        return data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<bool> updateManualBankBalanceSheet(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.post(
          '$financialInformationEndpoint/bankHistory/${body['bankAccountId']}',
          data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        await RootApplicationAccess().storeAssets();
        return true;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> refreshAggregatorAccount(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.post(
          '$financialInformationEndpoint/reconnectAccount/${body['provider']}',
          data: {
            "connectionId": "${body['connectionId']}",
            "customerId": "${body['customerId']}",
            "returnTo": "${body['returnTo']}"
          });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return response.data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

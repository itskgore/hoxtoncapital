import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/credit_cards_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/params/credit_cards_params.dart';

abstract class RemoteAddUpadteCreditCards {
  Future<CreditCardsModel> addCreditCard(AddUpdateCreditCardsParams json);

  Future<CreditCardsModel> updateCreditCard(AddUpdateCreditCardsParams json);
}

class RemoteAddUpadteCreditCardsImp extends Repository
    implements RemoteAddUpadteCreditCards {
  RemoteAddUpadteCreditCardsImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<CreditCardsModel> addCreditCard(
      AddUpdateCreditCardsParams json) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.post(
          '$financialInformationEndpoint/liabilities/creditCards',
          data: json.toJson());
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final creditCardsModel = CreditCardsModel.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        return creditCardsModel;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<CreditCardsModel> updateCreditCard(
      AddUpdateCreditCardsParams json) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '$financialInformationEndpoint/liabilities/creditCards/${json.id!}',
          data: json.toJson());
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final assetModel = CreditCardsModel.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        return CreditCardsModel.fromJson(response.data);
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

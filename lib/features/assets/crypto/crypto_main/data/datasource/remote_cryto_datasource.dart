import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/cryptp_currency_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteCryptoDataSrouce {
  Future<CryptoCurrenciesModel> deleteCrypto(String id);
}

class RemoteCryptoDataSrouceImp extends Repository
    implements RemoteCryptoDataSrouce {
  RemoteCryptoDataSrouceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<CryptoCurrenciesModel> deleteCrypto(String id) async {
    try {
      await isConnectedToInternet();
      final response = await dio
          .delete("$financialInformationEndpoint/assets/cryptoCurrencies/$id");
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final cryptoModel = CryptoCurrenciesModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        return cryptoModel;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';

abstract class LocalAssetsLiabilitiesDataSource {
  Future saveAssetsLiabilities(AssetsModel loginModel);

  Future saveLiabilities(LiabilitiesModel loginModel);
}

class LocalAssetsLiabilitiesDataSourceImp
    implements LocalAssetsLiabilitiesDataSource {
  final SharedPreferences sharedPreferences;

  LocalAssetsLiabilitiesDataSourceImp({required this.sharedPreferences});

  @override
  Future saveAssetsLiabilities(AssetsModel assetsModel) async {
    await RootApplicationAccess().storeAssets();
  }

  @override
  Future saveLiabilities(LiabilitiesModel liabilitiesModel) async {
    await RootApplicationAccess().storeLiabilities();
  }
}

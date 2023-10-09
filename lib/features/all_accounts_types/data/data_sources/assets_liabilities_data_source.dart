import 'dart:developer';

import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AssetsLiabilitiesdataSource {
  Future<AssetsModel> getMainAssets();

  Future<LiabilitiesModel> getMainLiabilities();
}

class AssetsLiabilitiesDataSourceImpl extends Repository
    implements AssetsLiabilitiesdataSource {
  AssetsLiabilitiesDataSourceImpl();

  @override
  Future<AssetsModel> getMainAssets() async {
    try {
      await isConnectedToInternet();

      final response =
          await Repository().dio.get('$financialInformationEndpoint/assets');
      log('Assets API called in assets_liabilities_data_source.dart');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return AssetsModel.fromJson(response.data);
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  @override
  Future<LiabilitiesModel> getMainLiabilities() async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .get('$financialInformationEndpoint/liabilities');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return LiabilitiesModel.fromJson(response.data);
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/domain/use_cases/params/add_update_personal_loan.dart';

import '../../../../../../core/config/repository_config.dart';
import '../../../../../../core/data_models/personal_loan_model.dart';
import '../../../../../../core/error/failures.dart';

abstract class AddPersonalLoanDataSource {
  Future<PersonalLoanModel> addPersonalLoanAPI(AddPersonalLoanParams params);

  Future<PersonalLoanModel> upatePersonalLoanAPI(AddPersonalLoanParams params);
}

class AddPersonalLoanDataSourceImpl extends Repository
    implements AddPersonalLoanDataSource {
  AddPersonalLoanDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<PersonalLoanModel> addPersonalLoanAPI(
      AddPersonalLoanParams params) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.post(
          '${financialInformationEndpoint}/liabilities/personalLoans',
          data: params.toJson());
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final personalLoanModel = PersonalLoanModel.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        return personalLoanModel;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<PersonalLoanModel> upatePersonalLoanAPI(
      AddPersonalLoanParams params) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '${financialInformationEndpoint}/liabilities/personalLoans/' +
              params.id!,
          data: params.toJson());
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final personalLoans = sharedPreferences
            .getString(RootApplicationAccess.liabilitiesPreference);

        final liabilities =
            LiabilitiesModel.fromJson(json.decode(personalLoans!));
        final assetModel = PersonalLoanModel.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        return assetModel;
      } else {
        // print("failed");
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

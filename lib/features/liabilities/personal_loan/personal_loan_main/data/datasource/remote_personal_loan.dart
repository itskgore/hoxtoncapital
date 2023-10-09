import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/personal_loan_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteMainPersonalLoanDataSource {
  Future<PersonalLoanModel> deletePersonalLoan(String id);
}

class RemoteMainPersonalLoanDataSourceImp extends Repository
    implements RemoteMainPersonalLoanDataSource {
  RemoteMainPersonalLoanDataSourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<PersonalLoanModel> deletePersonalLoan(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '${financialInformationEndpoint}/liabilities/personalLoans/' + id,
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final personalLoanData = PersonalLoanModel.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        if (personalLoanData.source.toString().toLowerCase() != 'manual') {
          await RootApplicationAccess().storeAssets();
        }
        return personalLoanData;
      } else {
        // print("failed");
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

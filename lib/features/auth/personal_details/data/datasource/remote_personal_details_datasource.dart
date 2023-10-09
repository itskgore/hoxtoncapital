import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/repository_config.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/helpers/firebase_analytics.dart';
import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../dependency_injection.dart';

abstract class PersonalDetailsSource {
  Future<Map<String, dynamic>> updatePersonDetails(
    Map<String, dynamic> body,
  );
}

class PersonalDetailsSourceImp extends Repository
    implements PersonalDetailsSource {
  final SharedPreferences sharedPreferences;

  PersonalDetailsSourceImp({required this.sharedPreferences});

  @override
  Future<Map<String, dynamic>> updatePersonDetails(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .post('$identityEndpoint/auth/updateUserProfile', data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        AppAnalytics().trackEvent(
          eventName: "hoxton-profile-info-completed-mobile",
          parameters: {
            "email Id": locator<SharedPreferences>()
                    .getString(RootApplicationAccess.userEmailIDPreferences) ??
                locator<SharedPreferences>()
                    .getString(RootApplicationAccess.emailUserPreferences) ??
                '',
            'firstName': getUserNameFromAccessToken()
          },
        );
        return response.data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

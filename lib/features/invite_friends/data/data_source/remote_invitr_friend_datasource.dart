import '../../../../core/config/app_config.dart';
import '../../../../core/config/repository_config.dart';
import '../../../../core/error/failures.dart';
import '../model/invite_friends_model.dart';

abstract class InviteFriendsDataSource {
  Future<InviteFriendsModel> getInviteFriends();
}

class InviterFriendsDataSourceImp extends InviteFriendsDataSource {
  @override
  Future<InviteFriendsModel> getInviteFriends() async {
    try {
      await Repository().isConnectedToInternet();
      String url = "$userServicesEndPoint/plugins/userReferral/view/execute";
      final result = await Repository().dio.post(url, data: {});
      final status = await hanldeStatusCode(result);
      if (status.status) {
        return InviteFriendsModel.fromJson(result.data);
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

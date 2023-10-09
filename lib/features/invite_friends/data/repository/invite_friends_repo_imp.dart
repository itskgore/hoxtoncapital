import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repository/invite_friends_repo.dart';
import '../data_source/remote_invitr_friend_datasource.dart';
import '../model/invite_friends_model.dart';

class InviteFriendsDataRepoImp extends InviteFriendsDataRepo {
  final InviteFriendsDataSource inviteFriendsDataSource;

  InviteFriendsDataRepoImp({required this.inviteFriendsDataSource});

  @override
  Future<Either<Failure, InviteFriendsModel>> getInviteFriendsData() async {
    try {
      final result = await inviteFriendsDataSource.getInviteFriends();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

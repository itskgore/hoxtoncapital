import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../data/model/invite_friends_model.dart';

abstract class InviteFriendsDataRepo {
  Future<Either<Failure, InviteFriendsModel>> getInviteFriendsData();
}

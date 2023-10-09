import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/model/invite_friends_model.dart';
import '../repository/invite_friends_repo.dart';

class GetInviteFriendsData extends UseCase<InviteFriendsModel, NoParams> {
  final InviteFriendsDataRepo inviteFriendsDataRepo;

  GetInviteFriendsData(this.inviteFriendsDataRepo);

  @override
  Future<Either<Failure, InviteFriendsModel>> call(NoParams params) {
    return inviteFriendsDataRepo.getInviteFriendsData();
  }
}

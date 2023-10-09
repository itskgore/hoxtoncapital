import '../../data/model/invite_friends_model.dart';

abstract class InviteFriendsState {}

class InviteFriendsInitialState extends InviteFriendsState {}

class InviteFriendsLoadingState extends InviteFriendsState {}

class InviteFriendsLoadedState extends InviteFriendsState {
  final InviteFriendsModel inviteFriends;

  InviteFriendsLoadedState({required this.inviteFriends});
}

class InviteFriendsErrorState extends InviteFriendsState {
  final String error;

  InviteFriendsErrorState({required this.error});
}

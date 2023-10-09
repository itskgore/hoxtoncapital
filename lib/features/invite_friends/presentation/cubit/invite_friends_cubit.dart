import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecase/get_invite_friends_usecase.dart';
import 'invite_friends_state.dart';

class InviteFriendsCubit extends Cubit<InviteFriendsState> {
  GetInviteFriendsData getInviteFriendsDataUseCase;

  InviteFriendsCubit({required this.getInviteFriendsDataUseCase})
      : super(InviteFriendsInitialState());

  getInviteFriendsData() {
    emit(InviteFriendsLoadingState());
    final result = getInviteFriendsDataUseCase(NoParams());
    result.then((value) => value.fold((error) {
          if (error is TokenExpired) {
            getInviteFriendsData();
          } else {
            emit(InviteFriendsErrorState(error: error.displayErrorMessage()));
          }
        }, (r) {
          emit(InviteFriendsLoadingState());
          emit(InviteFriendsLoadedState(inviteFriends: r));
        }));
  }
}

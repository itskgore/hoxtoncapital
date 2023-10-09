import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/entities/hoxton_summery_entity.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/usecases/get_hoxtondata_summery.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/usecases/get_user_details.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_email_entity.dart';

part 'userdatasummery_state.dart';

class UserDataSummeryCubit extends Cubit<UserDataSummeryState> {
  final GetHoxtonUserDataSummery getHoxtonUserDataSummery;
  final GetUserDetails getUserDetails;

  UserDataSummeryCubit(
      {required this.getHoxtonUserDataSummery, required this.getUserDetails})
      : super(UserDataSummeryInitial());

  late LoginEmailEntity _userInfo;

  getHoxtonDataSummery() {
    final result = getHoxtonUserDataSummery(NoParams());
    final userDetails = getUserDetails(NoParams());

    userDetails.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getHoxtonDataSummery();
        } else {
          emit(UserDataSummeryError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        _userInfo = data;
      });
    });

    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getHoxtonDataSummery();
        } else {
          emit(UserDataSummeryError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        emit(
            UserDataSummeryLoaded(data: data, clientName: _userInfo.firstName));
      });
    });
  }
}

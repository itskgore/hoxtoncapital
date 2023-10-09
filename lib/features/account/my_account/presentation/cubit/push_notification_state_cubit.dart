import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'push_notification_state_state.dart';

class PushNotificationStateCubit extends Cubit<PushNotificationStateState> {
  PushNotificationStateCubit() : super(PushNotificationStateSelected());

  changeState(bool val) {
    if (val) {
      emit(PushNotificationStateSelected());
    } else {
      emit(PushNotificationStateUnSelected());
    }
  }
}

part of 'push_notification_state_cubit.dart';

@immutable
abstract class PushNotificationStateState {}

class PushNotificationStateInitial extends PushNotificationStateState {}

class PushNotificationStateSelected extends PushNotificationStateState {}

class PushNotificationStateUnSelected extends PushNotificationStateState {}

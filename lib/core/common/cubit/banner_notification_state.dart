import 'package:wedge/core/data_models/notification_model.dart';
import 'package:wedge/features/home/data/model/banner_model.dart';

abstract class BannerNotificationState {}

class BannerNotificationInitial extends BannerNotificationState {}

class BannerNotificationInitialLoading extends BannerNotificationState {}

class BannerNotificationLoading extends BannerNotificationState {
  final bool isNotificationLoading;

  BannerNotificationLoading({required this.isNotificationLoading});
}

class BannerNotificationLoaded extends BannerNotificationState {
  List<NotificationModel>? notificationModel;
  List<BannerModel>? bannerModel;
  BannerNotificationLoaded({this.bannerModel, this.notificationModel});
}

class BannerNotificationError extends BannerNotificationState {
  final String errorMsg;
  BannerNotificationError(this.errorMsg);
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/common/cubit/banner_notification_cubit.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/contants/enums.dart';
import '../../../../core/contants/theme_contants.dart';
import '../../../../core/data_models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    Key? key,
    required this.notificationModel,
  }) : super(key: key);

  final NotificationModel notificationModel;

  getReconnectionText() {
    String? source = notificationModel.extras?.source?.toLowerCase();
    // Saltedge
    if (source == AggregatorProvider.Saltedge.name.toLowerCase()) {
      return '${translate!.reconnect} ${translate!.account}';
    }
    // Yodlee
    else if (source == AggregatorProvider.Yodlee.name.toLowerCase()) {
      return '${translate!.revive} ${translate!.account}';
    }
  }

  getExpiryStatus() {
    String? source = notificationModel.extras?.source?.toLowerCase();
    String? status = notificationModel.extras?.status?.toLowerCase();

    // Saltedge
    if (source == AggregatorProvider.Saltedge.name.toLowerCase()) {
      if (status == 'expiring') {
        return translate!.expiring;
      } else {
        return translate!.expired;
      }
    }
    // Yodlee
    else if (source == AggregatorProvider.Yodlee.name.toLowerCase()) {
      return translate!.lost;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5.0, spreadRadius: 1.0),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // Put request
          context.read<BannerNotificationCubit>().updateNotificationBanner(
              isNotificationLoading: true,
              params: [
                {"id": notificationModel.id!}
              ],
              notificationModel: notificationModel,
              isInitial: false,
              isIndividual: true);
        },
        child: ListTile(
          tileColor: Colors.white,
          title: Text(
            '${translate!.connection} ${getExpiryStatus()}: ${notificationModel.extras?.providerName}',
            style: SubtitleHelper.h10.copyWith(fontWeight: FontWeight.w400),
          ),
          subtitle: Text(
            '${getReconnectionText()} >>',
            style: SubtitleHelper.h10.copyWith(
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              color: appThemeColors!.primary,
            ),
          ),
          leading: SizedBox(
            width: 50.0,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/reconnect_icon.svg',
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

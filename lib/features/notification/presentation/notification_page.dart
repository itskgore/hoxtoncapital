import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/common/cubit/banner_notification_cubit.dart';
import 'package:wedge/core/common/cubit/banner_notification_state.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/notification_model.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/widgets/wedge_app_bar.dart';
import 'package:wedge/features/notification/presentation/widget/notification_card.dart';

import '../../../core/utils/wedge_func_methods.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Function to clear all the notifications
  clearList(List<NotificationModel> notificationModelList) async {
    List<Map<String, dynamic>> ids = [];
    for (var element in notificationModelList) {
      ids.add({"id": element.id!});
    }
    context.read<BannerNotificationCubit>().updateNotificationBanner(
        isNotificationLoading: true,
        isInitial: false,
        params: ids,
        isIndividual: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BlocBuilder<BannerNotificationCubit, BannerNotificationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: appThemeColors!.bg,
            appBar: WedgeAppBar(
              heading: translate!.notifications,
              actions: [
                TextButton(
                  onPressed: () {
                    if (state is BannerNotificationLoaded) {
                      clearList(state.notificationModel ?? []);
                    }
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.only(right: 20))),
                  child: Text(
                    translate!.clearAll,
                    style: SubtitleHelper.h11.copyWith(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF538EF7),
                    ),
                  ),
                )
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<BannerNotificationCubit>().getBannerNotification(
                    isNotificationLoading: true, isInitial: false);
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${translate!.reconnect} ${translate!.accounts}',
                      style: TitleHelper.h9
                          .copyWith(color: appThemeColors!.primary),
                    ),
                    const SizedBox(height: 20),
                    (state is BannerNotificationLoaded)
                        ? (state.notificationModel?.isNotEmpty ?? false)
                            ? Expanded(
                                child: Material(
                                  color: appThemeColors!.bg,
                                  child: ListView(
                                    children: List.generate(
                                      state.notificationModel?.length ?? 0,
                                      (index) => NotificationCard(
                                          notificationModel:
                                              state.notificationModel![index]),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Center(
                                  child: Text(
                                    translate?.noDataAvailable ?? '',
                                    style: TitleHelper.h11,
                                  ),
                                ),
                              )
                        : (state is BannerNotificationLoading &&
                                    state.isNotificationLoading ||
                                state is BannerNotificationInitialLoading)
                            ? Expanded(
                                child: Center(
                                  child: buildCircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

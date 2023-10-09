import 'package:flutter/cupertino.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/dependency_injection.dart';

import '../../utils/reconnect_aggregator.dart';

///Function to show popup.
showPopupBox(
    {required BuildContext context,
    required String message,
    required bool mounted,
    GlobalKey? showcaseKey,
    dynamic data}) {
  locator.get<WedgeDialog>().confirm(
      navigatorKey.currentContext!,
      WedgeConfirmDialog(
          title: 'Reconnect Account',
          subtitle: message,
          acceptedPress: () {
            ReconnectAggregator.aggregatorReconnect(
                mounted: mounted, dataEntity: data);
            Navigator.pop(navigatorKey.currentContext!);
          },
          primaryButtonColor: const Color(0xffEA943E),
          deniedPress: () {
            if (showcaseKey != null) {
              ShowCaseWidget.of(context).startShowCase([showcaseKey]);
            }
            Navigator.pop(navigatorKey.currentContext!);
          },
          acceptText: 'Reconnect',
          showReconnectIcon: true,
          deniedText: 'Later'));
  // setState(() {});
}

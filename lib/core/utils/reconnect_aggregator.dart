import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';

import '../../../features/aggregator_reconnect/presentation/cubit/aggregator_reconnect_cubit.dart';
import '../../../features/aggregator_reconnect/presentation/pages/aggregator_reconnect_webview.dart';
import '../contants/enums.dart';
import '../data_models/provider_token_model.dart';

/// Aggregator Reconnection Function

class ReconnectAggregator {
  ///Function get URl for reconnecting the account
  static String getReconnectUrl(Map<String, dynamic> data, dynamic dataEntity) {
    late String reconnectUrl;
    bool isSaltedge = data['provider'].toString().toLowerCase() ==
        AggregatorProvider.Saltedge.name.toLowerCase();
    bool isYodlee = data['provider'].toString().toLowerCase() ==
        AggregatorProvider.Yodlee.name.toLowerCase();

    if (isSaltedge) {
      reconnectUrl = data['response']['saltedge']['data']['redirect_url'];
    } else if (isYodlee) {
      ProviderTokenModel providerTokenModel =
          ProviderTokenModel.fromJson(data['response']);
      String token = providerTokenModel.yodlee!.token.accessToken;
      String fastLinkURL = providerTokenModel.yodlee!.fastlinkURL;
      String configName = providerTokenModel.yodlee!.fastlinkConfiguration;
      String providerAccountId =
          dataEntity.aggregatorProviderAccountId.toString();
      String htmlString = '''<html>
        <body>
            <form name="fastlink-form" action="$fastLinkURL" method="POST">
                <input name="accessToken" value="Bearer $token" hidden="true" />
                <input name="extraParams" value="configName=$configName&flow=refresh&providerAccountId=$providerAccountId" hidden="true" />
            </form>
            <script type="text/javascript">
                window.onload = function () {
                    document.forms["fastlink-form"].submit();
                }
            </script>
        </body>
        </html>''';

      reconnectUrl = Uri.dataFromString(htmlString,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString();
    }
    return reconnectUrl;
  }

  static void aggregatorReconnect(
      {required dynamic dataEntity,
      required bool mounted,
      Function(bool)? onComplete}) async {
    final data = await navigatorKey.currentContext!
        .read<AggregatorReconnectCubit>()
        .refreshAggregator(dataEntity);
    if (data != null) {
      if (data['status']) {
        if (mounted) {
          Navigator.push(
            navigatorKey.currentContext!,
            CupertinoPageRoute(
              builder: (BuildContext context) => AggregatorReconnect(
                reconnectUrl: getReconnectUrl(data, dataEntity),
                status: (val) async {
                  if (val) {
                    showSnackBar(
                        context: context, title: "Refreshing the account...");
                    await RootApplicationAccess().storeAssets();
                    await RootApplicationAccess().storeLiabilities();
                  }
                  if (mounted) {
                    Navigator.pop(context);
                  }
                  if (onComplete != null) {
                    onComplete(val);
                  }
                },
              ),
            ),
          );
        }
      } else {
        showSnackBar(
            context: navigatorKey.currentContext!, title: "${data['msg']}!");
      }
    }
  }
}

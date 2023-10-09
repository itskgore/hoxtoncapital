import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/features/aggregator_reconnect/presentation/cubit/aggregator_reconnect_cubit.dart';

import '../../../../core/utils/reconnect_aggregator.dart';

class ReconnectIcon extends StatefulWidget {
  final dynamic data;
  final bool isButton;
  Widget? dependentedIcon;
  final Function(bool) onComplete;

  ReconnectIcon(
      {Key? key,
      required this.data,
      this.dependentedIcon,
      required this.onComplete,
      required this.isButton})
      : super(key: key);

  @override
  _ReconnectIconState createState() => _ReconnectIconState();
}

class _ReconnectIconState extends State<ReconnectIcon> {
  bool isLoaded = false;

  // Function for getting reconnectUrl for given provider (Saltedge / Yodlee)
  // String getReconnectUrl(Map<String, dynamic> data) {
  //   late String reconnectUrl;
  //   bool isSaltedge = data['provider'].toString().toLowerCase() ==
  //       AggregatorProvider.Saltedge.name.toLowerCase();
  //   bool isYodlee = data['provider'].toString().toLowerCase() ==
  //       AggregatorProvider.Yodlee.name.toLowerCase();
  //
  //   if (isSaltedge) {
  //     reconnectUrl = data['response']['saltedge']['data']['redirect_url'];
  //   } else if (isYodlee) {
  //     ProviderTokenModel providerTokenModel =
  //         ProviderTokenModel.fromJson(data['response']);
  //     String token = providerTokenModel.yodlee!.token.accessToken;
  //     String fastLinkURL = providerTokenModel.yodlee!.fastlinkURL;
  //     String configName = providerTokenModel.yodlee!.fastlinkConfiguration;
  //     String providerAccountId =
  //         widget.data.aggregatorProviderAccountId.toString();
  //     String htmlString = '''<html>
  //       <body>
  //           <form name="fastlink-form" action="$fastLinkURL" method="POST">
  //               <input name="accessToken" value="Bearer $token" hidden="true" />
  //               <input name="extraParams" value="configName=$configName&flow=refresh&providerAccountId=$providerAccountId" hidden="true" />
  //           </form>
  //           <script type="text/javascript">
  //               window.onload = function () {
  //                   document.forms["fastlink-form"].submit();
  //               }
  //           </script>
  //       </body>
  //       </html>''';
  //
  //     reconnectUrl = Uri.dataFromString(htmlString,
  //             mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //         .toString();
  //   }
  //   return reconnectUrl;
  // }

  // Aggregator Reconnection Function
  // _aggregatorReconnect() async {
  //   final data = await context
  //       .read<AggregatorReconnectCubit>()
  //       .refreshAggregator(widget.data);
  //   if (data != null) {
  //     if (data['status']) {
  //       if (mounted) {
  //         Navigator.push(
  //           context,
  //           CupertinoPageRoute(
  //             builder: (BuildContext context) => AggregatorReconnect(
  //               reconnectUrl: getReconnectUrl(data),
  //               status: (val) async {
  //                 if (val) {
  //                   showSnackBar(
  //                       context: context, title: "Refreshing the account...");
  //                   await RootApplicationAccess().storeAssets();
  //                   await RootApplicationAccess().storeLiabilities();
  //                 }
  //                 if (mounted) {
  //                   Navigator.pop(context);
  //                 }
  //                 widget.onComplete(val);
  //               },
  //             ),
  //           ),
  //         );
  //       }
  //     } else {
  //       showSnackBar(context: context, title: "${data['msg']}!");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AggregatorReconnectCubit, AggregatorReconnectState>(
      builder: (context, state) {
        return state is AggregatorReconnectLoading
            ? const SizedBox()
            : GestureDetector(
                onTap: () async {
                  ReconnectAggregator.aggregatorReconnect(
                      dataEntity: widget.data,
                      mounted: mounted,
                      onComplete: widget.onComplete);
                },
                child: widget.isButton
                    ? Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10.0,
                                  spreadRadius: 1.0),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(kborderRadius)),
                        child: const Center(
                          child: Icon(
                            Icons.refresh,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : widget.dependentedIcon ??
                        Chip(
                            backgroundColor: Colors.red[600],
                            label: Text(
                              translate!.reconnect,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100),
                            )));
      },
    );
  }
}

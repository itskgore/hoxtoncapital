import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/core/widgets/buttons/footer_single_button.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';
import 'package:wedge/features/all_accounts_types/presentation/pages/all_account_types.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/presentation/pages/add_custom_assets_page.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/presentation/bloc/cubit/custom_assets_cubit.dart';

import '../../../../../../core/common/functions/common_functions.dart';
import '../../../../../../core/contants/enums.dart';
import '../../../../../../core/utils/reconnect_aggregator.dart';
import '../../../../../../core/widgets/dialog/reconnect_dialog.dart';
import '../../../../../../core/widgets/reconnect_button.dart';
import '../../../../../../dependency_injection.dart';

class CustomAssetsMainPage extends StatefulWidget {
  final String? id;

  const CustomAssetsMainPage({Key? key, this.id}) : super(key: key);

  @override
  _CustomAssetsMainPageState createState() => _CustomAssetsMainPageState();
}

class _CustomAssetsMainPageState extends State<CustomAssetsMainPage> {
  final GlobalKey scrollToKey = GlobalKey();

  addCustomAssets(List<OtherAssetsEntity> otherAssets) async {
    var data;
    if (otherAssets.isEmpty) {
      data = await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddCustomAssetsPage()));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddCustomAssetsPage()));
    }
    if (data != null) {
      context.read<CustomAssetsCubit>().getData();
    }
  }

  ///Function get URl for reconnecting the account
  // String getReconnectUrl(Map<String, dynamic> data, dynamic dataEntity) {
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
  //         dataEntity.aggregatorProviderAccountId.toString();
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

  /// Aggregator Reconnection Function
  // _aggregatorReconnect(dynamic dataEntity) async {
  //   final data = await context
  //       .read<AggregatorReconnectCubit>()
  //       .refreshAggregator(dataEntity);
  //   if (data != null) {
  //     if (data['status']) {
  //       if (mounted) {
  //         Navigator.push(
  //           context,
  //           CupertinoPageRoute(
  //             builder: (BuildContext context) => AggregatorReconnect(
  //               reconnectUrl: getReconnectUrl(data, dataEntity),
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

  // ///Function to show popup.
  // showPopupBox(context, String message, dynamic data) {
  //   locator.get<WedgeDialog>().confirm(
  //       context,
  //       WedgeConfirmDialog(
  //           title: 'Reconnect Account',
  //           subtitle: message,
  //           acceptedPress: () {
  //             _aggregatorReconnect(data);
  //             Navigator.pop(context);
  //           },
  //           primaryButtonColor: Color(0xffEA943E),
  //           deniedPress: () {
  //             Navigator.pop(context);
  //           },
  //           acceptText: 'Reconnect',
  //           showReconnectIcon: true,
  //           deniedText: 'Later'));
  //   setState(() {});
  // }

  @override
  void initState() {
    try {
      Timer(Duration(milliseconds: 500), () {
        if (widget.id != null) {
          Scrollable.ensureVisible(scrollToKey.currentContext!);
        }
      });
    } catch (e) {
      log(e.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);

    return BlocConsumer<CustomAssetsCubit, CustomAssetsState>(
      bloc: context.read<CustomAssetsCubit>().getData(),
      listener: (context, state) {
        if (state is CustomAssetsError) {
          setState(() {
            isDeleting = false;
          });
          showSnackBar(context: context, title: state.errorMsg);
        }
        if (state is CustomAssetsLoaded) {
          if (state.deleteMessageSent) {
            showSnackBar(context: context, title: translate!.assetDeleted);

            setState(() {
              isDeleting = false;
            });
          }
        }
      },
      builder: (context, state) {
        if (state is CustomAssetsLoaded) {
          return WillPopScope(
            onWillPop: () async {
              // refreshMainState(context: context, isAsset: true);
              return true;
            },
            child: Scaffold(
              backgroundColor: appThemeColors!.bg,
              appBar: wedgeAppBar(
                  context: context,
                  title: translate!.customAssets,
                  leadingIcon: getLeadingIcon(context, true),
                  actions: IconButton(
                      onPressed: () async {
                        addCustomAssets(state.assets.otherAssets);
                      },
                      icon: const Icon(Icons.add))),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardValueContainer(
                          mainValue:
                              "${state.assets.summary.otherAssets.currency} ${state.assets.summary.otherAssets.amount}",
                          mainTitle: translate.totalCustomAssetsValue,
                          leftValue: "${state.assets.otherAssets.length}",
                          leftImage:
                              "assets/icons/customassetsMainContainer.png",
                          leftTitle: state.assets.otherAssets.length == 1
                              ? translate.customAssets.substring(0, 12)
                              : translate.customAssets,
                          rightTitle: translate.countries,
                          rightvalue:
                              "${state.assets.summary.otherAssets.countryCount}"),
                      Column(
                        children: List.generate(
                            state.assets.otherAssets.length,
                            (index) => _exptiles(
                                state.assets.otherAssets[index], index)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AddNewButton(
                          text: translate.addNewCustomAsset,
                          onTap: () async {
                            addCustomAssets(state.assets.otherAssets);
                          })
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: FooterButton(
                text: translate.addOtherAssets,
                onTap: () {
                  // refreshMainState(context: context, isAsset: true);
                  Navigator.pop(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const AllAccountTypes()));
                },
              ),
            ),
          );
        } else {
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(),
            ),
            bottomNavigationBar: FooterButton(
              text: translate!.addOtherAssets,
              onTap: () {
                // refreshMainState(context: context, isAsset: true);
                Navigator.pop(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            const AllAccountTypes()));
              },
            ),
          );
        }
      },
    );
  }

  bool isDeleting = false;

  Widget _exptiles(OtherAssetsEntity data, int index) {
    bool isManual =
        data.source.toLowerCase() == "manual" || data.source.isEmpty;
    bool disconnected = isAggregatorExpired(data: data);
    String? popupMessage = aggregatorPopupMessage(data: data);
    bool visible = widget.id == data.id;
    return WedgeExpansionTile(
      key: visible ? scrollToKey : null,
      initiallyExpanded: visible,
      margin: const EdgeInsets.only(bottom: 0, top: 18),
      padding: const EdgeInsets.symmetric(vertical: 6),
      source: data.source,
      linked: !isManual && !disconnected,
      isUnlink: !isManual,
      index: index,
      rightButton: isManual
          ? null
          : ReconnectButton(
              showWarning: popupMessage != null,
              onPressed: () {
                if (popupMessage != null) {
                  showPopupBox(
                      context: context,
                      message: popupMessage,
                      data: data,
                      mounted: mounted);
                  setState(() {});
                } else {
                  ReconnectAggregator.aggregatorReconnect(
                      dataEntity: data, mounted: mounted);
                  // _aggregatorReconnect(data);
                }
              },
            ),
      leftSubtitle: data.country,
      leftTitle: data.name,
      midWidget: null,
      onDeletePressed: isDeleting
          ? null
          : () {
              locator.get<WedgeDialog>().confirm(
                  context,
                  WedgeConfirmDialog(
                    title: translate!.areYouSure,
                    subtitle: isManual
                        ? translate!.remeberMoreAccurateMessage
                        : data.source.toLowerCase() ==
                                AggregatorProvider.Saltedge.name.toLowerCase()
                            ? translate!.saltEdgeDeleteConfirmation
                            : translate!.yodleeDeleteConfirmation,
                    acceptedPress: () {
                      setState(() {
                        isDeleting = true;
                      });
                      showSnackBar(
                          context: context,
                          title: translate!.loading,
                          duration: const Duration(minutes: 3));

                      context
                          .read<CustomAssetsCubit>()
                          .deleteOtherAssets(data.id);
                      Navigator.pop(context);
                    },
                    deniedPress: () {
                      Navigator.pop(context);
                    },
                    acceptText: translate!.yesDelete,
                    deniedText: translate!.noiWillKeepIt,
                  ));
            },
      onEditPressed: isDeleting
          ? null
          : () async {
              var result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddCustomAssetsPage(
                            assetData: data,
                          )));
              if (result != null) {
                context.read<CustomAssetsCubit>().getData();
              }
            },
      rightTitle: '${data.value.currency} ${data.value.amount}',
    );
  }
}

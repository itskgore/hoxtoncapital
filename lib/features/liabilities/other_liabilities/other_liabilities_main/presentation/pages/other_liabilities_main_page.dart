import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/liabilities_total_summary_entity.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/core/widgets/buttons/footer_single_button.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/aggregator_reconnect/presentation/pages/aggregator_reconnect_icon.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/presentation/pages/add_other_liabilities_page.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/presentation/cubit/main_other_liabilities_cubit.dart';

import '../../../../../../core/contants/enums.dart';
import '../../../../../../core/utils/reconnect_aggregator.dart';
import '../../../../../../core/widgets/dialog/reconnect_dialog.dart';
import '../../../../../../core/widgets/reconnect_button.dart';

class OtherLiabilitiesMainPage extends StatefulWidget {
  final String? id;

  OtherLiabilitiesMainPage({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  _OtherLiabilitiesMainPageState createState() =>
      _OtherLiabilitiesMainPageState();
}

class _OtherLiabilitiesMainPageState extends State<OtherLiabilitiesMainPage> {
  final GlobalKey scrollToKey = GlobalKey();

  addOtherLiabilities(List<OtherLiabilitiesEntity> otherLiabilities) async {
    var data;
    if (otherLiabilities.isEmpty) {
      data = await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddOtherLiabilitiesPage()));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddOtherLiabilitiesPage()));
    }
    if (data != null) {
      context.read<MainOtherLiabilitiesCubit>().getOtherLiabilitiesData();
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

  ///Function to show popup.
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
  //           primaryButtonColor: const Color(0xffEA943E),
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
      Timer(const Duration(milliseconds: 500), () {
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
    translate = translateStrings(context);
    return WillPopScope(
      onWillPop: () async {
        // refreshMainState(context: context, isAsset: false);
        return true;
      },
      child: Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: translate!.customLiabilities,
            leadingIcon: getLeadingIcon(context, false),
            actions: IconButton(
                onPressed: () async {
                  addOtherLiabilities(RootApplicationAccess
                      .liabilitiesEntity!.otherLiabilities);
                },
                icon: const Icon(Icons.add))),
        body:
            BlocConsumer<MainOtherLiabilitiesCubit, MainOtherLiabilitiesState>(
          bloc: context
              .read<MainOtherLiabilitiesCubit>()
              .getOtherLiabilitiesData(),
          listener: (context, state) {
            if (state is MainOtherLiabilitiesLoaded) {
              if (state.showDeleteMsg) {
                showSnackBar(
                    context: context, title: translate!.otherLiabilityDeleted);
                setState(() {
                  isDeleting = false;
                });
              }
            }
            if (state is MainOtherLiabilitiesError) {
              setState(() {
                isDeleting = false;
              });
              showSnackBar(context: context, title: state.errorMsg);
            }
          },
          builder: (context, state) {
            if (state is MainOtherLiabilitiesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MainOtherLiabilitiesError) {
              return Center(
                child: Text(
                  state.errorMsg,
                  style: SubtitleHelper.h10,
                ),
              );
            } else if (state is MainOtherLiabilitiesLoaded) {
              LiabilitiesTotalEntity otherLiabilitiesSummary =
                  state.liabilitiesEntity.summary.otherLiabilities;
              List<OtherLiabilitiesEntity> otherLiabilitiesEntity =
                  state.liabilitiesEntity.otherLiabilities;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardValueContainer(
                          mainValue:
                              "${otherLiabilitiesSummary.currency} ${otherLiabilitiesSummary.amount}",
                          mainTitle: translate!.customLiabilitiesValue,
                          leftValue: "${otherLiabilitiesEntity.length}",
                          leftTitle: otherLiabilitiesEntity.length == 1
                              ? translate!.customLiabilities
                              : translate!.customLiabilities,
                          leftImage: "assets/icons/mainContainerLiability.png",
                          rightTitle: translate!.countries,
                          rightvalue:
                              "${otherLiabilitiesSummary.countryCount}"),
                      Column(
                        children: List.generate(
                            otherLiabilitiesEntity.length,
                            (index) => _exptiles(
                                otherLiabilitiesEntity[index], index)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AddNewButton(
                          text: translate!.addaCustomLiability,
                          onTap: () async {
                            addOtherLiabilities(
                                state.liabilitiesEntity.otherLiabilities);
                          })
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        bottomNavigationBar: FooterButton(
          text: translate!.addOtherLiabilities,
          onTap: () {
            // refreshMainState(context: context, isAsset: false);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  bool isDeleting = false;

  Widget _exptiles(OtherLiabilitiesEntity data, int index) {
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
      reconnectIcon: isAggregatorExpired(data: data)
          ? ReconnectIcon(
              isButton: true,
              data: data,
              onComplete: (val) {
                if (val) {
                  if (val) {
                    context
                        .read<MainOtherLiabilitiesCubit>()
                        .getOtherLiabilitiesData();
                  }
                }
              })
          : null,
      leftTitle: isManual
          ? data.name
          : data.providerName.isNotEmpty
              ? data.providerName
              : data.name,
      leftSubtitle: data.providerName != '' ? data.name : data.country,
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
                        showSnackBar(
                            context: context,
                            title: translate!.loading,
                            duration: const Duration(minutes: 3));

                        BlocProvider.of<MainOtherLiabilitiesCubit>(context,
                                listen: false)
                            .deleteOtherLiabilitiesData(
                                DeleteParams(id: data.id));
                        setState(() {
                          isDeleting = true;
                        });
                        Navigator.pop(context);
                      },
                      deniedPress: () {
                        Navigator.pop(context);
                      },
                      acceptText: translate!.yesDelete,
                      deniedText: translate!.noiWillKeepIt));
            },
      onEditPressed: isDeleting
          ? null
          : () async {
              var result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddOtherLiabilitiesPage(
                            otherLiabilitiesEntity: data,
                          )));
              if (result != null) {
                context
                    .read<MainOtherLiabilitiesCubit>()
                    .getOtherLiabilitiesData();
              }
            },
      rightTitle:
          '${data.outstandingAmount.currency} ${data.outstandingAmount.amount}',
    );
  }
}

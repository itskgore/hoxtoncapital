import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/entities/property_entity.dart';
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
import 'package:wedge/features/assets/all_assets/presentation/bloc/cubit/allassets_cubit.dart';
import 'package:wedge/features/assets/all_assets/presentation/pages/add_assets_page.dart';
import 'package:wedge/features/assets/properties/add_properties/presentation/pages/add_property_page.dart';
import 'package:wedge/features/assets/properties/properties_main/presentation/bloc/cubit/properties_cubit.dart';

import '../../../../../../core/common/functions/common_functions.dart';
import '../../../../../../core/contants/enums.dart';
import '../../../../../../core/utils/reconnect_aggregator.dart';
import '../../../../../../core/widgets/dialog/reconnect_dialog.dart';
import '../../../../../../core/widgets/reconnect_button.dart';
import '../../../../../../dependency_injection.dart';

class PropertiesMainPage extends StatefulWidget {
  final String? id;

  const PropertiesMainPage({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  _PropertiesMainPageState createState() => _PropertiesMainPageState();
}

class _PropertiesMainPageState extends State<PropertiesMainPage> {
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
  //             ReconnectAggregator.aggregatorReconnect(mounted: mounted,dataEntity: data);
  //             // _aggregatorReconnect(data);
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

  GlobalKey scrollToKey = GlobalKey();

  addProperties(List<PropertyEntity> properties) async {
    var data;
    if (properties.isEmpty) {
      data = await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddPropertyPage()));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddPropertyPage()));
    }
    if (data != null) {
      context.read<PropertiesCubit>().getData();
    }
  }

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
    translate = translateStrings(context);
    return BlocConsumer<PropertiesCubit, PropertiesState>(
      bloc: context.read<PropertiesCubit>().getData(),
      listener: (context, state) {
        if (state is PropertiesLoaded) {
          if (state.deleteMessageSent) {
            setState(() {
              isDeleting = false;
            });
            BlocProvider.of<AllAssetsCubit>(
              context,
            ).getData();
            showSnackBar(context: context, title: translate!.propertyDeleted);
            setState(() {});
          }
        }
        if (state is PropertiesError) {
          setState(() {
            isDeleting = false;
          });
          showSnackBar(context: context, title: state.errorMsg);
        }
      },
      builder: (context, state) {
        if (state is PropertiesLoaded) {
          return WillPopScope(
            onWillPop: () async {
              // refreshMainState(context: context, isAsset: true);
              return true;
            },
            child: Scaffold(
              backgroundColor: appThemeColors!.bg,
              appBar: wedgeAppBar(
                  context: context,
                  title: translate!.properties,
                  actions: IconButton(
                      onPressed: () async {
                        addProperties(state.assets.properties);
                      },
                      icon: const Icon(Icons.add)),
                  leadingIcon: getLeadingIcon(context, true)),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      DashboardValueContainer(
                          mainValue:
                              "${state.assets.summary.properties.currency} ${state.assets.summary.properties.amount}",
                          mainTitle: translate!.totalPropertyValue,
                          leftValue: "${state.assets.properties.length}",
                          leftTitle: state.assets.properties.length == 1
                              ? translate!.properties
                              : translate!.properties,
                          rightTitle: translate!.countries,
                          leftImage: "assets/icons/mainContainerProperty.png",
                          rightvalue:
                              "${state.assets.summary.properties.countryCount}"),
                      Column(
                          children: List.generate(
                              state.assets.properties.length, (index) {
                        return _exptiles(state.assets.properties[index], index);
                      })),
                      const SizedBox(
                        height: 20,
                      ),
                      AddNewButton(
                          text: translate!.addNewProperty,
                          onTap: () async {
                            addProperties(state.assets.properties);
                          })
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: FooterButton(
                text: translate!.addOtherAssets,
                onTap: () {
                  // refreshMainState(context: context, isAsset: true);
                  Navigator.pop(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) => AddAssetsPage()));
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

  List<MortgagesEntity> getMortgages(PropertyEntity properties) {
    List<MortgagesEntity> mortgages = [];
    properties.mortgages.forEach((element) {
      if (RootApplicationAccess.liabilitiesEntity != null) {
        RootApplicationAccess.liabilitiesEntity!.mortgages.forEach((e) {
          if (e.id == element.id) {
            mortgages.add(e);
          }
        });
      }
    });
    return mortgages;
  }

  Widget _exptiles(PropertyEntity data, int index) {
    List<MortgagesEntity> mortgages = getMortgages(data);
    log(data.source);
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
                  // showPopupBox(context, popupMessage, data);
                } else {
                  ReconnectAggregator.aggregatorReconnect(
                      mounted: mounted, dataEntity: data);
                  // _aggregatorReconnect(data);
                }
              },
            ),
      leftSubtitle: data.country,
      leftTitle: data.name,
      midWidget: mortgages.length > 0
          ? Column(
              children: List.generate(
                  mortgages.length,
                  (index) => Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              child: _mortgages(mortgages[index], index + 1)),
                        ],
                      )))
          : null,
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
                        setState(() {
                          isDeleting = true;
                        });
                        context.read<PropertiesCubit>().deleteProperty(data.id);
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
              var _result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddPropertyPage(
                            data: data,
                          )));
              if (_result != null) {
                context.read<PropertiesCubit>().getData();
              }
              setState(() {});
            },
      rightTitle: "${data.currentValue.currency} ${data.currentValue.amount}",
    );
  }

  Widget _mortgages(MortgagesEntity mortgages, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "${translate!.mortgage} $index",
                style: SubtitleHelper.h11.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(translate!.provider, style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(translate!.outStanding, style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(translate!.interestRate, style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  mortgages.maturityDate.isEmpty
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate!.maturityDate,
                                style: SubtitleHelper.h11),
                            const SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                  Text(translate!.monthlyPayement, style: SubtitleHelper.h11),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(mortgages.provider, style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                      "${mortgages.outstandingAmount.currency} ${numberFormat.format(mortgages.outstandingAmount.amount)}",
                      style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("${mortgages.interestRate}%", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  mortgages.maturityDate.isEmpty
                      ? const SizedBox()
                      : Text(getFormattedDate2(mortgages.maturityDate),
                          style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                      translate!.perMonthCost(
                          "${mortgages.monthlyPayment.currency} ${numberFormat.format(mortgages.monthlyPayment.amount)}"),
                      style: SubtitleHelper.h11),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

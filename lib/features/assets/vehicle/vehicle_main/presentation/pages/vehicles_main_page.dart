import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
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
import 'package:wedge/features/assets/vehicle/add_vehicle/presentation/pages/add_vehicle_manual_page.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/presentation/bloc/cubit/vehicles_cubit.dart';

import '../../../../../../core/common/functions/common_functions.dart';
import '../../../../../../core/contants/enums.dart';
import '../../../../../../core/utils/reconnect_aggregator.dart';
import '../../../../../../core/widgets/dialog/reconnect_dialog.dart';
import '../../../../../../core/widgets/reconnect_button.dart';
import '../../../../../../dependency_injection.dart';

class VehiclesMainPage extends StatefulWidget {
  final String? id;

  VehiclesMainPage({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  _VehiclesMainPageState createState() => _VehiclesMainPageState();
}

class _VehiclesMainPageState extends State<VehiclesMainPage> {
  bool isDeleting = false;
  final GlobalKey scrollToKey = GlobalKey();

  addVehicles(List<VehicleEntity> vehicles) async {
    var data;
    if (vehicles.isEmpty) {
      data = await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddVehicleManualPage()));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddVehicleManualPage()));
    }
    if (data != null) {
      context.read<VehiclesCubit>().getData();
    }
  }

  // ///Function get URl for reconnecting the account
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
    return BlocConsumer<VehiclesCubit, VehiclesState>(
      bloc: context.read<VehiclesCubit>().getData(),
      listener: (context, state) {
        if (state is VehiclesLoaded) {
          if (state.deleteMessageSent) {
            setState(() {
              isDeleting = false;
            });

            showSnackBar(context: context, title: translate!.vehicleDeleted);
          }
        }
        if (state is VehiclesError) {
          setState(() {
            isDeleting = false;
          });
          showSnackBar(context: context, title: state.errorMsg);
        }
      },
      builder: (context, state) {
        if (state is VehiclesLoaded) {
          return WillPopScope(
            onWillPop: () async {
              // refreshMainState(context: context, isAsset: true);
              return true;
            },
            child: Scaffold(
              backgroundColor: appThemeColors!.bg,
              appBar: wedgeAppBar(
                  context: context,
                  title: translate!.vehicles,
                  leadingIcon: getLeadingIcon(context, true),
                  actions: IconButton(
                      onPressed: () async {
                        addVehicles(state.assets.vehicles);
                      },
                      icon: const Icon(Icons.add))),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(kpadding),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardValueContainer(
                          mainValue:
                              "${state.assets.summary.vehicles.currency} ${state.assets.summary.vehicles.amount}",
                          mainTitle: translate!.totalVehiclesValue,
                          leftValue: "${state.assets.vehicles.length}",
                          leftImage: 'assets/icons/mainContainerVehicle.png',
                          leftTitle: state.assets.vehicles.length == 1
                              ? translate!.vehicle
                              : translate!.vehicles,
                          rightTitle: translate!.countries,
                          rightvalue:
                              "${state.assets.summary.vehicles.countryCount}"),
                      Column(
                        children: List.generate(
                            state.assets.vehicles.length,
                            (index) => _exptiles(state.assets.vehicles[index],
                                state.liabilitiesEntity, index)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AddNewButton(
                          text: translate!.addNewVehicle,
                          onTap: () async {
                            addVehicles(state.assets.vehicles);
                          })
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: FooterButton(
                text: translate!.addOtherAssets,
                onTap: () {
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

  Widget _exptiles(
      VehicleEntity data, LiabilitiesEntity liabilitiesEntity, int index) {
    var vehicleLoansEntity;
    if (data.hasLoan && data.vehicleLoans.isNotEmpty) {
      vehicleLoansEntity = liabilitiesEntity.vehicleLoans
          .where((element) => element.id == data.vehicleLoans[0].id)
          .toList();
    }

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
                  // _aggregatorReconnect(data);
                  ReconnectAggregator.aggregatorReconnect(
                      dataEntity: data, mounted: mounted);
                }
              },
            ),
      leftSubtitle: data.country,
      leftTitle: data.name,
      midWidget: data.hasLoan && data.vehicleLoans.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate!.loan,
                            style: SubtitleHelper.h11,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(translate!.interestRate,
                              style: SubtitleHelper.h11),
                          const SizedBox(
                            height: 8.0,
                          ),
                          vehicleLoansEntity[0].maturityDate.isEmpty
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
                          Text(translate!.monthlyPayement,
                              style: SubtitleHelper.h11),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      data.hasLoan && data.vehicleLoans.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${vehicleLoansEntity[0].monthlyPayment.currency} ${numberFormat.format(vehicleLoansEntity[0].outstandingAmount.amount)}",
                                    style: SubtitleHelper.h11),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text("${vehicleLoansEntity[0].interestRate}%",
                                    style: SubtitleHelper.h11),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                    getFormattedDate2(
                                        vehicleLoansEntity[0].maturityDate),
                                    style: SubtitleHelper.h11),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                    translate!.perMonthCost(
                                        "${vehicleLoansEntity[0].monthlyPayment.currency} ${numberFormat.format(vehicleLoansEntity[0].monthlyPayment.amount)}"),
                                    style: SubtitleHelper.h11),
                                const SizedBox(
                                  height: 8.0,
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ],
              ),
            )
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
                        setState(() {
                          isDeleting = true;
                        });
                        showSnackBar(
                            context: context,
                            title: translate!.loading,
                            duration: const Duration(minutes: 3));

                        context.read<VehiclesCubit>().deleteData(data.id);
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
              var vehicleLoansEntity;
              if (data.hasLoan && data.vehicleLoans.isNotEmpty) {
                vehicleLoansEntity = data.vehicleLoans;
              }
              await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddVehicleManualPage(
                            assetData: data,
                            vehicleLoansEntity: vehicleLoansEntity,
                          )));
              context.read<VehiclesCubit>().getData();
              setState(() {});
            },
      rightTitle: '${data.value.currency} ${data.value.amount}',
    );
    ;
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/liabilities_total_summary_entity.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/core/widgets/buttons/footer_single_button.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/reconnect_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/presentation/pages/add_vehicle_loan_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/presentation/cubit/main_vehicle_loans_cubit.dart';

import '../../../../../../core/common/functions/common_functions.dart';
import '../../../../../../core/contants/enums.dart';
import '../../../../../../core/utils/reconnect_aggregator.dart';
import '../../../../../../core/widgets/reconnect_button.dart';

class VehicleLoanMainPage extends StatefulWidget {
  String? id;

  VehicleLoanMainPage({Key? key, this.id}) : super(key: key);

  @override
  _VehicleLoanMainPageState createState() => _VehicleLoanMainPageState();
}

class _VehicleLoanMainPageState extends State<VehicleLoanMainPage> {
  final GlobalKey scrollToKey = GlobalKey();

  addVechicleLoan(List<VehicleLoansEntity> vehicleLoans) async {
    var data;
    if (vehicleLoans.isEmpty) {
      data = await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddVehicleLoanPage()));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddVehicleLoanPage()));
    }
    if (data != null) {
      context.read<MainVehicleLoansCubit>().getVehicleLoans();
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
            title: "${translate!.add} ${translate!.vehicleLoan}",
            leadingIcon: getLeadingIcon(context, false),
            actions: IconButton(
                onPressed: () async {
                  addVechicleLoan(
                      RootApplicationAccess.liabilitiesEntity?.vehicleLoans ??
                          []);
                },
                icon: const Icon(Icons.add))),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocConsumer<MainVehicleLoansCubit, MainVehicleLoansState>(
                bloc: context.read<MainVehicleLoansCubit>().getVehicleLoans(),
                listener: (context, state) {
                  if (state is MainVehicleLoansLoaded) {
                    if (state.showDeleteMsg) {
                      showSnackBar(
                          context: context,
                          title: translate!.vehicleLoanDeleted);
                      setState(() {
                        isDeleting = false;
                      });
                    }
                  }
                  if (state is MainVehicleLoansError) {
                    showSnackBar(
                        context: context, title: "Vehicle Loan deleted!");
                    setState(() {
                      isDeleting = false;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is MainVehicleLoansError) {
                    return Center(
                      child: Text(state.errorMsg),
                    );
                  } else if (state is MainVehicleLoansLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MainVehicleLoansLoaded) {
                    LiabilitiesTotalEntity vehicleLoansSummy =
                        state.liabilitiesEntity.summary.vehicleLoans;
                    List<VehicleLoansEntity> vehicleLoansList =
                        state.liabilitiesEntity.vehicleLoans;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DashboardValueContainer(
                            mainValue:
                                "${vehicleLoansSummy.currency} ${vehicleLoansSummy.amount}",
                            mainTitle: translate!.totalVehicleLoansOutstanding,
                            leftValue: "${vehicleLoansList.length}",
                            leftTitle: vehicleLoansList.length == 1
                                ? translate!.vehicleLoan
                                : translate!.vehicleLoans,
                            leftImage: "assets/icons/mainContainerVehicle.png",
                            rightTitle: translate!.countries,
                            rightvalue: "${vehicleLoansSummy.countryCount}"),
                        Column(
                          children: List.generate(
                              vehicleLoansList.length,
                              (index) =>
                                  _exptiles(vehicleLoansList[index], index)),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        AddNewButton(
                            text: "${translate!.add} ${translate!.vehicleLoan}",
                            onTap: () async {
                              addVechicleLoan(
                                  state.liabilitiesEntity.vehicleLoans);
                            })
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              )),
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

  Widget _exptiles(VehicleLoansEntity data, int index) {
    // Logic to get Vehicles
    List<VehicleEntity> d = [];
    RootApplicationAccess.assetsEntity?.vehicles.forEach((e) {
      if (e.vehicleLoans
          .where((element) => element.id == data.id)
          .toList()
          .isNotEmpty) {
        d.add(e);
      }
    });
    bool isManual = data.source.toLowerCase() == "manual" || data.source == '';
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
      index: index,
      isUnlink: !isManual,
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
      leftSubtitle: data.providerName != '' ? data.name : data.country,
      leftTitle: isManual ? data.provider : "${data.providerName} ${data.name}",
      midWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  translate!.loan,
                  style: SubtitleHelper.h11,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(translate!.interestRate, style: SubtitleHelper.h11),
                const SizedBox(
                  height: 8.0,
                ),
                data.vehicles.isEmpty
                    ? Container()
                    : Column(
                        children: [
                          Text(translate!.vehicle, style: SubtitleHelper.h11),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                Text(translate!.maturityDate, style: SubtitleHelper.h11),
                d.isNotEmpty
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 8.0,
                          ),
                          Column(
                            children: List.generate(d.length, (index) {
                              return Text(translate!.vehicle,
                                  style: SubtitleHelper.h11);
                            }),
                          )
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 8.0,
                ),
                Text(translate!.monthlyPayment, style: SubtitleHelper.h11),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(translate!.yes, style: SubtitleHelper.h11),
                const SizedBox(
                  height: 8.0,
                ),
                Text("${data.interestRate}%", style: SubtitleHelper.h11),
                const SizedBox(
                  height: 8.0,
                ),
                data.maturityDate.isEmpty
                    ? const SizedBox()
                    : Text(getFormattedDate2(data.maturityDate),
                        style: SubtitleHelper.h11),
                d.isNotEmpty
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 8.0,
                          ),
                          Column(
                            children: List.generate(d.length, (index) {
                              return Text(d[index].name,
                                  style: SubtitleHelper.h11);
                            }),
                          )
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                    translate!.perMonthCost(
                        "${data.monthlyPayment.currency} ${data.monthlyPayment.amount}"),
                    style: SubtitleHelper.h11),
              ],
            ),
          ],
        ),
      ),
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

                        BlocProvider.of<MainVehicleLoansCubit>(context)
                            .deleteVehicleLoans(DeleteParams(id: data.id));
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
              var _result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddVehicleLoanPage(
                            vehicleLoansEntity: data,
                          )));
              if (_result != null) {
                context.read<MainVehicleLoansCubit>().getVehicleLoans();
              }
            },
      rightTitle:
          '${data.outstandingAmount.currency} ${data.outstandingAmount.amount}',
    );
  }
}

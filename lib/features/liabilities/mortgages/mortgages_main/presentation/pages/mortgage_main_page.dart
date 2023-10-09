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
import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/entities/property_entity.dart';
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
import 'package:wedge/features/assets/all_assets/presentation/bloc/cubit/allassets_cubit.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/presentation/pages/add_mortgages_page.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/presentation/cubit/mortage_main_cubit.dart';

import '../../../../../../core/contants/enums.dart';
import '../../../../../../core/utils/reconnect_aggregator.dart';
import '../../../../../../core/widgets/dialog/reconnect_dialog.dart';
import '../../../../../../core/widgets/reconnect_button.dart';

class MortgageMainPage extends StatefulWidget {
  final String? id;

  const MortgageMainPage({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  _MortgageMainPageState createState() => _MortgageMainPageState();
}

class _MortgageMainPageState extends State<MortgageMainPage> {
  final GlobalKey scrollToKey = GlobalKey();

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

  addMortgages(List<MortgagesEntity> mortgages) async {
    var data;
    if (mortgages.isEmpty) {
      data = await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddMortgagesPage(
                    mortgages: mortgages,
                  )));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddMortgagesPage(
                    mortgages: mortgages,
                  )));
    }
    if (data != null) {
      context.read<MortageMainCubit>().getMortgages(context);
    }
  }

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
    var translate = translateStrings(context);
    return WillPopScope(
      onWillPop: () async {
        // refreshMainState(context: context, isAsset: false);
        return true;
      },
      child: Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: translate!.mortgages,
            leadingIcon: getLeadingIcon(context, false),
            actions: IconButton(
                onPressed: () async {
                  addMortgages(
                      RootApplicationAccess.liabilitiesEntity?.mortgages ?? []);
                },
                icon: const Icon(Icons.add))),
        body: BlocConsumer<MortageMainCubit, MortageMainState>(
          bloc: context.read<MortageMainCubit>().getMortgages(context),
          listener: (context, state) {
            if (state is MortageMainLoaded) {
              if (state.showDeleteMsg) {
                showSnackBar(context: context, title: "Mortgage deleted!");
                setState(() {
                  isDeleting = false;
                });
                context.read<AllAssetsCubit>().getAllAssets(NoParams());
              }
            }
            if (state is MortageMainError) {
              setState(() {
                isDeleting = false;
              });
              showSnackBar(context: context, title: state.errorMsg);
            }
          },
          builder: (context, state) {
            if (state is MortageMainLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MortageMainLoaded) {
              LiabilitiesTotalEntity vehicleLoansSummy =
                  state.liabilitiesEntity.summary.mortgages;
              List<MortgagesEntity> vehicleLoansList =
                  state.liabilitiesEntity.mortgages;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardValueContainer(
                          mainValue:
                              "${vehicleLoansSummy.currency} ${vehicleLoansSummy.amount}",
                          mainTitle: "Total outstanding mortgage",
                          leftValue: "${vehicleLoansList.length}",
                          leftImage: "assets/icons/mainContainerProperty.png",
                          leftTitle: vehicleLoansList.length == 1
                              ? "Mortgage"
                              : "Mortgages",
                          rightTitle: "Countries",
                          rightvalue: "${vehicleLoansSummy.countryCount}"),
                      Column(
                          children: List.generate(
                              vehicleLoansList.length,
                              (index) => _exptiles(vehicleLoansList[index],
                                  state.properties, index))),
                      const SizedBox(
                        height: 30,
                      ),
                      AddNewButton(
                          text: "Add a mortgage",
                          onTap: () async {
                            addMortgages(vehicleLoansList);
                          })
                    ],
                  ),
                ),
              );
            } else if (state is MortageMainError) {
              return Center(
                child: Text(state.errorMsg),
              );
            } else {
              return Container();
            }
          },
        ),
        bottomNavigationBar: FooterButton(
          text: "Add other liabilities",
          onTap: () {
            // refreshMainState(context: context, isAsset: false);
            Navigator.pop(context);

            // Navigator.push(
            //     context,
            //     CupertinoPageRoute(
            //         builder: (BuildContext context) => AddLiabilitiesPage()));
          },
        ),
      ),
    );
  }

  bool isDeleting = false;

  Widget _exptiles(
      MortgagesEntity data, List<PropertyEntity> properties, int index) {
    final property = [];

    properties.forEach((element) {
      element.mortgages.forEach((m) {
        if (m.id == data.id) {
          property.add(element);
        }
      });
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
      leftTitle: data.providerName != '' ? data.providerName : data.provider,
      leftSubtitle: data.providerName != '' ? data.name : data.country,
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
                }
              },
            ),
      midWidget: isManual
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Interest rate",
                        style: SubtitleHelper.h11,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text("Monthly payment", style: SubtitleHelper.h11),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text("Maturity date", style: SubtitleHelper.h11),
                      property.isEmpty
                          ? Container()
                          : Column(
                              children: List.generate(property.length, (index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text("Property", style: SubtitleHelper.h11),
                                ],
                              );
                            })),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${data.interestRate}%", style: SubtitleHelper.h11),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                          "${data.monthlyPayment.currency} ${numberFormat.format(data.monthlyPayment.amount)} per month",
                          style: SubtitleHelper.h11),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(getFormattedDate2(data.maturityDate),
                          style: SubtitleHelper.h11),
                      property.isEmpty
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(property.length, (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text("${property[index].name}",
                                        style: SubtitleHelper.h11),
                                  ],
                                );
                              }),
                            )
                    ],
                  ),
                ],
              ),
            )
          : null,
      isUnlink: !isManual,
      onDeletePressed: isDeleting
          ? null
          : () {
              locator.get<WedgeDialog>().confirm(
                  context,
                  WedgeConfirmDialog(
                      title: translateStrings(context)!.areYouSure,
                      subtitle: isManual
                          ? translate!.remeberMoreAccurateMessage
                          : data.source.toLowerCase() ==
                                  AggregatorProvider.Saltedge.name.toLowerCase()
                              ? translate!.saltEdgeDeleteConfirmation
                              : translate!.yodleeDeleteConfirmation,
                      acceptedPress: () {
                        showSnackBar(
                            context: context,
                            title: "Loading....",
                            duration: const Duration(minutes: 3));
                        context
                            .read<MortageMainCubit>()
                            .deleteMortages(DeleteParams(id: data.id), context);
                        setState(() {
                          isDeleting = true;
                        });
                        Navigator.pop(context);
                        setState(() {
                          isDeleting = true;
                        });
                      },
                      deniedPress: () {
                        Navigator.pop(context);
                      },
                      acceptText: "Yes, delete",
                      deniedText: "No, keep it"));
            },
      onEditPressed: isDeleting
          ? null
          : () async {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddMortgagesPage(
                            mortgagesData: data,
                            mortgages: RootApplicationAccess
                                    .liabilitiesEntity?.mortgages ??
                                [],
                          )));

              context.read<MortageMainCubit>().getMortgages(context);
            },
      rightTitle:
          '${data.outstandingAmount.currency} ${data.outstandingAmount.amount}',
    );
  }

  Widget _mortgages(mortgage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Mortgage $mortgage",
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
                  Text("Interest rate", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("Monthly payment", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("Maturity date", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("Property", style: SubtitleHelper.h11),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("7%", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("5,700 per month", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("14 Months", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("Property name", style: SubtitleHelper.h11),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

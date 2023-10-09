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
import 'package:wedge/core/entities/personal_loan_entity.dart';
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
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/presentation/pages/add_personal_loan_page.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/presentation/bloc/mainpersonalloan_cubit.dart';

import '../../../../../../core/contants/enums.dart';
import '../../../../../../core/utils/reconnect_aggregator.dart';
import '../../../../../../core/widgets/dialog/reconnect_dialog.dart';
import '../../../../../../core/widgets/reconnect_button.dart';

class PersonalLoanMainPage extends StatefulWidget {
  final String? id;

  const PersonalLoanMainPage({Key? key, this.id}) : super(key: key);

  @override
  _PersonalLoanMainPageState createState() => _PersonalLoanMainPageState();
}

class _PersonalLoanMainPageState extends State<PersonalLoanMainPage> {
  final GlobalKey scrollToKey = GlobalKey();

  addPersonalLoan(List<PersonalLoanEntity> personalLoans) async {
    var data;
    if (personalLoans.isEmpty) {
      data = await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddPersonalLoanPage()));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddPersonalLoanPage()));
    }
    if (data != null) {
      context.read<MainPersonalLoanCubit>().getmainPesonalLoan();
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
            title: translate!.personalLoans,
            leadingIcon: getLeadingIcon(context, false),
            actions: IconButton(
                onPressed: () {
                  addPersonalLoan(
                      RootApplicationAccess.liabilitiesEntity?.personalLoans ??
                          []);
                },
                icon: const Icon(Icons.add))),
        body: BlocConsumer<MainPersonalLoanCubit, MainPersonalLoanState>(
          bloc: context.read<MainPersonalLoanCubit>().getmainPesonalLoan(),
          listener: (context, state) {
            if (state is MainpersonalloanError) {
              // show snack
              showSnackBar(context: context, title: state.errorMsg);
              setState(() {
                isDeleting = false;
              });
            } else if (state is MainpersonalloanLoaded) {
              if (state.showDeleteMsg) {
                // show snack
                showSnackBar(
                    context: context, title: translate!.personalLoanDeleted);
                setState(() {
                  isDeleting = false;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is MainpersonalloanLoaded) {
              LiabilitiesTotalEntity personalLoansSummy =
                  state.data.summary.personalLoans;
              List<PersonalLoanEntity> personalLoansList =
                  state.data.personalLoans;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardValueContainer(
                          mainValue:
                              "${personalLoansSummy.currency} ${personalLoansSummy.amount}",
                          mainTitle: translate!.totalOutstandingPersonalLoans,
                          leftValue: "${personalLoansList.length}",
                          leftTitle: personalLoansList.length == 1
                              ? translate!.personalLoans
                              : translate!.personalLoans,
                          leftImage:
                              "assets/icons/bankAccountMainContainer.png",
                          rightTitle: translate!.countries,
                          rightvalue: "${personalLoansSummy.countryCount}"),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   "Personal loans you’ve added ",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w600, fontSize: kfontMedium),
                      // ),
                      // Divider(),
                      Column(
                          children: List.generate(
                              personalLoansList.length,
                              (index) => _exptiles(
                                  personalLoansList[index],
                                  personalLoansSummy.amount.toString(),
                                  index))),
                      // Expanded(
                      //   child: ListView.builder(
                      //       physics: ScrollPhysics(),
                      //       itemCount: personalLoansList.length,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return _exptiles(personalLoansList[index],
                      //             personalLoansSummy.amount.toString(), index);
                      //       }),
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      AddNewButton(
                          text: translate!.add + " " + translate!.personalLoans,
                          onTap: () async {
                            addPersonalLoan(state.data.personalLoans);
                          })
                    ],
                  ),
                ),
              );
            } else if (state is MainpersonalloanError) {
              return Center(
                child: Text(
                  state.errorMsg,
                  style: SubtitleHelper.h10,
                ),
              );
            } else if (state is MainpersonalloanLoading) {
              return const Center(child: CircularProgressIndicator());
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

  Widget _exptiles(PersonalLoanEntity data, String totalAmt, int index) {
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
      leftSubtitle: data.providerName != '' ? data.provider : data.country,
      leftTitle: data.providerName != '' ? data.providerName : data.provider,
      midWidget: data.source.toLowerCase() != "manual"
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        translate!.outStanding,
                        style: SubtitleHelper.h11,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(translate!.interestRate, style: SubtitleHelper.h11),
                      const SizedBox(
                        height: 8.0,
                      ),
                      data.maturityDate.isEmpty
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
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
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "${data.outstandingAmount.currency} ${numberFormat.format(data.outstandingAmount.amount)}",
                          style: SubtitleHelper.h11),
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
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                          "${data.monthlyPayment.currency} ${numberFormat.format(data.monthlyPayment.amount)}",
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
                        setState(() {
                          isDeleting = true;
                        });
                        showSnackBar(
                            context: context,
                            title: translate!.loading,
                            duration: const Duration(minutes: 3));

                        BlocProvider.of<MainPersonalLoanCubit>(context,
                                listen: false)
                            .deletePersonalLoan(data.id);
                        Navigator.pop(context);
                      },
                      deniedPress: () {
                        Navigator.pop(context);
                      },
                      acceptText: translate!.yesDelete,
                      deniedText: translate!.noiWillKeepIt));
            },
      onEditPressed: data.source.toLowerCase() != "manual" || isDeleting
          ? null
          : () async {
              var _result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddPersonalLoanPage(
                            personalLoanEntity: data,
                          )));
              if (_result != null) {
                context.read<MainPersonalLoanCubit>().getmainPesonalLoan();
              }
            },
      rightTitle:
          '${data.outstandingAmount.currency} ${data.outstandingAmount.amount}',
    );
  }
}

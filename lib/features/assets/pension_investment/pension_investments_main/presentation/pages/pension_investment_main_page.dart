import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/presentation/pages/add_investment_manual_page.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/presentation/pages/add_pension_manual_page.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/presentation/bloc/cubit/pension_investment_main_cubit.dart';
import 'package:wedge/features/your_investments/presentation/pages/your_investments_main.dart';
import 'package:wedge/features/your_pensions/presentation/pages/your_pensions_main.dart';

import '../../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../../core/utils/wedge_snackBar.dart';
import '../../../../../../core/widgets/bottomSheet/duration_selector_bottomsheet.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/wedge_echarts.dart';
import '../widgets/list_tile_inverstments.dart';

final today = DateUtils.dateOnly(DateTime.now());

class PensionInvestmentMainPage extends StatefulWidget {
  const PensionInvestmentMainPage({
    Key? key,
  }) : super(key: key);

  @override
  _PensionInvestmentMainPageState createState() =>
      _PensionInvestmentMainPageState();
}

class _PensionInvestmentMainPageState extends State<PensionInvestmentMainPage> {
  AppLocalizations? translate;

  @override
  void initState() {
    context.read<PensionInvestmentMainCubit>().getData(
          endDate: DateTime.now(),
          startDate: Jiffy.now().subtract(months: 1).dateTime,
        );
    super.initState();
  }

  addInvestment() async {
    await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => AddBankAccountPage(
                  isAppBar: true,
                  successPopUp: (_, {required String source}) async {
                    if (_) {
                      // success
                      await RootApplicationAccess().storeAssets();
                      locator.get<WedgeDialog>().success(
                          context: context,
                          title: translate?.accountLinkedSuccessfully ?? "",
                          info: getPopUpDescription(source),
                          buttonLabel: translate?.continueWord ?? "",
                          onClicked: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            setState(() {});
                          });
                    } else {
                      // exited
                      Navigator.pop(context);
                    }
                  },
                  subtitle: translate!.orSelectFromTheBrokersBelow,
                  manualAddButtonAction: () async {
                    final data = await Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                AddInvestmentManualPage(
                                  isFromDashboard: true,
                                )));
                    // resetState();
                    if (data != null) {
                      setState(() {});
                    }
                  },
                  manualAddButtonTitle: translate!.addManually,
                  placeholder: translate!.addInvestmentPlatforms,
                  title: translate!.manuallyAddanInvestmentAccount,
                )));
  }

  addPension() async {
    await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => AddBankAccountPage(
                  isAppBar: true,
                  successPopUp: (_, {required String source}) async {
                    if (_) {
                      // success
                      await RootApplicationAccess().storeAssets();
                      locator.get<WedgeDialog>().success(
                          context: context,
                          title: translate?.accountLinkedSuccessfully ?? "",
                          info: getPopUpDescription(source),
                          buttonLabel: translate?.continueWord ?? "",
                          onClicked: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            setState(() {});
                            // Navigator.push(
                            //     context,
                            //     CupertinoPageRoute(
                            //         builder: (BuildContext
                            //                 context) =>
                            //             PensionMainPage()));
                          });
                    } else {
                      // exited
                      Navigator.pop(context);
                    }
                  },
                  subtitle: translate!.orSelectFromthePensionProvidersBelow,
                  manualAddButtonAction: () async {
                    final data = await Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                AddPensionManualPage(
                                  isFromDashboard: true,
                                )));
                    if (data != null) {
                      setState(() {});
                    }
                  },
                  manualAddButtonTitle: translate!.addManually,
                  placeholder: translate!.searchYourPensionProvider,
                  title: "${translate!.add} ${translate!.pensions}",
                )));
  }

  List selectedDateListData = [];
  bool isLoading = false;
  DateTime startDate = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    //
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
        context: context,
        title: translate!.investments,
      ),
      body:
          BlocConsumer<PensionInvestmentMainCubit, PensionInvestmentMainState>(
        listener: (context, state) {
          if (state is PensionInvestmentMainError) {
            showSnackBar(context: context, title: state.errorMsg);
          }
        },
        builder: (context, state) {
          if (state is PensionInvestmentMainLoaded) {
            List<Map<String, dynamic>> modelIds = [];
            for (var e in state.data.investments) {
              modelIds.add({'id': e.id, 'name': e.name});
            }
            modelIds.add({'id': 'total', 'name': "Total"});
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    DashboardValueContainer(
                      mainValue:
                          "${state.data.summary.investments.currency} ${state.data.summary.investments.amount}",
                      mainTitle: translate!.totalInvestmentsValue,
                      leftImage: "assets/icons/Investments.png",
                      leftValue: "${state.data.summary.investments.count}",
                      isSingleTitle: true,
                      leftTitle: translate!.investments,
                      // rightTitle: translate!.investments,
                      // rightvalue: "${state.data.summary.investments.count}",
                    ),
                    Visibility(
                      visible: (state.performanceData.isNotEmpty),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  DurationSelectorBottomSheet(
                                    startDate: startDate,
                                    endDate: endDate,
                                    isShowMax: false,
                                    createdAt: state.data.investments.isNotEmpty
                                        ? state.data.investments[0].createdAt!
                                        : "",
                                    initDateList: selectedDateListData,
                                    onChange: (dates) async {
                                      context
                                          .read<PensionInvestmentMainCubit>()
                                          .refreshData(
                                            endDate: getDateTimeOnly(
                                                datetime: dates![1]),
                                            startDate: getDateTimeOnly(
                                                datetime: dates[0]),
                                          );

                                      startDate = dates[0];
                                      endDate = dates![1];
                                      setState(() {
                                        selectedDateListData = dates;
                                        isLoading = true;
                                      });
                                      await Future.delayed(
                                          const Duration(milliseconds: 500));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              isLoading
                                  ? Center(
                                      child: buildCircularProgressIndicator(
                                          width: 20),
                                    )
                                  : SizedBox(
                                      width: size.width,
                                      height: size.height * .25,
                                      child: WedgeEcharts(
                                          index: 1,
                                          isFiltered: state.isFiltered,
                                          currency: state.currency,
                                          data: state.performanceData)),
                              // PerformanceChart(
                              //     currencyType: state.currency,
                              //     chartData: loadGraphData(
                              //         state.performanceAPIData))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${translate!.investments} (${state.data.investments.length})",
                          style: TitleHelper.h9,
                        ),
                        AppButton(
                            onTap: () async {
                              addInvestment();
                            },
                            label: translate!.add)
                      ],
                    ),
                    state.data.investments.isEmpty
                        ? FittedBox(
                            child: Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: Row(
                                children: [
                                  Text(
                                    translate!.noDataAvai,
                                    style: TextHelper.h5.copyWith(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      addInvestment();
                                    },
                                    child: Text(
                                      "${translate!.add} ${translate!.investments}",
                                      style: TextHelper.h6.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: appThemeColors!.outline),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              // AggregationResultChart(
                              //   modelId: modelIds,
                              //   isHolding: false,
                              //   type: AggregationChartType.Investment,
                              // ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: state.data.investments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _listTileInvestments(
                                      index, state.data.investments[index]);
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          } else if (state is PensionInvestmentMainLoading) {
            return Center(
              child: buildCircularProgressIndicator(width: 150),
            );
          } else if (state is PensionInvestmentMainError) {
            return Center(
              child: Text(state.errorMsg),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

//TODO : @Shahbaz Why this Widget not used
  Widget _listTile(index, PensionsEntity data) {
    var source = data.source.toLowerCase();
    return Stack(
      children: [
        ListTileInvestment(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => YourPensionsMain(
                          pensionsEntity: data,
                        ))).then((value) {
              if (value != null && value == true) {
                // setState(() {});
                context.read<PensionInvestmentMainCubit>().getData(
                    endDate: DateTime.now(),
                    startDate: Jiffy.now().subtract(months: 1).dateTime);
              }
            });
          },
          leading: source == "hoxton" || source != "manual"
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/icons/persoanlLoanMainContainer.png',
                    image: data.aggregatorLogo,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/icons/persoanlLoanMainContainer.png",
                        height: 40,
                        width: 40,
                      );
                    },
                    height: 40,
                    width: 40,
                  ),
                )
              : Image.asset(
                  "assets/icons/persoanlLoanMainContainer.png",
                  height: 40,
                  width: 40,
                ),
          // : Image.asset("assets/icons/link.png", height: 16),
          title: data.name,
          subTitle: "",
          trailing: data.pensionType == "Defined Contribution"
              ? "${data.currentValue.currency} ${numberFormat.format(data.currentValue.amount)}"
              : "${data.annualIncomeAfterRetirement.currency} ${numberFormat.format(data.annualIncomeAfterRetirement.amount)}",
          saltedgeData: data,
        ),
        Positioned(
          right: 42,
          top: 30,
          child: source == "hoxton"
              ? Image.asset(
                  "assets/icons/hoxton_badge.png",
                  height: 18,
                )
              : ((source != "manual" && source != "hoxton")
                  ? Image.asset(
                      "assets/icons/link_badge.png",
                      height: 18,
                    )
                  : const SizedBox()),
        )
      ],
    );
  }

  Widget _listTileInvestments(index, InvestmentEntity data) {
    var source = data.source?.toLowerCase();
    if (source == 'manual') {
      return WedgeExpansionTile(
        leading: Image.asset(
          "assets/icons/persoanlLoanMainContainer.png",
          height: 40,
          width: 40,
        ),
        //Todo: Discuss
        // onTab: () {
        //   Navigator.push(
        //       context,
        //       CupertinoPageRoute(
        //           builder: (BuildContext context) => YourInvestmentsMain(
        //                 investmentEntity: data,
        //               ))).then((value) {
        //     if (value != null && value == true) {
        //       context.read<PensionInvestmentMainCubit>().getData(
        //           endDate: DateTime.now(),
        //           startDate: Jiffy().subtract(months: 1).dateTime);
        //     }
        //   });
        // },
        padding: EdgeInsets.zero,
        margin: EdgeInsets.symmetric(vertical: 10),
        borderRadius: 10,
        index: index,
        leftTitle: data.name,
        leftTitleStyle: TitleHelper.h10.copyWith(color: Colors.black),
        rightSubTitle: 'Manual',
        rightSubtitleStyle: SubtitleHelper.h11,
        rightTitle:
            "${data.currentValue.currency} ${numberFormat.format(data.currentValue.amount)}",
        rightTitleStyle: TitleHelper.h10.copyWith(color: Colors.black),
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
                    translate!.policyNumber,
                    style: SubtitleHelper.h11,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    translate!.initialValue,
                    style: SubtitleHelper.h11,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(data.policyNumber.isEmpty ? "Nil" : data.policyNumber),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "${data.initialValue.currency} ${numberFormat.format(data.initialValue.amount)}",
                    style: SubtitleHelper.h11,
                  ),
                ],
              ),
            ],
          ),
        ),
        onDeletePressed: () {
          //Todo: Add onPressed Event
        },
        onEditPressed: () {
          //Todo: Add onPressed Event
        },
      );
    } else {
      return Stack(
        children: [
          ListTileInvestment(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => YourInvestmentsMain(
                            investmentEntity: data,
                          ))).then((value) {
                if (value != null && value == true) {
                  context.read<PensionInvestmentMainCubit>().getData(
                      endDate: DateTime.now(),
                      startDate: Jiffy.now().subtract(months: 1).dateTime);
                }
              });
            },
            leading: source == "hoxton" || source != "manual"
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/icons/persoanlLoanMainContainer.png',
                      image: data.aggregatorLogo ?? "",
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/icons/persoanlLoanMainContainer.png",
                          height: 40,
                          width: 40,
                        );
                      },
                      height: 40,
                      width: 40,
                    ),
                  )
                : Image.asset(
                    "assets/icons/persoanlLoanMainContainer.png",
                    height: 40,
                    width: 40,
                  ),
            title: data.name,
            /*title:( data.source!.toLowerCase() != "manual")
              (? data.providerName != ""
                  ? data.providerName
                  : data.name.length > 16
                      ? "${data.name.substring(0, 15)}..."
                      : data.name
              : data.name.length > 16
                  ? "${data.name.substring(0, 15)}...")
                  : data.name,*/
            subTitle: data.providerName != '' ? data.name : "",
            saltedgeData: data,
            trailing:
                "${data.currentValue.currency} ${numberFormat.format(data.currentValue.amount)}",
          ),
        ],
      );
    }
  }
}

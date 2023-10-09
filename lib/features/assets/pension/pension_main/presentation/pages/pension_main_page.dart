import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/presentation/pages/add_pension_manual_page.dart';
import 'package:wedge/features/assets/pension/pension_main/presentation/bloc/pensionmaincubit_cubit.dart';

import '../../../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_peformance_cubit.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_performance_state.dart';
import '../../../../../../core/contants/enums.dart';
import '../../../../../../core/widgets/bottomSheet/duration_selector_bottomsheet.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/wedge_echarts.dart';
import '../../../../../your_pensions/presentation/pages/your_pensions_main.dart';
import '../../../../pension_investment/pension_investments_main/presentation/widgets/list_tile_inverstments.dart';

class PensionMainPage extends StatefulWidget {
  PensionMainPage({Key? key}) : super(key: key);

  @override
  _PensionMainPageState createState() => _PensionMainPageState();
}

class _PensionMainPageState extends State<PensionMainPage> {
  AppLocalizations? translate;
  final lastDayPerformanceSummary = ValueNotifier<LastDayPerformance?>(null);

  addPensions(List<PensionsEntity> pensions) async {
    var stocksdata;
    stocksdata = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => AddBankAccountPage(
                  isAppBar: true,
                  successPopUp: (_, {required String source}) async {
                    if (_) {
                      // success
                      await RootApplicationAccess().storeAssets();
                      await RootApplicationAccess().storeLiabilities();
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
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        PensionMainPage()));
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
                                AddPensionManualPage()));
                    if (data != null) {
                      setState(() {});
                    }
                  },
                  manualAddButtonTitle: translate!.addManually,
                  placeholder: translate!.searchYourPensionProvider,
                  title: "${translate!.add} ${translate!.pensions}",
                )));

    if (stocksdata != null) {
      context.read<PensionMaincubitCubit>().getPensionsData();
    }
  }

  getPensionsPerformance() {
    context.read<LinePerformanceCubit>().getLinePerformanceData(
        merge: true,
        scope: ['fi'],
        isFiltered: false,
        fromDate: dateFormatter5.format(DateTime(
            DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)),
        toDate: dateFormatter5.format(
          DateTime.now(),
        ),
        assetType: 'pension',
        isPerformance: false);
  }

  @override
  void initState() {
    getPensionsPerformance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime startDate =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
    DateTime endDate = currentDate;
    List selectedDateListData = [];
    translate = translateStrings(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: translate!.pensions,
            leadingIcon: getLeadingIcon(context, true),
            actions: IconButton(
                onPressed: () async {
                  addPensions(
                      RootApplicationAccess.assetsEntity?.pensions ?? []);
                },
                icon: const Icon(Icons.add))),
        body: BlocConsumer<PensionMaincubitCubit, PensionMainCubitState>(
          bloc: context.read<PensionMaincubitCubit>().getPensionsData(),
          listener: (context, state) {
            if (state is PensionMainCubitError) {
              setState(() {
                isDeleting = false;
              });
              showSnackBar(context: context, title: state.errorMsg);
            } else if (state is PensionMainCubitLoaded) {
              if (state.hasDeleted) {
                showSnackBar(context: context, title: translate!.assetDeleted);
                setState(() {
                  isDeleting = false;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is PensionMainCubitLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ValueListenableBuilder(
                            valueListenable: lastDayPerformanceSummary,
                            builder: (context, value, child) {
                              return DashboardValueContainer(
                                isSingleTitle: true,
                                mainValue:
                                    "${state.assets.summary.pensions.currency} ${state.assets.summary.pensions.amount}",
                                mainTitle: translate!.totalPensionValue,
                                leftValue: "${state.assets.pensions.length}",
                                leftTitle: state.assets.pensions.length == 1
                                    ? translate!.pensions
                                    : translate!.pensions,
                                rightTitle: translate!.countries,
                                leftImage:
                                    "assets/icons/pensionMainContainer.png",
                                rightvalue:
                                    "${state.assets.summary.pensions.countryCount}",
                                summary: value,
                              );
                            }),
                      ),

                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DurationSelectorBottomSheet(
                                startDate: startDate,
                                endDate: endDate,
                                isShowMax: true,
                                createdAt: state.assets.pensions.isNotEmpty
                                    ? state.assets.pensions.first.createdAt
                                    : '',
                                initDateList: selectedDateListData,
                                onChange: (dates) {
                                  var fromDate =
                                      dateFormatter5.format(dates![0]!);
                                  var toDate = dateFormatter5.format(dates[1]!);
                                  context
                                      .read<LinePerformanceCubit>()
                                      .getLinePerformanceData(
                                          merge: true,
                                          scope: ['fi'],
                                          isFiltered: false,
                                          fromDate: fromDate,
                                          toDate: toDate,
                                          assetType: 'pension',
                                          isPerformance: false);
                                  setState(() {
                                    selectedDateListData = dates!;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                              width: double.infinity,
                              height: size.height * .25,
                              child: BlocConsumer<LinePerformanceCubit,
                                  LinePerformanceState>(
                                listener: (context, state) {
                                  if (state is LinePerformanceLoaded) {
                                    lastDayPerformanceSummary.value = state
                                        .linePerformanceModel
                                        .merge
                                        ?.fi
                                        ?.lastDayPerformanceSummary;
                                  }
                                },
                                builder: (context, state) {
                                  if (state is LinePerformanceLoaded) {
                                    return state.data.isNotEmpty
                                        ? WedgeEcharts(
                                            index: 2,
                                            isFiltered: state.isFiltered,
                                            currency: state.baseCurrency,
                                            data: state.data,
                                          )
                                        : Center(
                                            child: Text(
                                                translate!.noDataAvailable));
                                  } else {
                                    return buildCircularProgressIndicator(
                                        width: 20);
                                  }
                                },
                              ))
                          // PerformanceChart(
                          //   chartData: chartData,
                          //   currencyType:
                          //       data.length >= 2 ? data[1][5] : 'INR',
                          // ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   "Pension you’ve added (${state.assets.pensions.length})",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w600, fontSize: kfontMedium),
                      // ),
                      // Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${translate!.pensions} (${state.assets.pensions.length})",
                            style: TitleHelper.h9,
                          ),
                          AppButton(
                              onTap: () async {
                                addPensions(state.assets.pensions);
                              },
                              label: translate!.add)
                        ],
                      ),
                      state.assets.pensions.isNotEmpty
                          ? Column(
                              children: List.generate(
                                  state.assets.pensions.length,
                                  (index) => _exptiles(
                                      state.assets.pensions[index], index)),
                            )
                          // Expanded(
                          //     child: ListView.builder(
                          //         shrinkWrap: true,
                          //         physics: ScrollPhysics(),
                          //         itemCount: state.assets.pensions.length,
                          //         itemBuilder: (BuildContext context, int index) {
                          //           return _exptiles(
                          //               state.assets.pensions[index], index);
                          //         }),
                          //   )
                          : Container(),
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      // AddNewButton(
                      //     text: translate!.addNewPension,
                      //     onTap: () async {
                      //       addPensions(state.assets.pensions);
                      //     })
                    ],
                  ),
                ),
              );
            } else if (state is PensionMainCubitLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PensionMainCubitError) {
              return Center(
                child: Text(
                  state.errorMsg.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: kfontMedium),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        // bottomNavigationBar: FooterButton(
        //   text: translate!.addOtherAssets,
        //   onTap: () async {
        //     refreshMainState(context: context, isAsset: true);
        //     Navigator.pop(context);
        //     // final result = await Navigator.push(
        //     //     context,
        //     //     CupertinoPageRoute(
        //     //         builder: (BuildContext context) => AddAssetsPage()));
        //     // if (result != null) {
        //     //   context.read<PensionMaincubitCubit>().getPensionsData();
        //     //   setState(() {});
        //     // }
        //   },
        // ),
      ),
    );
  }

  bool isDeleting = false;

  Widget _exptiles(PensionsEntity data, int index) {
    // Logic to get mortages
    bool isHoxton = data.source.toString().toLowerCase() == "hoxton";
    if (data.source.toString().toLowerCase() == 'manual') {
      return WedgeExpansionTile(
        leading: Image.asset(
          "assets/icons/persoanlLoanMainContainer.png",
          height: 40,
          width: 40,
        ),
        index: index,
        margin: const EdgeInsets.only(bottom: 0, top: 18),
        padding: const EdgeInsets.symmetric(vertical: 6),
        isFromHoxton: isHoxton,
        isFromYodlee: isHoxton == true
            ? false
            : data.source.toString().toLowerCase() != "manual",
        leftSubtitle: data.pensionType,
        leftSubtitleStyle: SubtitleHelper.h11,
        leftTitle: data.name,
        leftTitleStyle: TitleHelper.h10.copyWith(color: Colors.black),
        rightSubTitle: 'Manual',
        rightSubtitleStyle: SubtitleHelper.h11,
        midWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isHoxton
              ? Row(
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
                          translate!.value,
                          style: SubtitleHelper.h11,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          data.policyNumber == ""
                              ? "Nil"
                              : "${data.policyNumber} ",
                          style: SubtitleHelper.h11,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "${data.currentValue.currency} ${numberFormat.format(data.currentValue.amount)}",
                          style: SubtitleHelper.h11,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ],
                )
              : data.pensionType == "Defined Contribution"
                  ? Row(
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
                              translate!.monthlyContribution,
                              style: SubtitleHelper.h11,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              translate!.averageAnnualGrowthRate,
                              style: SubtitleHelper.h11,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              data.policyNumber == ""
                                  ? "Nil"
                                  : "${data.policyNumber} ",
                              style: SubtitleHelper.h11,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "${data.monthlyContributionAmount.currency} ${numberFormat.format(data.monthlyContributionAmount.amount)}",
                              style: SubtitleHelper.h11,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "${data.averageAnnualGrowthRate}",
                              style: SubtitleHelper.h11,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
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
                              translate!.annualIncomeinRetirement,
                              style: SubtitleHelper.h11,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              translate!.retirementAge,
                              style: SubtitleHelper.h11,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              data.policyNumber == ""
                                  ? "Nil"
                                  : data.policyNumber,
                              style: SubtitleHelper.h11,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "${data.annualIncomeAfterRetirement.currency} ${numberFormat.format(data.annualIncomeAfterRetirement.amount)}",
                              style: SubtitleHelper.h11,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "${data.retirementAge}",
                              style: SubtitleHelper.h11,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      ],
                    ),
        ),
        onDeletePressed: isDeleting
            ? null
            : isHoxton
                ? null
                : () {
                    locator.get<WedgeDialog>().confirm(
                        context,
                        WedgeConfirmDialog(
                            title: translate!.areYouSure,
                            subtitle:
                                data.source.toString().toLowerCase() == 'manual'
                                    ? translate!.remeberMoreAccurateMessage
                                    : data.source.toLowerCase() ==
                                            AggregatorProvider.Saltedge.name
                                                .toLowerCase()
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
                                  .read<PensionMaincubitCubit>()
                                  .deletePension(data.id);
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
            : isHoxton
                ? null
                : () async {
                    var _result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => AddPensionManualPage(
                                  assetData: data,
                                )));
                    if (_result != null) {
                      context.read<PensionMaincubitCubit>().getPensionsData();
                      setState(() {});
                      // }
                    }
                  },
        rightTitleStyle: TitleHelper.h10.copyWith(color: Colors.black),
        rightTitle: data.pensionType == "Defined Contribution" ||
                data.source.toString().toLowerCase() == "hoxton"
            ? '${data.currentValue.currency} ${data.currentValue.amount}'
            : '${data.annualIncomeAfterRetirement.currency} ${data.annualIncomeAfterRetirement.amount}',
      );
    } else {
      return ListTileInvestment(
        source: data.source.toString().toLowerCase(),
        leading: ClipRRect(
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
        ),
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => YourPensionsMain(
                        pensionsEntity: data,
                      )));
        },
        title: data.name,
        trailing: data.pensionType == "Defined Contribution" ||
                data.source.toString().toLowerCase() == "hoxton"
            ? '${data.currentValue.currency} ${data.currentValue.amount}'
            : '${data.annualIncomeAfterRetirement.currency} ${data.annualIncomeAfterRetirement.amount}',
        subTitle: data.pensionType,
        saltedgeData: data,
      );
    }
  }
}

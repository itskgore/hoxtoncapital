import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/dashboard_entity.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/widgets/dialog/dashboard_value_card.dart';
import 'package:wedge/features/assets/invesntment/investment_main/presentation/pages/add_investment_main_page.dart';
import 'package:wedge/features/assets/pension/pension_main/presentation/pages/pension_main_page.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/presentation/widgets/theme_echarts.dart';
import 'package:wedge/features/home/presentation/widgets/sub_widgets/section_titlebar.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/utils/wedge_func_methods.dart';
import '../../../../core/widgets/dialog/custom_dialog.dart';
import '../../../../dependency_injection.dart';
import '../../../assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import '../../../assets/invesntment/add_investment_manual/presentation/pages/add_investment_manual_page.dart';
import '../../../assets/pension/add_pension_manual/presentation/pages/add_pension_manual_page.dart';

class InvestmentPerformance extends StatefulWidget {
  DashboardDataEntity dashboardDataEntity;
  Function onComplete;

  InvestmentPerformance(
      {Key? key, required this.dashboardDataEntity, required this.onComplete})
      : super(key: key);

  @override
  _InvestmentPerformanceState createState() => _InvestmentPerformanceState();
}

class _InvestmentPerformanceState extends State<InvestmentPerformance> {
  bool chartLoaded = false;

  changeLoadingState(bool val) {
    setState(() {
      chartLoaded = val;
    });
  }

  @override
  void initState() {
    manipulateData();
    super.initState();
  }

  dynamic _webController;

  @override
  Widget build(BuildContext context) {
    bool isPensionsEmpty =
        widget.dashboardDataEntity.data.pensions.details.isEmpty;
    bool isInvestmentsEmpty =
        widget.dashboardDataEntity.data.investments.details.isEmpty;
    return Container(
        padding: const EdgeInsets.only(top: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitleBarHome(
              title: translate!.pensionAndInvestment,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              Jiffy.parse(widget.dashboardDataEntity.data.asAt).fromNow(),
              style: const TextStyle(
                  fontSize: kfontSmall,
                  color: Color(
                    0xfff4F4F4F,
                  ),
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: true,
              child: Column(
                children: [
                  DashboardValueCard(
                    isFromHome: true,
                    mainValue:
                        "${widget.dashboardDataEntity.data.baseCurrency} ${numberFormat.format(widget.dashboardDataEntity.data.pensions.totalValue + widget.dashboardDataEntity.data.investments.totalValue)}",
                    mainTitle: "${translate!.total} ${translate!.value}",
                    leftValue:
                        "${isPensionsEmpty ? translate!.add : translate!.view} ${translate!.pensions} >>",
                    leftTitle:
                        "${widget.dashboardDataEntity.data.baseCurrency} ${numberFormat.format(widget.dashboardDataEntity.data.pensions.totalValue)}",
                    onLeftTitleClicked: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => widget.dashboardDataEntity.data
                                      .pensions.totalValue ==
                                  0
                              ? AddBankAccountPage(
                                  isAppBar: true,
                                  successPopUp: (_,
                                      {required String source}) async {
                                    if (_) {
                                      // success
                                      await RootApplicationAccess()
                                          .storeAssets();
                                      await RootApplicationAccess()
                                          .storeLiabilities();
                                      locator.get<WedgeDialog>().success(
                                          context: context,
                                          title: translate
                                                  ?.accountLinkedSuccessfully ??
                                              "",
                                          info: getPopUpDescription(source),
                                          buttonLabel:
                                              translate?.continueWord ?? "",
                                          onClicked: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            setState(() {});
                                            Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            PensionMainPage()))
                                                .then((value) {
                                              widget.onComplete();
                                            });
                                          });
                                    } else {
                                      // exited
                                      Navigator.pop(context);
                                    }
                                  },
                                  subtitle: translate!
                                      .orSelectFromthePensionProvidersBelow,
                                  manualAddButtonAction: () async {
                                    final data =
                                        await Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        AddPensionManualPage()))
                                            .then((value) {
                                      widget.onComplete();
                                    });
                                    // resetState();
                                  },
                                  manualAddButtonTitle: translate!.addManually,
                                  placeholder:
                                      translate!.searchYourPensionProvider,
                                  title:
                                      "${translate!.add} ${translate!.pensions}",
                                )
                              : PensionMainPage(),
                        ),
                      ).then((value) {
                        widget.onComplete();
                      });
                    },
                    rightTitle:
                        "${widget.dashboardDataEntity.data.baseCurrency} ${numberFormat.format(widget.dashboardDataEntity.data.investments.totalValue)}",
                    rightvalue:
                        "${isInvestmentsEmpty ? translate!.add : translate!.view} ${translate!.investments} >>",
                    onRightTitleClicked: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => isInvestmentsEmpty
                              ? AddBankAccountPage(
                                  isAppBar: true,
                                  successPopUp: (_,
                                      {required String source}) async {
                                    if (_) {
                                      // success
                                      await RootApplicationAccess()
                                          .storeAssets();
                                      await RootApplicationAccess()
                                          .storeLiabilities();
                                      locator.get<WedgeDialog>().success(
                                          context: context,
                                          title: translate
                                                  ?.accountLinkedSuccessfully ??
                                              "",
                                          info: getPopUpDescription(source),
                                          buttonLabel:
                                              translate?.continueWord ?? "",
                                          onClicked: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            setState(() {});
                                            Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            InvestmentsMainPage()))
                                                .then((value) {
                                              widget.onComplete();
                                            });
                                          });
                                    } else {
                                      // exited
                                      Navigator.pop(context);
                                    }
                                  },
                                  subtitle:
                                      translate!.orSelectFromTheBrokersBelow,
                                  manualAddButtonAction: () async {
                                    final data = await Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    AddInvestmentManualPage()))
                                        .then((value) {
                                      widget.onComplete();
                                    });
                                  },
                                  manualAddButtonTitle: translate!.addManually,
                                  placeholder:
                                      translate!.addInvestmentPlatforms,
                                  title: translate!.addInvestmentPlatforms,
                                )
                              : InvestmentsMainPage(),
                        ),
                      ).then((value) {
                        widget.onComplete();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SectionTitleBarHome(
                      title: translate!.performance, onTap: null),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 300,
                    color: kBackgroundColor,
                    child: Stack(
                      children: [
                        Echarts(
                            reloadAfterInit: true,
                            onLoad: (_) {
                              // log(_);
                              // _.reload();
                              if (_webController == null) {
                                _webController = _;
                                _.reload();
                              }
                              changeLoadingState(true);
                            },
                            onWebResourceError: (_, e) {
                              // log(e.toString());
                            },
                            theme: 'dark',
                            extensions: [darkThemeScript],
                            extraScript: '''
                    chart.on('click', (params) => {
                      if(params.componentType === 'series') {
                        Messager.postMessage(JSON.stringify({
                          type: 'select',
                          payload: params.dataIndex,
                        }));
                      }
                    });
                  ''',
                            option: '''
            
                   {
                     
                     tooltip: {
                      trigger: "axis",
            formatter:(params) => {
                        const month = ["January","February","March","April","May","June","July","August","September","October","November","December"];
                        const d = new Date(Number(params[0].name));
                        return  '<b>' + '${widget.dashboardDataEntity.data.baseCurrency} ' + params[0].value.toLocaleString('en-US', { currency: '${widget.dashboardDataEntity.data.baseCurrency}' }) + '</b><br> '+  d.getUTCDate() + " " + month[d.getUTCMonth()] + " " +  d.getUTCFullYear()  ;
 
                        },
                    },
                     grid: {
                      left: "3%",
                      right: "4%",
                      bottom: "3%",
                      containLabel: true,
                       height: '90%',
                      
                    },
                    xAxis: {
                      type: "category",
                       axisLabel: { 
                          formatter: function xFormatter(value, index) {
                                  var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                                  const month = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
                                  const d = new Date(value);
                                  return (new Date(Number(value))).getUTCDate();
                        },
                       },
                      boundaryGap: false,
                      data: ${jsonEncode(getLast6Montths())},
                      nameTextStyle: {
                      color: "rgba(0, 0, 0, 1)"
                    }
                    },
                    yAxis: {
                      type: 'value',
                       axisLabel: {
                      formatter: function xFormatter(value, index) {
                        return  Math.abs(value) > 999 ? Math.sign(value)*((Math.abs(value)/1000).toFixed(1)) + 'k' : Math.sign(value)*Math.abs(value)
                          
                        },
                    }
                  },
                  axisLabel: {
                    color: "#${darken(appThemeColors!.disableText!, .0).value.toRadixString(16).substring(2, 8)}",
                    fontWeight: "lighter"
                  },
                    series: {
                      name: "Performance",
                      type: "line",
                      itemStyle: {
                          color: '#${darken(appThemeColors!.charts!.lineCharts!.line!, .0).value.toRadixString(16).substring(2, 8)}'
                      },
                      stack: "Total",
                      smooth: true,
                      data: ${jsonEncode(listOfValue())},
                    }
            }
            
            '''),
                        chartLoaded
                            ? Container()
                            : buildCircularProgressIndicator()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  List manipulatedData = [];

  List<DateTime> getMonthsInYear() {
    final dates = <DateTime>[];
    final now = DateTime.now();
    DateTime date = DateTime.now().subtract(const Duration(days: 152));
    final sixMonthFromNow = DateTime(date.year, date.month + 6);

    while (date.isBefore(sixMonthFromNow)) {
      dates.add(date);
      date = DateTime(date.year, date.month + 1);
    }
    return dates;
  }

  List<int> datesNum = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
  ];
  int index = 0;
  dynamic dataDummy;

  manipulateData() {
    // manipulatedData.clear();
    manipulatedData.clear();
    final date = DateTime.now();
    // log(Jiffy.now().subtract(months: 1).dateTime);
    DateTime firstDayOfMonth = Jiffy.now().subtract(months: 1).dateTime;
    // DateTime.utc(DateTime.now().year, Jiffy.now().subtract(months: 6).month, 1);

    DateTime lastDayOfWeek = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(const Duration(days: 1));
    widget.dashboardDataEntity.data.performaces.forEach((element) {
      if (DateTime.fromMillisecondsSinceEpoch(element.date * 1000)
          .toUtc()
          .isAfter(firstDayOfMonth)) {
        manipulatedData.add([
          element.date,
          element.totalPensionsValue + element.totalInvestmentValue
        ]);
      }
    });
    manipulatedData.sort((a, b) {
      DateTime aDate = DateTime.fromMillisecondsSinceEpoch(a[0] * 1000).toUtc();
      DateTime bDate = DateTime.fromMillisecondsSinceEpoch(b[0] * 1000).toUtc();
      return aDate.compareTo(bDate);
    });
    return manipulatedData;
  }

  List<int> getLast6Montths() {
    final dates = <int>[];
    manipulateData().forEach((element) {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(element[0] * 1000).toUtc();
      if (date.month == 1) {
        dates.add(element[0] * 1000);
      } else if (date.month == 2) {
        dates.add(element[0] * 1000);
      } else if (date.month == 3) {
        dates.add(element[0] * 1000);
      } else if (date.month == 4) {
        dates.add(element[0] * 1000);
      } else if (date.month == 5) {
        dates.add(element[0] * 1000);
      } else if (date.month == 6) {
        dates.add(element[0] * 1000);
      } else if (date.month == 7) {
        dates.add(element[0] * 1000);
      } else if (date.month == 8) {
        dates.add(element[0] * 1000);
      } else if (date.month == 9) {
        dates.add(element[0] * 1000);
      } else if (date.month == 10) {
        dates.add(element[0] * 1000);
      } else if (date.month == 11) {
        dates.add(element[0] * 1000);
      } else if (date.month == 12) {
        dates.add(element[0] * 1000);
      }
    });
    return dates;
  }

  List<num> listOfValue() {
    List<num> value = [];
    manipulateData().forEach((element) {
      value.add(element[1]);
    });

    return value;
  }
}

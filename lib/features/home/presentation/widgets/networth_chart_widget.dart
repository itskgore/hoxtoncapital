import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/enums.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/dashboard_entity.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/presentation/widgets/theme_echarts.dart';

import '../../../../core/widgets/buttons/app_button.dart';
import '../../../all_accounts_types/presentation/pages/all_account_types.dart';

class NetworthChart extends StatefulWidget {
  DashboardDataEntity dashboardDataEntity;

  NetworthChart({Key? key, required this.dashboardDataEntity})
      : super(key: key);

  @override
  _NetworthChartState createState() => _NetworthChartState();
}

class _NetworthChartState extends State<NetworthChart> {
  dynamic _webController;

  bool chartLoaded = false;

  changeLoadingState(bool val) {
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        chartLoaded = val;
      });
    });
  }

  FILTER currentFilter = FILTER.Month;

  changeFilter(FILTER filter) {
    setState(() {
      currentFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.dashboardDataEntity.data.performaces.isEmpty
        ? Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            spacing: 15,
            children: [
              const SizedBox(height: 25),
              SvgPicture.asset(
                "assets/placeholders/Layer 1.svg",
                height: 90,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Text(
                  "No data available",
                  style: TitleHelper.h11.copyWith(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Text(
                  "Add assets and liabilities to view your overall Net worth.",
                  style: SubtitleHelper.h12.copyWith(color: Colors.white),
                ),
              ),
              FittedBox(
                child: AppButton(
                  color: appThemeColors!.disableDark,
                  textColor: appThemeColors!.primary,
                  label: "Add assets & liabilities",
                  style:
                      TitleHelper.h12.copyWith(color: appThemeColors!.primary),
                  borderRadius: 4,
                  verticalPadding: 8,
                  onTap: () {
                    Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const AllAccountTypes()))
                        .then((value) {});
                  },
                ),
              ),
            ],
          )
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                  colors: appThemeColors!.gradient!),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                            translateStrings(context)!.netWorthPerformance,
                            style: TitleHelper.h11
                                .copyWith(color: appThemeColors!.textLight)),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                changeFilter(FILTER.Week);
                              },
                              child: _chartButtons(
                                  translateStrings(context)!.week,
                                  currentFilter == FILTER.Week)),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                              onTap: () {
                                changeFilter(FILTER.Month);
                              },
                              child: _chartButtons(
                                  translateStrings(context)!.month,
                                  currentFilter == FILTER.Month)),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                              onTap: () {
                                changeFilter(FILTER.Year);
                              },
                              child: _chartButtons(
                                  translateStrings(context)!.year,
                                  currentFilter == FILTER.Year)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: 250,
                      child: Echarts(
                          reloadAfterInit: true,
                          onLoad: (_) {
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
                          extensions: [apphemeScript],
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
                            const d = new Date(params[0].name);
                            if(${checkHasSingleMonth()}) {
                                return  `
                                     <b>`+ '${widget.dashboardDataEntity.data.baseCurrency} ' + params[0].value[1].toLocaleString('en-US', { currency: '${widget.dashboardDataEntity.data.baseCurrency}' }) +  `</b><br>` + d.getDate() + " " + month[d.getUTCMonth()] + " " +  d.getUTCFullYear()
                            }else {
                                  return  `
                                     <b>`+ '${widget.dashboardDataEntity.data.baseCurrency} ' + params[0].value[1].toLocaleString('en-US', {  currency: '${widget.dashboardDataEntity.data.baseCurrency}' }) +  `</b><br>` + d.getDate() + " " + month[d.getMonth()] + " " +  d.getFullYear()
                            }
                                                       
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
                 type:  "${currentFilter == FILTER.Year ? checkHasSingleMonth() ? "category" : "time" : "category"}",
                 minInterval: ${checkHasSingleMonth() ? '1000 * 24 * 60 * 60 * 1' : '1000 * 24 * 60 * 60 * 30'} ,
                 axisLabel: { 
                 showMinLabel: true,
                 showMaxLabel: ${currentFilter == FILTER.Year ? "false" : "true"},
                 hideOverlap: true,
                 formatter: function xFormatter(value, index) {
                                if(${currentFilter == FILTER.Year}) {
                                      const month = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
                                      const d = new Date(value);
                                      // if(index == 0) {
                                      //   return "";
                                      // }else {
                                        if(${checkHasSingleMonth()}) {
                                          return (new Date(Number(value))).getDate() +'-'+ month[(new Date(Number(value))).getMonth()];
                                        }else {
                                          return month[(new Date(Number(value))).getMonth()];
                                        }
                                      // }
                                }else if(${currentFilter == FILTER.Month}) {
                                  var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                                      const month = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
                                      const d = new Date(value);
                                      return (new Date(Number(value))).getUTCDate();
                                }else {
                                      var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                                      const month = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
                                      const d = new Date(value);
                                      return days[(new Date(Number(value))).getUTCDay()];
                                }
                             },

                 },
                boundaryGap: true,
                nameTextStyle: {
                color: "rgba(0, 0, 0, 1)"
              }
              },
              yAxis: {
                type: 'value',
                min: function (value) {
                    return value.min - (value.min < 0 ? ((value.min * -1) * 0.05) : ((value.min) * 0.05));
                  },
                max: function (value) {
                    return value.max + (value.max * 0.05);
                  },
                 axisLabel: {
                formatter: function xFormatter(value, index) {
                  return Intl.NumberFormat('en-US', {currency: '${widget.dashboardDataEntity.data.baseCurrency}', maximumSignificantDigits: 3,notation: "compact",compactDisplay: "short" }).format(value)
                  },
              }
        },
        axisLabel: {
              color: "#${darken(appThemeColors!.textLight!, .3).value.toRadixString(16).substring(2, 8)}",
              fontWeight: "500"
        },
              series: {
                type: 'line',
                datasetId: 'currentYear',
                showSymbol: ${currentFilter == FILTER.Week ? true : false},
                symbol: 'circle',
                symbolSize: 6,
                smooth: true,
                stack: "Total",
                 itemStyle: {
                  color: "#${darken(appThemeColors!.charts!.lineCharts!.mainChartLineColor!, .0).value.toRadixString(16).substring(2, 8)}"
                },
                data: ${jsonEncode(getSeries())},
              }
}

'''),
                    ),
                    chartLoaded
                        ? Container()
                        : buildCircularProgressIndicator(width: 60)
                  ],
                ),
              ],
            ),
          );
  }

  List<String> dates = [];
  List manipulatedData = [];

  bool checkHasSingleMonth() {
    if (currentFilter == FILTER.Year) {
      if (DateTime.fromMillisecondsSinceEpoch(getCurrentYear()[0][0]).month ==
          DateTime.fromMillisecondsSinceEpoch(
                  getCurrentYear()[getCurrentYear().length - 1][0])
              .month) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  getSeries() {
    if (currentFilter == FILTER.Year) {
      List<Map<String, dynamic>> data = [];
      List<Map<String, dynamic>> years = [];

      getCurrentYear().forEach((element) {
        data.add({
          "name": dateFormatter
              .format(DateTime.fromMillisecondsSinceEpoch(element[0])),
          "value": [element[0], element[1]],
        });
      });
      return data;
    } else if (currentFilter == FILTER.Month) {
      List<Map<String, dynamic>> data = [];
      getCurrentMonth().forEach((element) {
        data.add({
          "name": dateFormatter.format(
              DateTime.fromMillisecondsSinceEpoch(element[0] * 1000).toUtc()),
          "value": [element[0] * 1000, element[1]],
        });
      });

      return data;
    } else {
      List<Map<String, dynamic>> data = [];
      getCurrentWeek().forEach((element) {
        data.add({
          "name": dateFormatter.format(
              DateTime.fromMillisecondsSinceEpoch(element[0] * 1000).toUtc()),
          "value": [element[0] * 1000, element[1]],
        });
      });
      return data;
    }
  }

  List getCurrentWeek() {
    manipulatedData.clear();
    final date = DateTime.now();
    DateTime firstDayOfWeek = Jiffy.now().subtract(days: 6).dateTime;
    DateTime lastDayOfWeek =
        getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
    for (var element in widget.dashboardDataEntity.data.performaces) {
      // log(
      //     "DATE: ${DateTime.fromMillisecondsSinceEpoch(element.date * 1000).toUtc()}");
      if (DateTime.fromMillisecondsSinceEpoch(element.date * 1000)
          .toUtc()
          .isAfter(firstDayOfWeek)) {
        manipulatedData.add([element.date, element.networth]);
      }
    }
    manipulatedData.sort((a, b) {
      DateTime aDate = DateTime.fromMillisecondsSinceEpoch(a[0] * 1000).toUtc();
      DateTime bDate = DateTime.fromMillisecondsSinceEpoch(b[0] * 1000).toUtc();
      return aDate.compareTo(bDate);
    });
    return manipulatedData;
  }

  List getCurrentMonth() {
    manipulatedData.clear();

    DateTime firstDayOfMonth = Jiffy.now().subtract(months: 1).dateTime;

    DateTime lastDayOfWeek = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(const Duration(days: 1));
    for (var element in widget.dashboardDataEntity.data.performaces) {
      if (DateTime.fromMillisecondsSinceEpoch(element.date * 1000)
          .toUtc()
          .isAfter(firstDayOfMonth)) {
        manipulatedData.add([element.date, element.networth]);
      }
    }
    manipulatedData.sort((a, b) {
      DateTime aDate = DateTime.fromMillisecondsSinceEpoch(a[0] * 1000).toUtc();
      DateTime bDate = DateTime.fromMillisecondsSinceEpoch(b[0] * 1000).toUtc();
      return aDate.compareTo(bDate);
    });
    return manipulatedData;
  }

  List getCurrentYear() {
    manipulatedData.clear();
    final date = DateTime.now();
    DateTime firstDayOfYear = Jiffy.now().subtract(years: 1).dateTime;
    List<dynamic> tryb = [];
    widget.dashboardDataEntity.data.performaces.forEach((element) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(element.date * 1000).toUtc();
      String date = dateFormatter5.format(dateTime);
      int parsedDate = DateTime.parse("${date} 00:00:00")
          .millisecondsSinceEpoch; // 2022-07-22 00:00:00
      DateTime lastDate = (dateTime.month < 12)
          ? DateTime(dateTime.year, dateTime.month + 1, 0)
          : DateTime(dateTime.year + 1, 1, 0);
      if (dateTime.isAfter(firstDayOfYear)) {
        if (dateTime.year == DateTime.now().year &&
            dateTime.month == DateTime.now().month) {
          if (dateTime.day <= DateTime.now().day) {
            tryb.add([parsedDate, element.networth]);
          }
        }

        if (!dateTime.isAfter(DateTime.now())) {
          // if (lastDate.day == dateTime.day) {
          manipulatedData.add([parsedDate, element.networth]);
          // }
        }
      }
    });

    manipulatedData.sort((a, b) {
      DateTime aDate = DateTime.fromMillisecondsSinceEpoch(a[0] * 1000).toUtc();
      DateTime bDate = DateTime.fromMillisecondsSinceEpoch(b[0] * 1000).toUtc();
      return aDate.compareTo(bDate);
    });

    return manipulatedData;
  }

  getCurrentWeekDates() {
    dates.clear();
    getCurrentWeek().forEach((element) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(element[0] * 1000).toUtc();
      dates.add(dateTime.toIso8601String());
    });
    return dates;
  }

  getCurrentMonthsDates() {
    dates.clear();
    getCurrentMonth().forEach((element) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(element[0] * 1000).toUtc();
      dates.add(dateTime.toIso8601String());
    });
    return dates;
  }

  getCurrentYearDates() {
    dates.clear();
    getCurrentYear().forEach((element) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(element[0] * 1000).toUtc();
      dates.add(dateTime.toIso8601String());
    });
    return dates;
  }

  List<num> getNetWorths() {
    List<num> value = [];
    if (currentFilter == FILTER.Month) {
      getCurrentMonth().forEach((element) {
        value.add(element[1]);
      });
    } else if (currentFilter == FILTER.Year) {
      getCurrentYear().forEach((element) {
        value.add(element[1]);
      });
    } else {
      getCurrentWeek().forEach((element) {
        value.add(element[1]);
      });
    }
    return value;
  }

  List<String> getDatesData() {
    List<String> value = [];

    if (currentFilter == FILTER.Month) {
      getCurrentMonthsDates().forEach((element) {
        value.add(element);
      });
    } else if (currentFilter == FILTER.Year) {
      getCurrentYearDates().forEach((element) {
        value.add(element);
      });
    } else {
      getCurrentWeekDates().forEach((element) {
        value.add(element);
      });
    }
    return value;
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Widget _chartButtons(title, isActive) {
    if (isActive) {
      return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black26, borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              title,
              style:
                  SubtitleHelper.h12.copyWith(color: appThemeColors!.textLight),
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            title,
            style: SubtitleHelper.h12
                .copyWith(color: darken(appThemeColors!.textLight!, .3)),
          ),
        ),
      );
    }
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

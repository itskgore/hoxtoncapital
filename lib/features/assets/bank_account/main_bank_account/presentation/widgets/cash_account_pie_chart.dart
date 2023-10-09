import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/contants/string_contants.dart';
import '../../../../../../core/contants/theme_contants.dart';
import '../../../../../../core/utils/wedge_colors.dart';
import '../../data/model/cash_account_pie_performance_model.dart';

class CashAccountPieGraph extends StatefulWidget {
  final List<CashAccountPiePerformanceModel> pieChartData;
  final String? date;
  final String? currencyType;

  const CashAccountPieGraph(
      {Key? key, required this.pieChartData, this.date, this.currencyType})
      : super(key: key);

  @override
  State<CashAccountPieGraph> createState() => _CashAccountPieGraphState();
}

class _CashAccountPieGraphState extends State<CashAccountPieGraph> {
  int touchedIndex = -1;
  List pieChartsData = [];

  List<PieChartSectionData> getPieChartSection(
          List<CashAccountPiePerformanceModel> data) =>
      data
          .asMap()
          .map<int, PieChartSectionData>((index, value) {
            double getPieChartValue({required double currentValue}) {
              var totalValue = 0.0;
              for (int i = 0; i < data.length; i++) {
                totalValue += double.parse("${data[i].value}");
              }
              var persistent = double.parse(
                  ((currentValue / totalValue) * 100).toStringAsFixed(2));
              return persistent;
            }

            final isTouched = index == touchedIndex;
            final fontSize = isTouched ? 20.0 : 11.0;
            final radius = isTouched ? 52.0 : 45.0;

            Color getPieChartColor(int index) {
              if (index > 18) {
                index = (index - 18).round();
                getPieChartColor(index);
              }
              return PieChatColors.color[index];
            }

            String pieDate =
                dateFormatter14.format(DateTime.parse("${widget.date}"));

            //piaSectionData
            final value = PieChartSectionData(
              title: '',
              showTitle: false,
              radius: radius,
              color: getPieChartColor(index),
              badgePositionPercentageOffset: -1,
              value: getPieChartValue(currentValue: data[index].value ?? 0),
              badgeWidget: Visibility(
                visible: (index == touchedIndex),
                child: FittedBox(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 4),
                                blurRadius: 8)
                          ]),
                      child: Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data[index].category}",
                            style: SubtitleHelper.h12.copyWith(fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "${widget.currencyType} ${data[index].value?.toStringAsFixed(2)} ",
                            style: TitleHelper.h12.copyWith(fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            pieDate,
                            style: SubtitleHelper.h12.copyWith(fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ))),
                ),
              ),
            );
            return MapEntry(index, value);
          })
          .values
          .toList();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double pieChartRadius = height < 700
        ? 45
        : height < 800
            ? 50
            : 60;
    return PieChart(
      swapAnimationDuration: const Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear,
      PieChartData(
        sections: widget.pieChartData.isEmpty
            ? [
                PieChartSectionData(
                    color: Colors.grey.withOpacity(.3),
                    radius: 45,
                    showTitle: false)
              ]
            : getPieChartSection(widget.pieChartData),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: pieChartRadius,
        pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
          setState(() {
            final desiredTouch =
                pieTouchResponse.touchInput is! PointerExitEvent &&
                    pieTouchResponse.touchInput is! PointerUpEvent;
            if (desiredTouch && pieTouchResponse.touchedSection != null) {
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;

              if (pieTouchResponse.touchedSection!.touchedSectionIndex == -1) {
                for (int i = 0; i < pieChartsData.length; i++) {
                  if (pieChartsData[i] != 0.0) {
                    touchedIndex = i;
                  }
                }
              }
            } else {
              touchedIndex = -1;
            }
          });
        }),
      ),
    );
  }
}

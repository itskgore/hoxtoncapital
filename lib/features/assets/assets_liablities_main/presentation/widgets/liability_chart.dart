import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/entities/liabilities_summary_entity.dart';

class LiabilityPieChart extends StatefulWidget {
  final summery;

  const LiabilityPieChart(this.summery, {super.key});

  @override
  State<StatefulWidget> createState() => _LiabPieChart();
}

class _LiabPieChart extends State<LiabilityPieChart> {
  int touchedIndex = -1;
  List pieChartsData = [];

  List<Color> chartColors = [
    appThemeColors!.charts!.liabilties!.mortgages!,
    appThemeColors!.charts!.liabilties!.creditCards!,
    appThemeColors!.charts!.liabilties!.vehicleLoans!,
    appThemeColors!.charts!.liabilties!.personLoans!,
    appThemeColors!.charts!.liabilties!.customLiabilities!
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.35,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        final desiredTouch =
                            pieTouchResponse.touchInput is! PointerExitEvent &&
                                pieTouchResponse.touchInput is! PointerUpEvent;
                        if (desiredTouch &&
                            pieTouchResponse.touchedSection != null) {
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;

                          if (pieTouchResponse
                                  .touchedSection!.touchedSectionIndex ==
                              -1) {
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
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 80,
                    sections: showingSections(widget.summery)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(LiabilitiesSummaryEnitity summery) {
    List pieChartData = [];
    List _data = [];
    List _titles = [
      "Mortgages",
      "Credit Cards",
      "Vehicle Loans",
      "Personal Loans",
      "Custom Liabilities"
    ];

    pieChartData.add(summery.mortgages.amount);
    pieChartData.add(summery.creditCards.amount);
    pieChartData.add(summery.vehicleLoans.amount);
    pieChartData.add(summery.personalLoans.amount);
    pieChartData.add(summery.otherLiabilities.amount);

    for (int i = 0; i < pieChartData.length; i++) {
      if (pieChartData[i] != 0) {
        var value = (pieChartData[i] / summery.total.amount) * 100;
        _data.add(value);
      } else {
        _data.add(0.0);
      }
    }
    pieChartsData = _data;

    return List.generate(_data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: chartColors[i],
        value: _data[i],
        showTitle: false,
        badgePositionPercentageOffset: -0.5,
        badgeWidget: Visibility(
          visible: (i == touchedIndex),
          child: Container(
              height: 35,
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${_data[i].round()}%",
                    style: const TextStyle(
                        fontSize: 8.0, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${_titles[i]}",
                    style: const TextStyle(fontSize: 8.0),
                  ),
                ],
              ))),
        ),
        title: '',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff)),
      );
    });
  }
}

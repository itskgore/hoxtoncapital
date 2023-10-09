import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/entities/assets_entity.dart';

class AssetsLiabilityPieChart extends StatefulWidget {
  final summery;

  const AssetsLiabilityPieChart(this.summery, {super.key});

  @override
  State<StatefulWidget> createState() => _AssetPieChart();
}

class _AssetPieChart extends State<AssetsLiabilityPieChart> {
  int touchedIndex = -1;
  List pieChartsData = [];

  List<Color> chartColors = [
    appThemeColors!.charts!.assets!.cashAccount!,
    appThemeColors!.charts!.assets!.properties!,
    appThemeColors!.charts!.assets!.vehicles!,
    appThemeColors!.charts!.assets!.investment!,
    appThemeColors!.charts!.assets!.pensions!,
    appThemeColors!.charts!.assets!.crypto!,
    appThemeColors!.charts!.assets!.stocks!,
    appThemeColors!.charts!.assets!.customAssets!
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
                          ;
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

  List<PieChartSectionData> showingSections(AssetSummaryEntity summery) {
    List pieChartData = [];
    List data = [];
    List titles = [
      "Cash Accounts",
      "properties",
      "Vehicles",
      "Investments",
      "Pensions",
      "Crypto",
      "Stocks",
      "Custom Assets"
    ];

    pieChartData.add(summery.bankAccounts.amount);
    pieChartData.add(summery.properties.amount);
    pieChartData.add(summery.vehicles.amount);
    pieChartData.add(summery.investments.amount);
    pieChartData.add(summery.pensions.amount);
    pieChartData.add(summery.cryptoCurrencies.amount);
    pieChartData.add(summery.stocksBonds.amount);
    pieChartData.add(summery.otherAssets.amount);

    for (int i = 0; i < pieChartData.length; i++) {
      if (pieChartData[i] != 0.0) {
        var value = (pieChartData[i] / summery.total.amount) * 100;
        data.add(value);
      } else {
        data.add(0.0);
      }
    }
    pieChartsData = data;

    // print(_data);

    // pieChartData.add(summery.pensions.amount);

    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: chartColors[i],
        value: data[i],
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
                    "${data[i].round()}%",
                    style: const TextStyle(
                        fontSize: 8.0, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${titles[i]}",
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

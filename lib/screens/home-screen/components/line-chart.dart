import 'package:flutter/material.dart';
import 'package:hoxtoncapital/models/performance-data.dart';
import 'package:hoxtoncapital/providers/performance-data-pro.dart';
import 'package:hoxtoncapital/utils/constants.dart';

import 'package:hoxtoncapital/utils/text_helper.dart';
import 'package:hoxtoncapital/widgets/generic_text.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpLineChart extends StatefulWidget {
  SpLineChart({Key key}) : super(key: key);

  @override
  _SpLineChartState createState() => _SpLineChartState();
}

class _SpLineChartState extends State<SpLineChart> {
  getCharData(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1), () {});
    final pro = Provider.of<PerformanceDataProvider>(context, listen: false);
    pro.getPerformanceData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
        create: (_) => PerformanceDataProvider(),
        lazy: true,
        builder: (context, _) {
          return FutureBuilder(
              future: getCharData(context),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? buildShimmerContainer(theme, context)
                    : Consumer<PerformanceDataProvider>(
                        builder: (context, pro, _) {
                        return Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: SfCartesianChart(
                                plotAreaBackgroundColor:
                                    theme.buttonColor.withOpacity(0.05),
                                enableAxisAnimation: true,
                                plotAreaBorderColor: theme.buttonColor,
                                crosshairBehavior: CrosshairBehavior(
                                    enable: true,
                                    activationMode: ActivationMode.singleTap,
                                    lineWidth: 1,
                                    shouldAlwaysShow: false,
                                    hideDelay: 10,
                                    lineType: CrosshairLineType.both,
                                    lineDashArray: [2.2, 2.3],
                                    lineColor: theme.buttonColor),
                                primaryXAxis: CategoryAxis(
                                  plotOffset: 0,
                                  rangePadding: ChartRangePadding.none,
                                  majorTickLines: MajorTickLines(size: 10),
                                  plotBands: [
                                    PlotBand(
                                        isVisible: true,
                                        start: pro.startPlotIndex,
                                        end: pro.endPlotIndex,
                                        isRepeatable: true,
                                        opacity: 0.2,
                                        color: theme.buttonColor,
                                        shouldRenderAboveSeries: true),
                                  ],
                                  arrangeByIndex: true,
                                  minimum: 0,
                                  maximum: PerformanceDataProvider.of(context,
                                              listen: false)
                                          .performanceData
                                          .length
                                          .toDouble() -
                                      1,
                                  //  data.length.toDouble() - 1,
                                  tickPosition: TickPosition.inside,
                                  majorGridLines: MajorGridLines(
                                    color: theme.buttonColor.withOpacity(0.1),
                                    width: 1,
                                  ),
                                  placeLabelsNearAxisLine: true,
                                  minorTickLines: MinorTickLines(width: 0),
                                ),
                                legend: Legend(isVisible: true),
                                primaryYAxis: NumericAxis(
                                  rangePadding: ChartRangePadding.auto,
                                  decimalPlaces: 1,
                                  majorGridLines: MajorGridLines(width: 0),
                                ),
                                tooltipBehavior: TooltipBehavior(
                                  enable: true,
                                  borderWidth: 0,
                                  elevation: 10,
                                  color: theme.backgroundColor,
                                  canShowMarker: true,
                                  builder: (dynamic data,
                                      dynamic point,
                                      dynamic series,
                                      int pointIndex,
                                      int seriesIndex) {
                                    return Card(
                                      child: Container(
                                          padding: EdgeInsets.all(15),
                                          color: theme.backgroundColor,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GenericText(
                                                title:
                                                    "${data.sales.toString()}",
                                                textStyle: TextHelper.h3,
                                              ),
                                              buildWidthBoxNormal(context, 5),
                                              GenericText(
                                                title: "additional text",
                                                textStyle: TextHelper.h5,
                                              ),
                                            ],
                                          )),
                                    );
                                  },
                                ),
                                plotAreaBorderWidth: 0,
                                borderWidth: 0,
                                margin: EdgeInsets.all(0),
                                enableSideBySideSeriesPlacement: true,
                                series: <ChartSeries>[
                                  SplineSeries<PerformanceData, String>(
                                      dataSource: pro.performanceData,
                                      onPointTap: (index) {
                                        pro.changePlotColors(index.pointIndex);
                                      },
                                      pointColorMapper: (SalesData, int) =>
                                          theme.focusColor,
                                      splineType: SplineType.natural,
                                      markerSettings: MarkerSettings(
                                          isVisible: true,
                                          height: 5,
                                          width: 5,
                                          shape: DataMarkerType.circle,
                                          borderWidth: 1,
                                          color: theme.focusColor,
                                          borderColor: Colors.black),
                                      enableTooltip: true,
                                      color: theme.focusColor,
                                      animationDelay: 1.0,
                                      animationDuration: 2200,
                                      isVisibleInLegend: false,
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: false),
                                      xValueMapper:
                                          (PerformanceData sales, _) =>
                                              sales.year,
                                      yValueMapper:
                                          (PerformanceData sales, _) =>
                                              sales.sales)
                                ]));
                      });
              });
        });
  }
}

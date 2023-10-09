// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Line chart example
import 'dart:convert';

// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/user_preferences_model.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/calculators/retirement_calculator/cubit/chart_tool_tip_cubit.dart';

class CalculatorChart extends StatefulWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  const CalculatorChart(this.seriesList, {super.key, this.animate = false});

  @override
  State<CalculatorChart> createState() => _CalculatorChartState();
}

class _CalculatorChartState extends State<CalculatorChart> {
  @override
  void initState() {
    getCurrency();
    super.initState();
  }

  String currency = "";

  getCurrency() async {
    final result = await locator<SharedPreferences>()
        .getString(RootApplicationAccess.userPreferences);
    final data = UserPreferencesModel.fromJson(json.decode(result!));
    // setState(() {
    currency = data.preference.currency;
    // });
    //  data.
  }

  @override
  Widget build(BuildContext context) {
    // final staticTicks = <charts.TickSpec<double>>[
    //   new charts.TickSpec(log(50)),
    //   new charts.TickSpec(log(60)),
    //   new charts.TickSpec(log(70)),
    //   new charts.TickSpec(log(80)),
    //   new charts.TickSpec(log(90)),
    //   new charts.TickSpec(log(100)),
    // ];
    final simpleCurrencyFormatter =
        charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            NumberFormat.compact());
    return Stack(
      children: [
        GestureDetector(
          onTapDown: (TapDownDetails details) {},
          child: charts.LineChart(
            widget.seriesList,
            primaryMeasureAxis: charts.NumericAxisSpec(
              tickFormatterSpec: simpleCurrencyFormatter,
              tickProviderSpec: const charts.BasicNumericTickProviderSpec(
                zeroBound: false,
                dataIsInWholeNumbers: false,
                // desiredTickCount: MyDimens.chart_desired_tick_count,
              ),
            ),
            defaultInteractions: true,
            behaviors: [
              charts.LinePointHighlighter(
                drawFollowLinesAcrossChart: true,
                showHorizontalFollowLine:
                    charts.LinePointHighlighterFollowLineType.nearest,
              ),
            ],
            selectionModels: [
              charts.SelectionModelConfig(
                  type: charts.SelectionModelType.info,
                  changedListener: (charts.SelectionModel model) {
                    if (model.hasDatumSelection) {
                      // print(model.selectedSeries[0]
                      //     .domainFn(model.selectedDatum[0].index));

                      final currentPath = widget.seriesList[1].data
                          .where((element) =>
                              element.age ==
                              model.selectedSeries[0]
                                  .domainFn(model.selectedDatum[0].index))
                          .toList();
                      final recommended = widget.seriesList[0].data
                          .where((element) =>
                              element.age ==
                              model.selectedSeries[0]
                                  .domainFn(model.selectedDatum[0].index))
                          .toList();
                      if (currentPath.isNotEmpty && recommended.isNotEmpty) {
                        context.read<ChartToolTipCubit>().changePosition(
                            currentPathData: currentPath[0].balance,
                            recommendedData: recommended[0].balance,
                            age: recommended[0].age);
                      }
                    }
                  })
            ],
            animate: widget.animate,
            defaultRenderer: new charts.LineRendererConfig(
              includePoints: false,
              stacked: false,
              includeArea: true,
            ),
            // domainAxis: charts.NumericAxisSpec(
            //   tickProviderSpec:
            //       charts.StaticNumericTickProviderSpec(staticTicks),
            //   tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
            //       (measure) => exp(9).round().toString()),
            // ),
          ),
        ),
        BlocBuilder<ChartToolTipCubit, ChartToolTipState>(
          builder: (context, state) {
            if (state is ChartToolTipLoading) {
              return Container();
            } else if (state is ChartToolTipLoaded) {
              return Positioned(
                left: 40,
                top: 10,
                child: Container(
                    // width: 10,
                    padding: const EdgeInsets.only(right: 20),
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white60,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "SAVINGS AT AGE ${state.age}",
                              style: SubtitleHelper.h11
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.circle,
                              color: appThemeColors!
                                  .charts!.calculatorCharts!.recommended,
                              size: 10,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              " ${numberFormat.format(state.recommended)}",
                              style: TitleHelper.h11.copyWith(),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.circle,
                              color: appThemeColors!
                                  .charts!.calculatorCharts!.currentPath,
                              size: 10,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              " ${numberFormat.format(state.currentPath)}",
                              style: TitleHelper.h11,
                            )
                          ],
                        )
                      ],
                    )),
              );
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    final RenderObject? box = context.findRenderObject();
    final Offset localOffset = details.globalPosition;
    posx = localOffset.dx;
    posy = localOffset.dy;
  }

  double posx = 100.0;
  double posy = 100.0;
}

/// Sample linear data type.
class LinearSales {
  final int age;
  final double balance;

  LinearSales(this.age, this.balance);
}

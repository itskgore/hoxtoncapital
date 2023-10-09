import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/enums.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/data_models/user_preferences_model.dart';
import 'package:wedge/core/entities/asset_liabilities_charts_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/aggregation_results/domain/usecase/getAggregationResults.dart';

part 'aggregation_result_state.dart';

class AggregationResultCubit extends Cubit<AggregationResultState> {
  final GetAggregationResultUsecase getAggregationResultUsecase;

  AggregationResultCubit(this.getAggregationResultUsecase)
      : super(AggregationResultInitial());
  late AssetLiabilitiesChartEntity assetLiabilitiesChartEntity;

  getAggregationResults(
      {required AggregationChartType chartType,
      required List<String> yearFilter,
      required List<Map<String, dynamic>> modelIDs,
      required bool isHoldings}) {
    emit(AggregationResultLoading());
    final data = getAggregationResultUsecase(yearFilter);
    data.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getAggregationResults(
              chartType: chartType,
              modelIDs: modelIDs,
              yearFilter: yearFilter,
              isHoldings: isHoldings);
        } else {
          emit(AggregationResultError(l.displayErrorMessage()));
        }
      }, (r) {
        assetLiabilitiesChartEntity = r;
        filterData(
            showTotal: true,
            chartType: chartType,
            modelIDs: modelIDs,
            assetLiabilitiesChartEntity: r,
            yearFilter: yearFilter,
            isHoldings: isHoldings);
        emit(AggregationResultLoaded(modelIds: const [
          {'id': 'all', 'name': 'All'}
        ], assetLiabilitiesChartEntity: r, series: series));
      });
    });
  }

  List<ChartSummaryEntity> summarydata = [];
  List<dynamic> performancedata = [];
  List<dynamic> performanceSummaydata = [];
  List<Map<String, dynamic>> series = [];
  List<String> selectedData = [];

  List<Map<String, dynamic>> getTotalSeriesData() {
    List<Map<String, dynamic>> seriesData = [];
    final result = locator<SharedPreferences>()
        .getString(RootApplicationAccess.userPreferences);
    final user = UserPreferencesModel.fromJson(json.decode(result!));
    DateTime firstDayOfWeek = Jiffy.now().subtract(days: 6).dateTime;
    for (var element in performanceSummaydata) {
      if (isNumericUsingRegularExpression(element[0].toString())) {
        if (DateTime.fromMillisecondsSinceEpoch(element[0] * 1000)
            .toUtc()
            .isAfter(firstDayOfWeek)) {
          seriesData.add({
            "value1": user.preference.currency,
            "value2": dateFormatter2
                .format(DateTime.fromMillisecondsSinceEpoch(element[0] * 1000)),
            "name":
                "Total, ${dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(element[0] * 1000))}",
            "value": [
              element[0] * 1000,
              element[2],
            ]
          });
        }
      }
    }
    return seriesData;
  }

  List<Map<String, dynamic>> getSeriesData(
      ChartSummaryEntity data, int valueIndex) {
    List<Map<String, dynamic>> seriesData = [];
    final result = locator<SharedPreferences>()
        .getString(RootApplicationAccess.userPreferences);
    final user = UserPreferencesModel.fromJson(json.decode(result!));
    DateTime firstDayOfWeek = Jiffy.now().subtract(days: 6).dateTime;
    for (var element in performancedata) {
      if (data.id == element[2]) {
        if (isNumericUsingRegularExpression(element[0].toString())) {
          if (DateTime.fromMillisecondsSinceEpoch(element[0] * 1000)
              .toUtc()
              .isAfter(firstDayOfWeek)) {
            seriesData.add({
              "value1": user.preference.currency,
              "value2": dateFormatter2.format(
                  DateTime.fromMillisecondsSinceEpoch(element[0] * 1000)),
              "name":
                  "${data.name}, ${dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(element[0] * 1000))}",
              "value": [
                element[0] * 1000,
                element[valueIndex],
              ]
            });
          }
        }
      }
    }
    return seriesData;
  }

  filterSingleData({
    required AggregationChartType chartType,
    required AssetLiabilitiesChartEntity assetLiabilitiesChartEntity,
    required List<String> yearFilter,
    required List<Map<String, dynamic>> modelIDs,
    required bool isHoldings,
    required bool showOnlyAll,
  }) async {
    emit(AggregationResultLoading());
    bool showTotal = true;
    showTotal =
        modelIDs.where((element) => element['id'] == 'total').toList().isEmpty;

    filterData(
        chartType: chartType,
        showTotal: !showTotal,
        modelIDs: modelIDs,
        assetLiabilitiesChartEntity: assetLiabilitiesChartEntity,
        yearFilter: yearFilter,
        isHoldings: isHoldings);
    emit(AggregationResultLoaded(
        modelIds: showOnlyAll
            ? [
                {'id': 'all', 'name': 'All'}
              ]
            : modelIDs,
        assetLiabilitiesChartEntity: assetLiabilitiesChartEntity,
        series: series));
  }

  filterData(
      {required AggregationChartType chartType,
      required AssetLiabilitiesChartEntity assetLiabilitiesChartEntity,
      required List<String> yearFilter,
      required List<Map<String, dynamic>> modelIDs,
      required bool isHoldings,
      required bool showTotal}) async {
    summarydata.clear();
    performancedata.clear();
    performanceSummaydata.clear();
    series.clear();
    if (chartType == AggregationChartType.Investment) {
      if (isHoldings) {
        for (var element in assetLiabilitiesChartEntity.yearData) {
          for (var e in element.holdingsChartData.summary) {
            for (var ids in modelIDs) {
              if (e.id == ids['id']) {
                summarydata.add(e);
              }
            }
          }
        }
        for (var element in assetLiabilitiesChartEntity.yearData) {
          for (var e in element.holdingsChartData.performance) {
            for (var ids in modelIDs) {
              if (e[2] == ids['id']) {
                performancedata.add(e);
              }
            }
          }
        }
        // print(performancedata);
        for (var data in summarydata) {
          series.add({
            "type": 'line',
            "name": data.name,
            "datasetId": 'currentYear',
            "showSymbol": true,
            "symbol": 'circle',
            "symbolSize": 5,
            "smooth": true,
            "seriesLayoutBy": "row",
            "emphasis": {"focus": "series"},
            "data": getSeriesData(data, 8)
          });
        }
        if (showTotal) {
          for (var element in assetLiabilitiesChartEntity.yearData) {
            for (var e in element.financialChartData.performanceSummary) {
              if (e[1] == 'investment') {
                performanceSummaydata.add(e);
              }
            }
          }
          series.add({
            "type": 'line',
            "name": "Total",
            "datasetId": 'currentYear',
            "showSymbol": true,
            "symbol": 'circle',
            "symbolSize": 5,
            "smooth": true,
            "seriesLayoutBy": "row",
            "emphasis": {"focus": "series"},
            "data": getTotalSeriesData()
          });
        }
      } else {
        for (var element in assetLiabilitiesChartEntity.yearData) {
          for (var e in element.financialChartData.summary) {
            for (var ids in modelIDs) {
              if (e.id == ids['id']) {
                summarydata.add(e);
              }
            }
          }
        }

        for (var element in assetLiabilitiesChartEntity.yearData) {
          for (var e in element.financialChartData.performance) {
            for (var ids in modelIDs) {
              if (e[2] == ids['id']) {
                performancedata.add(e);
              }
            }
          }
        }

        for (var data in summarydata) {
          series.add({
            "type": 'line',
            "name": data.name,
            "datasetId": 'currentYear',
            "showSymbol": true,
            "symbol": 'circle',
            "symbolSize": 5,
            "smooth": true,
            "seriesLayoutBy": "row",
            "emphasis": {"focus": "series"},
            "data": getSeriesData(data, 7)
          });
        }
        if (showTotal) {
          for (var element in assetLiabilitiesChartEntity.yearData) {
            for (var e in element.financialChartData.performanceSummary) {
              if (e[1] == 'investment') {
                performanceSummaydata.add(e);
              }
            }
          }
          series.add({
            "type": 'line',
            "name": "Total",
            "datasetId": 'currentYear',
            "showSymbol": true,
            "symbol": 'circle',
            "symbolSize": 5,
            "smooth": true,
            "seriesLayoutBy": "row",
            "emphasis": {"focus": "series"},
            "data": getTotalSeriesData()
          });
        }
      }
    }
  }
}

bool isNumericUsingRegularExpression(String string) {
  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

  return numericRegex.hasMatch(string);
}

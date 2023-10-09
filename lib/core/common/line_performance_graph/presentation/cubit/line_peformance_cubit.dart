import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/entities/assets_entity.dart';

import '../../../../error/failures.dart';
import '../../data/model/line_performance_model.dart';
import '../../domain/repository/line_Performance_graph_repository.dart';
import 'line_performance_state.dart';

class LinePerformanceCubit extends Cubit<LinePerformanceState> {
  final GetLinePerformance getLinePerformance;
  late LinePerformanceModel performanceDate;
  List manipulatedData = [];
  List? performanceData;
  String currency = "USD";
  dynamic performanceAPIData;
  AssetsEntity? dataPIData;
  LinePerformanceCubit({
    required this.getLinePerformance,
  }) : super(LinePerformanceInitial());
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

  getLinePerformanceData({
    required bool merge,
    required List scope,
    required String fromDate,
    required bool isFiltered,
    required String toDate,
    required String assetType,
    required bool isPerformance,
    String? id,
  }) {
    emit(LinePerformanceLoading());
    final result = getLinePerformance({
      "merge": merge,
      'scope': scope,
      "fromDate": fromDate,
      "toDate": toDate,
      "id": id,
      "assetType": assetType
    });
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getLinePerformanceData(
              id: id,
              scope: scope,
              isFiltered: isFiltered,
              fromDate: fromDate,
              toDate: toDate,
              merge: merge,
              isPerformance: isPerformance,
              assetType: assetType);
        } else {
          emit(LinePerformanceError(l.displayErrorMessage()));
        }
      }, (r) {
        performanceDate = r;
        var data = r.merge!.fi != null
            ? isPerformance
                ? r.merge!.fi!.performance!
                : r.merge!.fi!.performanceSummary!
            : [];
        manipulateData(
          data,
          isCombinedGraph: true,
        );
        emit(LinePerformanceLoaded(
            baseCurrency: r.merge?.fi?.baseCurrency ?? "INR",
            linePerformanceModel: r,
            data: data,
            isFiltered: isFiltered));
      });
    });
  }

  int index = 0;
  dynamic dataDummy;
  manipulateData(List<dynamic> performance,
      {DateTime? startDate, DateTime? endDate, required bool isCombinedGraph}) {
    index = 0;
    if (performance.isNotEmpty) {
      performance.removeAt(0);
      for (var e in performance) {
        e[0] = DateTime.fromMillisecondsSinceEpoch(e[0] * 1000).toUtc();
        manipulatedData.add([e[0], isCombinedGraph ? e[2] : e[8]]);
      }
    }

    return manipulatedData;
  }

  List getCurrentYear(
      {DateTime? startDate, DateTime? endDate, required bool isCombined}) {
    manipulatedData.clear();
    if (performanceAPIData.isNotEmpty) {
      performanceAPIData.removeAt(0);
      for (var e in performanceAPIData) {
        if (e[0].isAfter(startDate) && e[0].isBefore(endDate)) {
          manipulatedData.add([e[0], isCombined ? e[2] : e[8]]);
        }
      }
    }

    return manipulatedData;
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wedge/core/entities/assets_entity.dart';

import '../../../../../../../core/error/failures.dart';
import '../../data/models/crypto_performance_model.dart';
import '../../domain/usecase/get_crypto_usecase.dart';
import 'crypto_performance_state.dart';

class CryptoPerformanceCubit extends Cubit<CryptoPerformanceState> {
  final GetCryptoPerformance getCryptoPerformance;
  late CryptoPerformanceModel performanceDate;
  List manipulatedData = [];
  List? performanceData;
  String currency = "USD";
  dynamic performanceAPIData;
  AssetsEntity? dataPIData;

  CryptoPerformanceCubit({
    required this.getCryptoPerformance,
  }) : super(CryptoPerformanceInitial());

  getCryptoPerformanceData(
      {required bool merge,
      required List scope,
      required String fromDate,
      required String toDate,
      required bool combinedGraph,
      required bool isFiltered,
      String? assetType,
      String? id}) {
    emit(CryptoPerformanceLoading());
    final result = getCryptoPerformance({
      "merge": merge,
      'scope': scope,
      "fromDate": fromDate,
      "toDate": toDate,
      "assetType": assetType,
      "id": id
    });
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getCryptoPerformanceData(
              assetType: assetType,
              scope: scope,
              combinedGraph: combinedGraph,
              fromDate: fromDate,
              isFiltered: isFiltered,
              toDate: toDate,
              merge: merge);
        } else {
          emit(CryptoPerformanceError(l.displayErrorMessage()));
        }
      }, (r) {
        performanceDate = r;
        var data = [];
        if (combinedGraph) {
          data = r.merge!.fi!.performanceSummary!;
        } else {
          data = r.merge!.fi!.performance!;
        }

        manipulateData(data, isCombinedGraph: combinedGraph);

        performanceDate = r;
        emit(CryptoPerformanceLoaded(
            data: data,
            isFiltered: isFiltered,
            pensionPerformanceModel: r,
            baseCurrency: combinedGraph
                ? r.merge?.fi?.baseCurrency
                : (data.length > 1 ? data[1][5] : r.merge?.fi?.baseCurrency)));
      });
    });
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

  manipulateData(List<dynamic> performance,
      {DateTime? startDate, DateTime? endDate, required bool isCombinedGraph}) {
    List<dynamic> trya = [];
    index = 0;
    if (performance.isNotEmpty) {
      performance.removeAt(0);
      for (var e in performance) {
        e[0] = DateTime.fromMillisecondsSinceEpoch(e[0] * 1000);
        var lastDayDateTime = (e[0].month < 12)
            ? DateTime(e[0].year, e[0].month + 1, 0)
            : DateTime(e[0].year + 1, 1, 0);
        if (e[0].year == DateTime.now().year &&
            e[0].month == DateTime.now().month) {
          if (e[0].day <= DateTime.now().day) {
            trya.add(e);
          }
        }
        if (!e[0].isAfter(DateTime.now())) {
          if (!e[0].isBefore(Jiffy.now().subtract(months: 5).dateTime)) {
            if (lastDayDateTime.day == e[0].day) {
              manipulatedData.add([e[0], isCombinedGraph ? e[2] : e[8]]);
            } else {
              if (datesNum.where((dd) => dd == e[0].day).toList().isNotEmpty) {
                int i = index;
                DateTime plusOne = e[0].add(Duration(days: 1));
                if (datesNum.where((qq) => qq == e[0].day).toList().isEmpty) {}
              }
            }
          }
        }
      }
      if (trya.isNotEmpty) {
        manipulatedData.add([
          trya[trya.length - 1][0],
          isCombinedGraph ? trya[trya.length - 1][2] : trya[trya.length - 1][8]
        ]);
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

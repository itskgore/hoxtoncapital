import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/features/your_investments/presentation/cubit/your_investment_performance_state.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/Investment_performance_model.dart';
import '../../domain/usecases/get_holdings.dart';

class YourInvestmentPerformanceCubit
    extends Cubit<YourInvestmentPerformanceState> {
  final GetInvestmentPerformance getInvestmentPerformance;
  late InvestmentPerformanceModel performanceDate;
  List manipulatedData = [];
  List? performanceData;
  String currency = "USD";
  dynamic performanceAPIData;
  AssetsEntity? dataPIData;

  YourInvestmentPerformanceCubit({
    required this.getInvestmentPerformance,
  }) : super(YourInvestmentPerformanceInitial());

  getInvestmentPerformanceData(
      {required bool merge,
      required List scope,
      required bool isFiltered,
      required String fromDate,
      required String toDate,
      required String id}) {
    emit(YourInvestmentPerformanceLoading());
    final result = getInvestmentPerformance({
      "merge": merge,
      'scope': scope,
      "fromDate": fromDate,
      "toDate": toDate,
      "id": id
    });
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getInvestmentPerformanceData(
              id: id,
              scope: scope,
              isFiltered: isFiltered,
              fromDate: fromDate,
              toDate: toDate,
              merge: merge);
        } else {
          emit(YourInvestmentPerformanceError(l.displayErrorMessage()));
        }
      }, (r) {
        var data = r.merge!.fi != null ? r.merge!.fi!.performance! : [];
        manipulateData(
          data,
        );
        performanceDate = r;
        emit(YourInvestmentPerformanceLoaded(
            investmentPerformanceModel: r, data: data, isFiltered: isFiltered));
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
      {DateTime? startDate, DateTime? endDate}) {
    List<dynamic> trya = [];
    index = 0;
    if (performance.isNotEmpty) {
      performance.removeAt(0);
      for (var e in performance) {
        e[0] = DateTime.fromMillisecondsSinceEpoch(e[0] * 1000).toUtc();
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
              manipulatedData.add([e[0], e[8]]);
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
        manipulatedData
            .add([trya[trya.length - 1][0], trya[trya.length - 1][8]]);
      }
    }

    return manipulatedData;
  }

  List getCurrentYear({DateTime? startDate, DateTime? endDate}) {
    manipulatedData.clear();
    if (performanceAPIData.isNotEmpty) {
      performanceAPIData.removeAt(0);
      for (var e in performanceAPIData) {
        if (e[0].isAfter(startDate) && e[0].isBefore(endDate)) {
          manipulatedData.add([e[0], e[8]]);
        }
      }
    }

    return manipulatedData;
  }
}

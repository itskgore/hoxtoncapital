import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/data_models/user_preferences_model.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/domain/usecases/get_insights.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/domain/usecases/get_pension_investment_main.dart';

part 'pension_investment_main_state.dart';

class PensionInvestmentMainCubit extends Cubit<PensionInvestmentMainState> {
  final GetMainPensionInvestments getMainPensionInvestments;
  final GetMainPensionInvestmentsInsights getMainPensionInvestmentsInsights;

  PensionInvestmentMainCubit(
      {required this.getMainPensionInvestments,
      required this.getMainPensionInvestmentsInsights})
      : super(PensionInvestmentMainInitial());

  List manipulatedData = [];
  AssetsEntity? dataPIData;
  List? performanceData;
  String currency = "USD";

  dynamic performanceAPIData;

  getData({DateTime? startDate, DateTime? endDate}) {
    manipulatedData.clear();
    emit(PensionInvestmentMainLoading());

    final result0 = getMainPensionInvestments(NoParams());
    final resultInsights = getMainPensionInvestmentsInsights(NoParams());

    result0.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(PensionInvestmentMainError(failure.displayErrorMessage()));
        }
      },
          //if success
          (PIdata) {
        resultInsights.then((value) {
          value.fold(
              //if failed
              (failure) {
            if (failure is TokenExpired) {
              getData();
            } else {
              emit(PensionInvestmentMainError(failure.displayErrorMessage()));
            }
          },
              //if success
              (data) async {
            manipulateData(data);
            final result =  locator<SharedPreferences>()
                .getString(RootApplicationAccess.userPreferences);
            if (result != null) {
              final data = UserPreferencesModel.fromJson(json.decode(result));
              currency = data.preference.currency;
            }
            performanceAPIData = data;
            dataPIData = PIdata;
            refreshData(endDate: endDate, startDate: startDate);
            emit(PensionInvestmentMainLoaded(
                isFiltered: false,
                currency: currency,
                data: PIdata,
                performanceAPIData: data,
                performanceData: manipulatedData));
          });
        });
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
    // List<dynamic> trya = [];
    index = 0;
    if (performance.isNotEmpty) {
      performance.removeAt(0);
      for (var e in performance) {
        e[0] = DateTime.fromMillisecondsSinceEpoch(e[0] * 1000).toUtc();
        manipulatedData.add([e[0], e[2]]);
      }
    }

    return manipulatedData;
  }

  refreshData({DateTime? startDate, DateTime? endDate}) {
    final data = getCurrentYear(endDate: endDate, startDate: startDate);
    emit(PensionInvestmentMainLoading());
    emit(PensionInvestmentMainLoaded(
        data: dataPIData!,
        isFiltered: true,
        currency: currency,
        performanceData: data,
        performanceAPIData: performanceAPIData));
  }

  List getCurrentYear({DateTime? startDate, DateTime? endDate}) {
    manipulatedData.clear();
    if (performanceAPIData.isNotEmpty) {
      if (performanceAPIData[0] is String) {
        performanceAPIData.removeAt(0);
      }
      performanceAPIData[performanceAPIData.length - 1][0].isBefore(endDate);
      for (var e in performanceAPIData) {
        if (e[0].isAfter(startDate) && e[0].isBefore(endDate)) {
          manipulatedData.add([e[0], e[2]]);
        } else if (getDateTimeOnly(datetime: e[0]) == startDate ||
            getDateTimeOnly(datetime: e[0]) == endDate) {
          manipulatedData.add([e[0], e[2]]);
        }
      }
    }
    return manipulatedData;
  }
}

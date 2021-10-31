import 'package:flutter/material.dart';
import 'package:hoxtoncapital/models/performance-data.dart';
import 'package:provider/provider.dart';

class PerformanceDataProvider with ChangeNotifier {
  static PerformanceDataProvider of(BuildContext context,
      {bool listen = false}) {
    return Provider.of<PerformanceDataProvider>(context, listen: listen);
  }

// SPline Chart Data
  List<PerformanceData> _performanceData = [];
  List<PerformanceData> get performanceData {
    return _performanceData ?? [];
  }

  double startPlotIndex = -1;
  double endPlotIndex = 0.5;

  void changePlotColors(int index) {
    startPlotIndex = 0;
    endPlotIndex = 0;
    startPlotIndex = index == 0 ? -1 : index - 1 + .5;
    endPlotIndex = index == 0 ? 0.5 : index + .5;
    notifyListeners();
  }

  getPerformanceData() {
    if (_performanceData.isEmpty) {
      _performanceData.addAll([
        PerformanceData('JAN', 50),
        PerformanceData('FEB', 250),
        PerformanceData('MAR', 100),
        PerformanceData('APR', 200),
        PerformanceData('MAY', 190),
        PerformanceData('JUN', 220),
      ]);
      final data = _performanceData.reduce(
          (value, element) => value.sales > element.sales ? value : element);
      changePlotColors(_performanceData.indexOf(data));
    }
  }
}

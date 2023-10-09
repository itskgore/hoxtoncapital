import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chart_tool_tip_state.dart';

class ChartToolTipCubit extends Cubit<ChartToolTipState> {
  ChartToolTipCubit() : super(ChartToolTipInitial());

  changePosition(
      {required double recommendedData,
      required double currentPathData,
      required int age}) {
    emit(ChartToolTipLoading());
    emit(ChartToolTipLoaded(
        recommended: recommendedData, currentPath: currentPathData, age: age));
  }
}

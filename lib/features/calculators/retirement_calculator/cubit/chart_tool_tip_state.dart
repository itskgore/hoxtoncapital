part of 'chart_tool_tip_cubit.dart';

@immutable
abstract class ChartToolTipState {}

class ChartToolTipInitial extends ChartToolTipState {
  double posx = 30;
  double posy = 30;
}

class ChartToolTipLoading extends ChartToolTipState {}

class ChartToolTipLoaded extends ChartToolTipState {
  final double recommended;
  final double currentPath;
  final int age;

//loaded
  ChartToolTipLoaded(
      {required this.recommended,
      required this.currentPath,
      required this.age});
}

part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardDataEntity data;
  ChartType chartType = ChartType.Week;

  DashboardLoaded({required this.data, this.chartType = ChartType.Week});
}

class DashboardError extends DashboardState {
  final String error;

  DashboardError({required this.error});
}

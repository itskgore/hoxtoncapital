part of 'pension_report_cubit.dart';

abstract class PensionReportRecordsState extends Equatable {
  const PensionReportRecordsState();

  @override
  List<Object> get props => [];
}

class PensionReportRecordsInitial extends PensionReportRecordsState {}

class PensionReportRecordsLoading extends PensionReportRecordsState {}

class PensionReportRecordsLoaded extends PensionReportRecordsState {
  final PensionReportEntity data;

  PensionReportRecordsLoaded({
    required this.data,
  });
}

class PensionReportRecordsError extends PensionReportRecordsState {
  final String error;

  PensionReportRecordsError({required this.error});
}

part of 'servicedocuments_cubit.dart';

abstract class ServiceDocumentsState extends Equatable {
  const ServiceDocumentsState();

  @override
  List<Object> get props => [];
}

class ServiceDocumentsInitial extends ServiceDocumentsState {}

class ServiceDocumentsLoading extends ServiceDocumentsState {}

class ServiceDocumentsLoaded extends ServiceDocumentsState {
  final UserDocumentRecordsEntity data;
  final bool downloaded;
  final List<DocumentRecordsEntity> folders;
  final List<DocumentRecordsEntity> files;

  ServiceDocumentsLoaded(
      {required this.data,
      required this.downloaded,
      required this.files,
      required this.folders});
}

class ServiceDocumentsError extends ServiceDocumentsState {
  final String error;

  ServiceDocumentsError({required this.error});
}

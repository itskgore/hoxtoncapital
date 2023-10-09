part of 'getservices_cubit.dart';

abstract class GetservicesState extends Equatable {
  const GetservicesState();

  @override
  List<Object> get props => [];
}

class GetservicesInitial extends GetservicesState {}

class GetservicesLoding extends GetservicesState {}

class GetservicesLoaded extends GetservicesState {
  final UserServicesEntity data;

  GetservicesLoaded({required this.data});
}

class GetservicesError extends GetservicesState {}

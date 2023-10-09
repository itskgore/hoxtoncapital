part of 'useradvisor_cubit.dart';

abstract class UseradvisorState extends Equatable {
  const UseradvisorState();

  @override
  List<Object> get props => [];
}

class UseradvisorInitial extends UseradvisorState {}

class UseradvisorLoading extends UseradvisorState {}

class UseradvisorLoaded extends UseradvisorState {
  final List<Map<String, dynamic>> userAdvisor;

  // final List<String> htmlString;
  // final String image;
  UseradvisorLoaded({
    required this.userAdvisor,
  });
}

class UseradvisorError extends UseradvisorState {
  final String error;

  UseradvisorError({required this.error});
}

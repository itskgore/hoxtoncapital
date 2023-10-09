abstract class PersonalDetailsState {}

class PersonalDetailsInitial extends PersonalDetailsState {}

class PersonalDetailsLoading extends PersonalDetailsState {}

class PersonalDetailsError extends PersonalDetailsState {
  final String errorMsg;

  PersonalDetailsError(this.errorMsg);
}

class PersonalDetailsLoaded extends PersonalDetailsState {
  final dynamic personDetailsModel;

  PersonalDetailsLoaded({required this.personDetailsModel});
}

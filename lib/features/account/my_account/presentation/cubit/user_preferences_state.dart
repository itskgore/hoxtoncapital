part of 'user_preferences_cubit.dart';

@immutable
abstract class UserPreferencesState {}

class UserPreferencesInitial extends UserPreferencesState {}

class UserPreferencesLoading extends UserPreferencesState {}

class UserPreferencesLoaded extends UserPreferencesState {
  final UserPreferencesEntity userPreferencesEntity;
  final bool isPreferencesUpdated;

  UserPreferencesLoaded(
      {required this.userPreferencesEntity,
      required this.isPreferencesUpdated});
}

class UserPreferencesError extends UserPreferencesState {
  final String errorMsg;

  UserPreferencesError({required this.errorMsg});
}

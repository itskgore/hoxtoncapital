part of 'properties_cubit.dart';

@immutable
abstract class PropertiesState {}

class PropertiesInitial extends PropertiesState {}

class PropertiesLoading extends PropertiesState {}

class PropertiesUnlink extends PropertiesState {
  PropertiesUnlink({required this.id});

  final String id;
}

class PropertiesLoaded extends PropertiesState {
  final AssetsEntity assets;
  final bool deleteMessageSent;

  PropertiesLoaded({required this.assets, required this.deleteMessageSent});
}

class PropertiesError extends PropertiesState {
  PropertiesError({required this.errorMsg, this.id});

  final String errorMsg;
  String? id;
}

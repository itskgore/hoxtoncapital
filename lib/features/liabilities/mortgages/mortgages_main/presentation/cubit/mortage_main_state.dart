part of 'mortage_main_cubit.dart';

@immutable
abstract class MortageMainState {}

class MortageMainInitial extends MortageMainState {}

class MortageMainLoaded extends MortageMainState {
  MortageMainLoaded({
    required this.liabilitiesEntity,
    required this.showDeleteMsg,
    required this.properties,
  });

  final List<PropertyEntity> properties;
  final LiabilitiesEntity liabilitiesEntity;
  final bool showDeleteMsg;
}

class MortageMainLoading extends MortageMainState {}

class MortageMainUnlinked extends MortageMainState {
  MortageMainUnlinked({required this.id});

  final String id;
}

class MortageMainError extends MortageMainState {
  MortageMainError({required this.errorMsg, this.id});

  String? id;

  final String errorMsg;
}

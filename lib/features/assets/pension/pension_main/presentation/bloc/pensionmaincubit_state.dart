part of 'pensionmaincubit_cubit.dart';

@immutable
abstract class PensionMainCubitState {}

class PensionMainCubitInitial extends PensionMainCubitState {}

class PensionMainCubitLoading extends PensionMainCubitState {}

class PensionMainCubitDelete extends PensionMainCubitState {
  String deleteMsg;
  AssetsEntity assets;

  PensionMainCubitDelete({required this.deleteMsg, required this.assets});
}

class PensionMainCubitLoaded extends PensionMainCubitState {
  PensionMainCubitLoaded({required this.assets, required this.hasDeleted});

  final AssetsEntity assets;
  final bool hasDeleted;
}

class PensionMainCubitError extends PensionMainCubitState {
  PensionMainCubitError({required this.errorMsg});

  final String errorMsg;
}

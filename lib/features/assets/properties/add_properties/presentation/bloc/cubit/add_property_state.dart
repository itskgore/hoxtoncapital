part of 'add_property_cubit.dart';

@immutable
abstract class AddPropertyState {}

class AddPropertyLoading extends AddPropertyState {}

class AddPropertyInitial extends AddPropertyState {
  final status;
  final message;
  final data;

  AddPropertyInitial(
      {required this.status, required this.message, required this.data});
}

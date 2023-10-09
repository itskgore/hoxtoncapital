part of 'main_credit_card_cubit.dart';

@immutable
abstract class MainCreditCardState {}

class MainCreditCardInitial extends MainCreditCardState {}

class MainCreditCardLoading extends MainCreditCardState {}

class MainCreditCardLoaded extends MainCreditCardState {
  MainCreditCardLoaded(
      {required this.liabilitiesEntity, required this.showDeleteSnack});

  final LiabilitiesEntity liabilitiesEntity;
  final bool showDeleteSnack;
}

class MainCreditCardError extends MainCreditCardState {
  MainCreditCardError({required this.errorMsg});

  final String errorMsg;
}

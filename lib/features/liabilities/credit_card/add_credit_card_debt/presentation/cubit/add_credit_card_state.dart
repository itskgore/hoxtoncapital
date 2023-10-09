part of 'add_credit_card_cubit.dart';

@immutable
abstract class AddCreditCardState {}

class AddCreditCardInitial extends AddCreditCardState {}

class AddCreditCardLoading extends AddCreditCardState {}

class AddCreditCardLoaded extends AddCreditCardState {
  AddCreditCardLoaded({required this.cardsEntity});

  final CreditCardsEntity cardsEntity;
}

class AddCreditCardError extends AddCreditCardState {
  AddCreditCardError({required this.errorMsg});

  final String errorMsg;
}

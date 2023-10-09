import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/params/credit_cards_params.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/usecase/add_credit_cards_usecase.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/usecase/update_credit_cads_usecase.dart';

part 'add_credit_card_state.dart';

class AddCreditCardCubit extends Cubit<AddCreditCardState> {
  final AddCreditCardsUsecase addCreditCardsUsecase;
  final UpdateCreditCardsUsecase updateCreditCardsUsecase;

  AddCreditCardCubit(
      {required this.addCreditCardsUsecase,
      required this.updateCreditCardsUsecase})
      : super(AddCreditCardInitial());

  addCreditCard(AddUpdateCreditCardsParams params) {
    final result = addCreditCardsUsecase(params);
    emit(AddCreditCardLoading());

    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          addCreditCard(params);
        } else {
          emit(AddCreditCardError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) => emit(AddCreditCardLoaded(cardsEntity: data)));
    });
  }

  updateCreditCard(AddUpdateCreditCardsParams params) {
    final result = updateCreditCardsUsecase(params);
    emit(AddCreditCardLoading());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          updateCreditCard(params);
        } else {
          emit(AddCreditCardError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) => emit(AddCreditCardLoaded(cardsEntity: data)));
    });
  }
}

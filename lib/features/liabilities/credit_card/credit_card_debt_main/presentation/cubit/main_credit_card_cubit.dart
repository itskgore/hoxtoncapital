import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/common/domain/usecases/refresh_aggregator_usecase.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/domain/repository/credit_card_repository.dart';

part 'main_credit_card_state.dart';

class MainCreditCardCubit extends Cubit<MainCreditCardState> {
  final MainCreditCardRepo mainCreditCardRepo;
  final CommonRefreshAggregatorAccountUseCase
      commonRefreshAgreegatorAccountUsecase;

  MainCreditCardCubit(
      {required this.mainCreditCardRepo,
      required this.commonRefreshAgreegatorAccountUsecase})
      : super(MainCreditCardInitial());
  LiabilitiesEntity? _liabilitiesEntity;

  getCreditCards() {
    emit(MainCreditCardLoading());
    final result = mainCreditCardRepo.getCreditCardsData();
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          getCreditCards();
        } else {
          emit(MainCreditCardError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) {
        _liabilitiesEntity = data;
        emit(MainCreditCardLoaded(
            liabilitiesEntity: data, showDeleteSnack: false));
      });
    });
  }

  deleteCreditCard(DeleteParams params) {
    final result = mainCreditCardRepo.deleteCreditCard(params.id);
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          deleteCreditCard(params);
        } else {
          emit(MainCreditCardError(errorMsg: failure.displayErrorMessage()));
          emit(MainCreditCardLoaded(
              liabilitiesEntity: _liabilitiesEntity!, showDeleteSnack: false));
        }
      }, (data) {
        emit(MainCreditCardLoaded(
            liabilitiesEntity: _liabilitiesEntity!, showDeleteSnack: true));
      });
    });
  }
}

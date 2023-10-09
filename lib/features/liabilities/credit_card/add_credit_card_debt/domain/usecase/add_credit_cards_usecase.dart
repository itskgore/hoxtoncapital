import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/params/credit_cards_params.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/repository/add_update_credit_cards_repo.dart';

class AddCreditCardsUsecase
    extends UseCase<CreditCardsEntity, AddUpdateCreditCardsParams> {
  AddCreditCardsUsecase(this.addUpdateCreditCardsRepo);

  final AddUpdateCreditCardsRepo addUpdateCreditCardsRepo;

  @override
  Future<Either<Failure, CreditCardsEntity>> call(
      AddUpdateCreditCardsParams params) {
    return addUpdateCreditCardsRepo.addCreditCard(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/domain/repository/credit_card_repository.dart';

class DeleteCreditCards implements UseCase<CreditCardsEntity, DeleteParams> {
  DeleteCreditCards(this.mainCreditCardRepo);

  final MainCreditCardRepo mainCreditCardRepo;

  @override
  Future<Either<Failure, CreditCardsEntity>> call(DeleteParams params) {
    return mainCreditCardRepo.deleteCreditCard(params.id);
  }
}

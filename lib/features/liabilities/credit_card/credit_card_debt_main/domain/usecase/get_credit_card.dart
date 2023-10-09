import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/domain/repository/credit_card_repository.dart';

class GetMainCreditCard implements UseCase<LiabilitiesEntity, NoParams> {
  GetMainCreditCard(this.mainCreditCardRepo);

  final MainCreditCardRepo mainCreditCardRepo;

  @override
  Future<Either<Failure, LiabilitiesEntity>> call(NoParams params) {
    return mainCreditCardRepo.getCreditCardsData();
  }
}

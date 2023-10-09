import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/domain/repository/add_manual_pension_repo.dart';

import 'params/add_manual_pension_params.dart';

class AddManualPensionUsecase
    implements UseCase<PensionsEntity, AddManualPensionParams> {
  final AddManualPensionRepo repo;

  AddManualPensionUsecase(this.repo);

  @override
  Future<Either<Failure, PensionsEntity>> call(AddManualPensionParams params) {
    if (params.pensionType == "Defined Benefit") {
      Map<String, dynamic> bodyBenifit = {
        "name": params.name,
        "pensionType": params.pensionType,
        "country": params.country,
        "policyNumber": params.policyNumber,
        "annualIncomeAfterRetirement": {
          "amount": params.annualIncomeAfterRetirement.amount,
          "currency": params.annualIncomeAfterRetirement.currency
        },
        "retirementAge": params.retirementAge
      };
      return repo.addManualPension(bodyBenifit);
    } else {
      Map<String, dynamic> bodyContri = {
        "name": params.name,
        "pensionType": params.pensionType,
        "country": params.country,
        "policyNumber": params.policyNumber,
        "monthlyContributionAmount": {
          "amount": params.monthlyContributionAmount.amount,
          "currency": params.monthlyContributionAmount.currency
        },
        "currentValue": {
          "amount": params.currentValue.amount,
          "currency": params.currentValue.currency
        },
        "averageAnnualGrowthRate": params.averageAnnualGrowthRate
      };
      return repo.addManualPension(bodyContri);
    }
  }
}

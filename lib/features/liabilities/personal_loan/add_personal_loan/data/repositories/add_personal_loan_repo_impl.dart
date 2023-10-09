import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/domain/use_cases/params/add_update_personal_loan.dart';

import '../../../../../../core/data_models/personal_loan_model.dart';
import '../../../../../../core/error/failures.dart';
import '../../domain/repositories/add_personal_loan_repository.dart';
import '../data_sources/add_personal_loan_data_source.dart';

class AddPersonalLoanRepositoryImpl implements AddPersonalLoanRepository {
  AddPersonalLoanRepositoryImpl({required this.addPersonalLoanDataSource});

  final AddPersonalLoanDataSource addPersonalLoanDataSource;

  @override
  Future<Either<Failure, PersonalLoanModel>> addPersonalLoan(
      AddPersonalLoanParams params) async {
    try {
      final verifiedUser =
          await addPersonalLoanDataSource.addPersonalLoanAPI(params);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, PersonalLoanEntity>> updatePersonalLoan(
      AddPersonalLoanParams params) async {
    try {
      final verifiedUser =
          await addPersonalLoanDataSource.upatePersonalLoanAPI(params);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

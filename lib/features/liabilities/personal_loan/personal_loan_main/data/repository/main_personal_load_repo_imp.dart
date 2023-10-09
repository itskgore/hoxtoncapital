import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/data/datasource/local_get_personal_loan.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/data/datasource/remote_personal_loan.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/domain/repository/main_personal_loan_repo.dart';

class MainPersonalLoanRepoImp implements MainPersonalRepository {
  MainPersonalLoanRepoImp(
      {required this.localPersonalLoanDataSource,
      required this.remoteMainPersonalLoanDataSource});

  final LocalPersonalLoanDataSource localPersonalLoanDataSource;
  final RemoteMainPersonalLoanDataSource remoteMainPersonalLoanDataSource;

  @override
  Future<Either<Failure, PersonalLoanEntity>> deletePersonalLoan(
      String id) async {
    try {
      final result =
          await remoteMainPersonalLoanDataSource.deletePersonalLoan(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, LiabilitiesEntity>> getPersonalLoan() async {
    try {
      final result = await localPersonalLoanDataSource.getPersonalLoan();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

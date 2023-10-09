import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/data/data%20source/add_manual_data.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/domain/repository/add_manual_pension_repo.dart';

class AddManualPensionRepoImp implements AddManualPensionRepo {
  final AddManualPensionDataSource addManualPensionDataPension;

  AddManualPensionRepoImp({required this.addManualPensionDataPension});

  @override
  Future<Either<Failure, PensionsEntity>> addManualPension(
      Map<String, dynamic> body) async {
    try {
      final verifiedUser =
          await addManualPensionDataPension.addManualPension(body);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, PensionsEntity>> updateManualPension(
      Map<String, dynamic> body) async {
    try {
      final result =
          await addManualPensionDataPension.updateManualPension(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

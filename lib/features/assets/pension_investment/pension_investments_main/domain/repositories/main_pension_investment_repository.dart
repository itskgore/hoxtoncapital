import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_email_entity.dart';

abstract class MainPensionInvestmentRepository {
  Future<Either<Failure, AssetsEntity>> getHoxtonDataSummery();

  Future<Either<Failure, LoginEmailEntity>> getUserDetails();

  Future<Either<Failure, dynamic>> getInsights();
}

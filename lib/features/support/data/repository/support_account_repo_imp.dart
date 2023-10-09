import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/support/data/datasource/remote_support_account_datasource.dart';
import 'package:wedge/features/support/domain/repository/support_account.dart';

class AddSupportAccontRepoImp extends AddSupportAccontRepo {
  final RemoteSupportAccountDataSource remoteSupportAccountDataSource;

  AddSupportAccontRepoImp({required this.remoteSupportAccountDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> postSupport(
      Map<String, dynamic> body) async {
    try {
      final result = await remoteSupportAccountDataSource.postSupport(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

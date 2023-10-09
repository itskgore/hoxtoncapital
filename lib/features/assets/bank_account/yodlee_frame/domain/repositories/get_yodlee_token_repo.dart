import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/provider_token_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class GetYodleeTokenRepository {
  Future<Either<Failure, ProviderTokenModel>> getYodleeToken(
      {required Map<String, dynamic> body});
}

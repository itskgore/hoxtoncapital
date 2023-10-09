import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/error/failures.dart';

abstract class UploadDocumentRepository {
  Future<Either<Failure, List>> uploadDocumentData(Map<String, dynamic> body,
      {Function(int, int)? onSendProgress, CancelToken? cancelToken});
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/repository/upload_document_repo.dart';
import '../datasource/remote_upload_document_datasource.dart';

class UploadDocumentRepositoryImp implements UploadDocumentRepository {
  final UploadDocumentDataSource uploadDocumentSource;

  UploadDocumentRepositoryImp({required this.uploadDocumentSource});

  @override
  Future<Either<Failure, List>> uploadDocumentData(Map<String, dynamic> body,
      {Function(int, int)? onSendProgress, CancelToken? cancelToken}) async {
    try {
      final result = await uploadDocumentSource.uploadDocuments(body,
          onSendProgress: onSendProgress, cancelToken: cancelToken);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

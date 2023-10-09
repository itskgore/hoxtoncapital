import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repository/upload_document_repo.dart';

class UploadDocumentUseCase implements UseCase<List, Map<String, dynamic>> {
  final UploadDocumentRepository uploadDocumentRepository;

  UploadDocumentUseCase(this.uploadDocumentRepository);

  @override
  Future<Either<Failure, List>> call(Map<String, dynamic> params,
      {Function(int, int)? onSendProgress, CancelToken? cancelToken}) async {
    return await uploadDocumentRepository.uploadDocumentData(params,
        onSendProgress: onSendProgress, cancelToken: cancelToken);
  }
}

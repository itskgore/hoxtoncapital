import 'package:dartz/dartz.dart';
import 'package:wedge/core/common/domain/repository/common_repository.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

class ExcelDownload
    implements UseCase<List<Map<String, dynamic>>, Map<String, dynamic>> {
  final CommonRepository repository;

  ExcelDownload(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      Map<String, dynamic> params) async {
    return await repository.excelDownload(params);
  }
}

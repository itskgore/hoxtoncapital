import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../../../../usecases/usecase.dart';
import '../../data/model/line_performance_model.dart';

abstract class LinePerformanceGraphRepo {
  Future<Either<Failure, LinePerformanceModel>> getLinePerformance({
    required bool merge,
    required List scope,
    required String fromDate,
    required String toDate,
    required String assetType,
    String? id,
  });
}

class GetLinePerformance
    extends UseCase<LinePerformanceModel, Map<String, dynamic>> {
  final LinePerformanceGraphRepo linePerformanceGraphRepo;
  GetLinePerformance(this.linePerformanceGraphRepo);

  @override
  Future<Either<Failure, LinePerformanceModel>> call(
      Map<String, dynamic> params) {
    return linePerformanceGraphRepo.getLinePerformance(
        merge: params['merge'],
        scope: params['scope'],
        fromDate: params['fromDate'],
        toDate: params['toDate'],
        id: params['id'] ?? '',
        assetType: params['assetType']);
  }
}

import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

import '../../domain/repository/line_Performance_graph_repository.dart';
import '../datasource/remote_line_performance_graph_datasource.dart';
import '../model/line_performance_model.dart';

class LinePerformanceGraphRepoImp implements LinePerformanceGraphRepo {
  final RemoteLinePerformanceGraphDatasource
      remoteLinePerformanceGraphDatasource;
  LinePerformanceGraphRepoImp(
      {required this.remoteLinePerformanceGraphDatasource});

  @override
  Future<Either<Failure, LinePerformanceModel>> getLinePerformance(
      {required bool merge,
      required List scope,
      required String fromDate,
      required String toDate,
      required String assetType,
      String? id}) async {
    try {
      final result =
          await remoteLinePerformanceGraphDatasource.getLinePerformance(
              merge: merge,
              scope: scope,
              fromDate: fromDate,
              toDate: toDate,
              assetType: assetType,
              id: id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

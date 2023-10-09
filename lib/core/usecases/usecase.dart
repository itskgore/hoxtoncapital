import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class DeleteParams extends Equatable {
  final String id;
  const DeleteParams({required this.id});
  @override
  List<Object> get props => [id];
}

class UnlinkParams extends Equatable {
  final String loanId;
  final String vehicleId;
  const UnlinkParams({required this.loanId, required this.vehicleId});
  @override
  List<Object?> get props => [loanId, vehicleId];
}

class GetUploadedDocumentsParams extends Equatable {
  final String parentFolder;
  const GetUploadedDocumentsParams({required this.parentFolder});
  @override
  List<Object> get props => [parentFolder];
}

class DownloadUploadedDocumentsParams extends Equatable {
  final String path;
  const DownloadUploadedDocumentsParams({required this.path});
  @override
  List<Object> get props => [path];
}

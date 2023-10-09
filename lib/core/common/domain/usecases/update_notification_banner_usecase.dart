import 'package:dartz/dartz.dart';
import 'package:wedge/core/common/domain/repository/common_repository.dart';

import '../../../error/failures.dart';
import '../../../usecases/usecase.dart';

class UpdateNotificationAndBannerUseCase
    extends UseCase<Map<String, dynamic>, List<Map<String, dynamic>>> {
  final CommonRepository commonRepository;
  UpdateNotificationAndBannerUseCase(this.commonRepository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      List<Map<String, dynamic>> params) {
    return commonRepository.updateNotificationAndBanner(params);
  }
}

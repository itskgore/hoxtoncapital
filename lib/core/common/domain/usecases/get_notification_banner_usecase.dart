import 'package:dartz/dartz.dart';

import '../../../error/failures.dart';
import '../../../usecases/usecase.dart';
import '../repository/common_repository.dart';

class GetNotificationAndBannerUseCase extends UseCase<dynamic, NoParams> {
  final CommonRepository commonRepository;
  GetNotificationAndBannerUseCase(this.commonRepository);

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return commonRepository.getNotificationAndBanner();
  }
}

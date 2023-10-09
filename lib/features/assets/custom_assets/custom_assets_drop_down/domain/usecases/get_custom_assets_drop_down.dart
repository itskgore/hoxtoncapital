import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_drop_down/domain/repository/custom_assets_repository.dart';

class GetCustomAssetsDropDown implements UseCase<List<dynamic>, NoParams> {
  final CustomAssetsDropDownRepo customAssetsDropDownRepo;

  GetCustomAssetsDropDown(this.customAssetsDropDownRepo);

  @override
  Future<Either<Failure, List<dynamic>>> call(NoParams params) {
    return customAssetsDropDownRepo.getData();
  }
}

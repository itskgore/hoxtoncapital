import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/app_passcode/create_passcode/domain/repository/create_passcode_repository.dart';

class CreatePasscodeUseCase extends UseCase<dynamic, Map<String, dynamic>> {
  final CreatePasscodeRepository createPasscodeRepository;

  CreatePasscodeUseCase(this.createPasscodeRepository);

  @override
  Future<Either<Failure, dynamic>> call(Map<String, dynamic> body) {
    return createPasscodeRepository.createPasscode(body);
  }
}

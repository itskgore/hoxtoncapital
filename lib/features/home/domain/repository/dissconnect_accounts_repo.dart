import 'package:dartz/dartz.dart';
import 'package:wedge/features/home/data/model/disconnected_account_entity.dart';

import '../../../../core/error/failures.dart';

abstract class DisconnectedAccountsRepo {
  Future<Either<Failure, List<DisconnectedAccountsEntity>>>
      getDisconnectedAccountData();
}

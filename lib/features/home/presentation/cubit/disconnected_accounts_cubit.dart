import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/home/presentation/cubit/disconnected_accounts_state.dart';

import '../../domain/usecase/get_disconnected_accouts_usecase.dart';

class DisconnectedAccountsCubit extends Cubit<DisconnectedAccountsState> {
  GetDisconnectedAccountsUseCase getDisconnectedAccountsUseCase;

  DisconnectedAccountsCubit({required this.getDisconnectedAccountsUseCase})
      : super(DisconnectedAccountsInitialState());

  bool isAssetsAndLiabilityDisconnected = false;
  bool isPensionDisconnected = false;
  bool isInvestmentsDisconnected = false;

  getDisconnectedAccountData() {
    try {
      isAssetsAndLiabilityDisconnected = false;
      isPensionDisconnected = false;
      isInvestmentsDisconnected = false;
      emit(DisconnectedAccountsLoadingState());
      final result = getDisconnectedAccountsUseCase(NoParams());
      result.then((value) => value.fold((l) {
            if (l is TokenExpired) {
              getDisconnectedAccountData();
            } else {
              emit(DisconnectedAccountsErrorState(l.displayErrorMessage()));
            }
          }, (r) {
            for (var element in r) {
              if (element.fiCategory.toLowerCase() == "assets" ||
                  element.fiCategory.toLowerCase() == "liabilities") {
                isAssetsAndLiabilityDisconnected = true;
              }
              if (element.fiType.toLowerCase() == "pensions") {
                isPensionDisconnected = true;
              }
              if (element.fiType.toLowerCase() == "investments") {
                isInvestmentsDisconnected = true;
              }
            }
            emit(DisconnectedAccountsLoadingState());
            emit(DisconnectedAccountsLoadedState(r));
          }));
    } catch (error) {
      emit(DisconnectedAccountsErrorState(error.toString()));
    }
  }
}

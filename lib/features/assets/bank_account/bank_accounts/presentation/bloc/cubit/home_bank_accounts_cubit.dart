import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/usecases/get_home_bank_accounts.dart';

part 'home_bank_accounts_state.dart';

class HomeBankAccountsCubit extends Cubit<HomeBankAccountsState> {
  HomeBankAccountsCubit({required this.getBankAccounts})
      : super(HomeBankAccountsInitial());

  final GetHomeBankAccounts getBankAccounts;
  late AssetsEntity _assetsEntity;
  getData({bool? transactionUpdated, bool? isInitial}) {
    if (isInitial ?? false) {
      emit(HomeBankAccountsLoading());
    }
    final _result = getBankAccounts(NoParams());
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData(isInitial: isInitial, transactionUpdated: transactionUpdated);
        } else {
          emit(HomeBankAccountsError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        _assetsEntity = data;
        emit(HomeBankAccountsLoaded(
            data: data, transactionUpdated: transactionUpdated ?? false));
      });
    });
  }
}

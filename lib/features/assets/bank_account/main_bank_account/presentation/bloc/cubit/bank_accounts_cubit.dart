import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/domain/usecases/delete_bank_account.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/domain/usecases/get_bank_accounts.dart';

part 'bank_accounts_state.dart';

class BankAccountsCubit extends Cubit<BankAccountsState> {
  final GetBankAccounts getBankAccounts;
  final DeleteBankAccounts deleteBankAccounts;

  BankAccountsCubit(
      {required this.getBankAccounts, required this.deleteBankAccounts})
      : super(BankAccountsInitial());

  AssetsEntity? _assetsEntity;
  getData() {
    final result = getBankAccounts(NoParams());
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(BankAccountsError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        _assetsEntity = data;
        emit(BankAccountsLoaded(assets: data, deleteMessageSent: false));
      });
    });
  }

  deleteBankAccount(id) {
    final result = deleteBankAccounts(DeleteParams(id: id));
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          deleteBankAccount(id);
        } else {
          emit(BankAccountsError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        emit(BankAccountsLoaded(
            assets: _assetsEntity ?? RootApplicationAccess.assetsEntity!,
            deleteMessageSent: true));
        // }
      });
    });
  }
}

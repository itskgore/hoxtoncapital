import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/domain/usecases/add_manual_bank_usecase.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/domain/usecases/update_manual_bank_usecase.dart';

part 'add_manual_bank_state.dart';

class AddManualBankCubit extends Cubit<AddManualBankState> {
  final AddManualBankAccount addManualBankAccount;
  final UpdateManualBankAccount updateManualBankAccount;

  AddManualBankCubit(
      {required this.addManualBankAccount,
      required this.updateManualBankAccount})
      : super(AddManualBankInitial(
            status: false,
            message: "",
            data: ManualBankAccountsEntity(
              country: "",
              name: "",
              currency: '',
              currentAmount: ValueEntity(amount: 0, currency: ""),
              id: '',
            )));

  final _banAccount = ManualBankAccountsEntity(
    country: "",
    name: "",
    currency: '',
    currentAmount: ValueEntity(amount: 0, currency: ""),
    id: '',
  );

  addBank(name, country, currency, currentAmount) {
    final result = addManualBankAccount(ManualBankAccountsParams(
        name: name,
        country: country,
        currency: currency,
        currentAmount: ValueEntity(
            amount: double.parse(currentAmount), currency: currency),
        id: ""));
    emit(AddManualBankLoading());
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          addBank(name, country, currency, currentAmount);
        } else {
          emit(AddManualBankInitial(
              status: false,
              message: failure.displayErrorMessage(),
              data: _banAccount));
        }
      },
          //if success
          (data) async {
        emit(AddManualBankInitial(status: true, message: "", data: data));
      });
    });
  }

  updateBank(name, country, currency, currentAmount, id) {
    final result = updateManualBankAccount(ManualBankAccountsParams(
        name: name,
        country: country,
        currency: currency,
        currentAmount: ValueEntity(
            amount: double.parse(currentAmount), currency: currency),
        id: id));
    emit(AddManualBankLoading());

    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          updateBank(name, country, currency, currentAmount, id);
        } else {
          emit(
            AddManualBankInitial(
                status: false,
                message: failure.displayErrorMessage(),
                data: _banAccount),
          );
        }
      },
          //if success
          (data) {
        emit(AddManualBankInitial(status: true, message: "", data: data));
      });
    });
  }
}

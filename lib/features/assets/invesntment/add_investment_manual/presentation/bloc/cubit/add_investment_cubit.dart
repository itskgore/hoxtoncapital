import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/domain/usecases/add_investment_usecase.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/domain/usecases/update_investment_usecase.dart';

part 'add_investment_state.dart';

class AddInvestmentCubit extends Cubit<AddInvestmentState> {
  final AddInvestment addInvestment;
  final UpdateInvestment updateInvestment;

  AddInvestmentCubit(
      {required this.addInvestment, required this.updateInvestment})
      : super(AddInvestmentInitial(
            status: false,
            message: "",
            data: InvestmentEntity(
              name: "",
              id: '',
              country: '',
              currentValue: ValueEntity(amount: 0, currency: ""),
              initialValue: ValueEntity(amount: 0, currency: ""),
              policyNumber: '',
            )));

  final _investments = InvestmentEntity(
    name: "",
    id: '',
    country: '',
    currentValue: ValueEntity(amount: 0, currency: ""),
    initialValue: ValueEntity(amount: 0, currency: ""),
    policyNumber: '',
  );

  addAsset(name, country, policyNumber, initialValue, currentAmount,
      initCurrency, currentCurrency) {
    final result = addInvestment(InvestmentParams(
      name: name,
      policyNumber: policyNumber,
      initialValue: ValueEntity(
          amount: double.parse(initialValue), currency: initCurrency),
      currentValue: ValueEntity(
          amount: double.parse(currentAmount), currency: currentCurrency),
      id: "",
      country: country,
    ));
    emit(AddInvestmentLoading());
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          addAsset(name, country, policyNumber, initialValue, currentAmount,
              initCurrency, currentCurrency);
        } else {
          emit(AddInvestmentInitial(
              status: false,
              message: failure.displayErrorMessage(),
              data: _investments));
        }
      },
          //if success
          (data) {
        emit(AddInvestmentInitial(status: true, message: "", data: data));
      });
    });
  }

  updateAsset(id, name, country, policyNumber, initialValue, currentAmount,
      initCurrency, currentCurrency) {
    final result = updateInvestment(InvestmentParams(
        name: name,
        policyNumber: policyNumber,
        currentValue: ValueEntity(
            amount: double.parse(currentAmount), currency: currentCurrency),
        initialValue: ValueEntity(
            amount: double.parse(initialValue), currency: initCurrency),
        country: country,
        id: id));
    emit(AddInvestmentLoading());

    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          updateAsset(id, name, country, policyNumber, initialValue,
              currentAmount, initCurrency, currentCurrency);
        } else {
          emit(
            AddInvestmentInitial(
                status: false,
                message: failure.displayErrorMessage(),
                data: _investments),
          );
        }
      },
          //if success
          (data) {
        emit(AddInvestmentInitial(status: true, message: "", data: data));
      });
    });
  }
}

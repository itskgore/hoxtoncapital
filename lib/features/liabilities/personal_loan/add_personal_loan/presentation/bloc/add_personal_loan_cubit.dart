import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/domain/use_cases/add_personal_loan_use_case.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/domain/use_cases/params/add_update_personal_loan.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/domain/use_cases/update_personal_load_usecase.dart';

import '../../../../../../../core/entities/value_entity.dart';

part 'add_personal_loan_state.dart';

class AddPersonalLoanCubit extends Cubit<AddPersonalLoanState> {
  AddPersonalLoanCubit(
      {required this.addPersonalLoanUseCase, required this.updatePersonLoan})
      : super(AddPersonalLoanInitial());

  final AddPersonalLoan addPersonalLoanUseCase;
  final UpdatePersonLoan updatePersonLoan;

  Future addPersonalLoan(
      {required String provider,
      required String country,
      required String interestRate,
      required String termRemaining,
      required ValueEntity outstandingAmount,
      required ValueEntity monthlyPayment}) async {
    emit(AddPersonalLoanLoading());

    try {
      await addPersonalLoanUseCase(
        AddPersonalLoanParams(
            provider: provider,
            country: country,
            interestRate: double.parse(interestRate),
            termRemaining: termRemaining,
            monthlyPayment: monthlyPayment,
            outstandingAmount: outstandingAmount),
      ).then((value) {
        value.fold(
          (failure) {
            if (failure is TokenExpired) {
              addPersonalLoan(
                  country: country,
                  interestRate: interestRate,
                  monthlyPayment: monthlyPayment,
                  outstandingAmount: outstandingAmount,
                  provider: provider,
                  termRemaining: termRemaining);
            } else {
              emit(AddPersonalLoanError(
                  errorMessage: failure.displayErrorMessage()));
            }
          },
          (data) => emit(AddPersonalLoanSuccess(data: data)),
        );
      }).onError((error, stackTrace) {
        emit(AddPersonalLoanError(errorMessage: error.toString()));
      });
    } on Exception catch (e) {
      emit(AddPersonalLoanError(errorMessage: e.toString()));
    }
  }

  updatePersonalLoan(
      {required String provider,
      required String country,
      required String id,
      required String interestRate,
      required String termRemaining,
      required ValueEntity outstandingAmount,
      required ValueEntity monthlyPayment}) {
    final result = updatePersonLoan(AddPersonalLoanParams(
        provider: provider,
        country: country,
        id: id,
        interestRate: double.parse(interestRate),
        termRemaining: termRemaining,
        outstandingAmount: outstandingAmount,
        monthlyPayment: monthlyPayment));
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          updatePersonalLoan(
              country: country,
              id: id,
              interestRate: interestRate,
              monthlyPayment: monthlyPayment,
              outstandingAmount: outstandingAmount,
              provider: provider,
              termRemaining: termRemaining);
        } else {
          emit(AddPersonalLoanError(
              errorMessage: failure.displayErrorMessage()));
        }
      }, (data) {
        emit(AddPersonalLoanSuccess(data: data));
      });
    });
  }
}

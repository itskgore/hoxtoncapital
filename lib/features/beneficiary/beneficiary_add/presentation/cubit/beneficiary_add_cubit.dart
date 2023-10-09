import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/beneficiary_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/domain/usecases/add_beneficiary_member_usecase.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/domain/usecases/edit_beneficiary_member_usecase.dart';

part 'beneficiary_add_state.dart';

class BeneficiaryAddCubit extends Cubit<BeneficiaryAddState> {
  AddBeneficiaryUsecase addBeneficiaryUsecase;
  EditBeneficiaryUsecase editBeneficiaryUsecase;

  BeneficiaryAddCubit(
      {required this.addBeneficiaryUsecase,
      required this.editBeneficiaryUsecase})
      : super(BeneficiaryAddInitial());

  addBeneficiaryMember(Map<String, dynamic> body) {
    emit(BeneficiaryAddLoading());
    final result = addBeneficiaryUsecase(body);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          addBeneficiaryMember(body);
        } else {
          emit(BeneficiaryAddError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        emit(BeneficiaryAddLoaded(beneficiaryMembersEntity: r));
      });
    });
  }

  editBeneficiaryMember(Map<String, dynamic> body) {
    emit(BeneficiaryAddLoading());

    final result = editBeneficiaryUsecase(body);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          addBeneficiaryMember(body);
        } else {
          emit(BeneficiaryAddError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        emit(BeneficiaryAddLoaded(beneficiaryMembersEntity: r));
      });
    });
  }
}

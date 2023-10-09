import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/domain/usecase/delete_trusted_member.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/domain/usecase/get_trusted_members.dart';

part 'trusted_main_state.dart';

class TrustedMainCubit extends Cubit<TrustedMainState> {
  GetTrustedDetailsUsecase getTrustedDetailsUsecase;
  DeleteTrustedDetailsUsecase deleteTrustedDetailsUsecase;
  late TrustedMembersEntity trustedMembersEntity;

  TrustedMainCubit(
      {required this.getTrustedDetailsUsecase,
      required this.deleteTrustedDetailsUsecase})
      : super(TrustedMainInitial());

  getTrustedDetails() {
    emit(TrustedMainLoading());

    // Fetch BenificiaryData
    final result = getTrustedDetailsUsecase(NoParams());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getTrustedDetails();
        } else {
          emit(TrustedMainError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        trustedMembersEntity = r;
        emit(TrustedMainLoaded(trustedMembersEntity: r, isDeleted: false));
      });
    });
  }

  deleteTrustedDetails(String id) {
    // Fetch BenificiaryData
    final result = deleteTrustedDetailsUsecase(DeleteParams(id: id));
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getTrustedDetails();
        } else {
          emit(TrustedMainError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        emit(TrustedMainLoading());

        trustedMembersEntity = r;
        emit(TrustedMainLoaded(trustedMembersEntity: r, isDeleted: false));
      });
    });
  }
}

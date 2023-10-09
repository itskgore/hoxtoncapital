import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/beneficiary/trusted_add/domain/usecases/add_trusted_member_usecase.dart';
import 'package:wedge/features/beneficiary/trusted_add/domain/usecases/edit_trusted_member_usecase.dart';

part 'trusted_add_state.dart';

class TrustedAddCubit extends Cubit<TrustedAddState> {
  AddTrustedMemberUsecase addTrustedMemberScreen;
  EditTrustedMemberUsecase editTrustedMemberUsecase;

  TrustedAddCubit(
      {required this.addTrustedMemberScreen,
      required this.editTrustedMemberUsecase})
      : super(TrustedAddInitial());

  addTrustedMember(Map<String, dynamic> body) {
    emit(TrustedAddLoading());
    final result = addTrustedMemberScreen(body);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          addTrustedMember(body);
        } else {
          emit(TrustedAddError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        emit(TrustedAddLoaded(trustedMembersEntity: r));
      });
    });
  }

  editTrustedMember(Map<String, dynamic> body) {
    emit(TrustedAddLoading());
    final result = editTrustedMemberUsecase(body);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          addTrustedMember(body);
        } else {
          emit(TrustedAddError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        emit(TrustedAddLoaded(trustedMembersEntity: r));
      });
    });
  }
}

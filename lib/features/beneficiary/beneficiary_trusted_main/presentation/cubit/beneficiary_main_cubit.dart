import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/beneficiary_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/domain/usecase/delete_beneficiary_member.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/domain/usecase/get_beneficiary.dart';

part 'beneficiary_main_state.dart';

class BeneficiaryMainCubit extends Cubit<BeneficiaryMainState> {
  GetBeneficiaryDetailsUsecase getBeneficiaryDetailsUsecase;
  DeleteBeneficiaryDetailsUsecase deleteBeneficiaryDetailsUsecase;

  late BeneficiaryMembersEntity beneficiaryMembersEntity;

  BeneficiaryMainCubit({
    required this.getBeneficiaryDetailsUsecase,
    required this.deleteBeneficiaryDetailsUsecase,
  }) : super(BeneficiaryMainInitial());

  getBeneficiary() {
    emit(BeneficiaryMainLoading());

    // Fetch BenificiaryData
    final result = getBeneficiaryDetailsUsecase(NoParams());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getBeneficiary();
        } else {
          emit(BeneficiaryMainError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        beneficiaryMembersEntity = r;
        emit(BeneficiaryMainLoaded(
          isDeleted: false,
          beneficiaryMembersEntity: r,
        ));
      });
    });
  }

  deleteBeneficiary(String id) {
    // Fetch BenificiaryData
    final result = deleteBeneficiaryDetailsUsecase(DeleteParams(id: id));
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getBeneficiary();
        } else {
          emit(BeneficiaryMainError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        emit(BeneficiaryMainLoading());

        beneficiaryMembersEntity = r;
        emit(BeneficiaryMainLoaded(
          isDeleted: false,
          beneficiaryMembersEntity: r,
        ));
      });
    });
  }
}

//  trustedData.then((value) {
//           value.fold((failure) {
//             if (failure is TokenExpired) {
//               getBeneficiary();
//             } else {
//               emit(BeneficiaryMainError(
//                   errorMsg: failure.displayErrorMessage()));
//             }
//           }, (data) {
//             trustedMembersEntity = data;
//             // Privacy Mode setting
//             if (locator<SharedPreferences>()
//                 .containsKey("${RootApplicationAccess.privacyMode}")) {
//               emit(BeneficiaryMainLoaded(
//                   beneficiaryMembersEntity: beneficiaryMembersEntity,
//                   trustedMembersEntity: trustedMembersEntity,
//                   isPrivacyMode: locator<SharedPreferences>()
//                           .getBool("${RootApplicationAccess.privacyMode}") ??
//                       false));
//             } else {
//               emit(BeneficiaryMainLoaded(
//                 isPrivacyMode: false,
//                 beneficiaryMembersEntity: beneficiaryMembersEntity,
//                 trustedMembersEntity: trustedMembersEntity,
//               ));
//             }
//           });
//         });

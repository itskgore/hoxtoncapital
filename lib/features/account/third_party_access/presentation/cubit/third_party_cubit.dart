import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/account/third_party_access/data/model/third_party_access_entity.dart';
import 'package:wedge/features/account/third_party_access/domain/model/third_party_url_model.dart';
import 'package:wedge/features/account/third_party_access/domain/usecase/third_party_access_usecase.dart';

part 'third_party_state.dart';

class ThirdPartyCubit extends Cubit<ThirdPartyState> {
  ThirdPartyCubit(this.getThirdPartyAccessUsecase) : super(ThirdPartyInitial());
  final GetThirdPartyAccessUsecase getThirdPartyAccessUsecase;

  getThirdPartyAccessData(
    ThirdPartyUrlParams partyUrlParams,
  ) {
    emit(ThirdPartyLoading());
    final result = getThirdPartyAccessUsecase(partyUrlParams);
    result.then((value) => value.fold((l) {
          if (l is TokenExpired) {
            getThirdPartyAccessData(partyUrlParams);
          } else {
            emit(ThirdPartyError(l.displayErrorMessage()));
          }
        }, (r) {
          if (partyUrlParams.isUpdate ?? false) {
            getThirdPartyAccessData(
                ThirdPartyUrlParams("thirdpartyAccessor", "view", {}));
          } else {
            emit(ThirdPartyLoaded(r));
          }
        }));
  }
}

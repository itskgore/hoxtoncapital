import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/provider_token_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/domain/usecases/get_yodlee_token.dart';

part 'yodlee_intergration_state.dart';

//
class YodleeIntegrationCubit extends Cubit<YodleeIntegrationState> {
  YodleeIntegrationCubit({required this.getToken})
      : super(YodleeIntegrationInitial());

  final GetProviderToken getToken;

  getData({required Map<String, dynamic> body}) {
    final result = getToken(body);
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData(body: body);
        } else {
          emit(YodleeIntegrationError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        emit(YodleeIntegrationLoaded(data: data, fixedData: data));
      });
    });
  }
}

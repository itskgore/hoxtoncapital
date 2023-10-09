import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/common/domain/usecases/refresh_aggregator_usecase.dart';
import 'package:wedge/core/contants/enums.dart';
import 'package:wedge/core/error/failures.dart';

part 'aggregator_reconnect_state.dart';

class AggregatorReconnectCubit extends Cubit<AggregatorReconnectState> {
  AggregatorReconnectCubit(this.commonRefreshAgreegatorAccountUsecase)
      : super(AggregatorReconnectInitial());

  final CommonRefreshAggregatorAccountUseCase
      commonRefreshAgreegatorAccountUsecase;

  Future<Map<String, dynamic>?> refreshAggregator(dynamic aggre) async {
    try {
      emit(AggregatorReconnectLoading());
      String provider = aggre.source;
      late Map<String, dynamic> data;
      bool isSaltedge = provider.toLowerCase() ==
          AggregatorProvider.Saltedge.name.toLowerCase();
      bool isYodlee = provider.toLowerCase() ==
          AggregatorProvider.Yodlee.name.toLowerCase();
      if (isSaltedge) {
        data = {
          "connectionId": "${aggre.aggregator!.connectionId}",
          "customerId": "${aggre.aggregator!.customerId}",
          "institutionId": "${aggre.aggregator!.institutionId}",
          "returnTo": "https://www.getwedge.com",
        };
      } else if (isYodlee) {
        data = {
          "institutionId": "${aggre.aggregator?.institutionId ?? ''}",
          "returnTo": "https://www.getwedge.com",
        };
      }

      final result = await commonRefreshAgreegatorAccountUsecase({
        "provider": provider,
        "data": data,
      });
      emit(AggregatorReconnectInitial());
      result.fold((l) {
        if (l is TokenExpired) {
          data = {
            'status': false,
            'msg': "Something went wrong please try again!"
          };
        } else {
          data = {'status': false, 'msg': l.displayErrorMessage()};
        }
      }, (r) {
        data = {
          'status': true,
          'msg': "fetched",
          'response': r,
          'provider': provider
        };
      });
      return data;
    } on Exception catch (e) {
      return {'status': false, 'msg': "Something went wrong please try again!"};
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/common/domain/usecases/refresh_aggregator_usecase.dart';
import 'package:wedge/core/entities/investments_holdings_entity.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/your_pensions/domain/usecases/get_holdings.dart';

import '../../../assets/pension/pension_main/domain/usecases/delete_pension_usecase.dart';

part 'your_pensions_state.dart';

class YourPensionsCubit extends Cubit<YourPensionsState> {
  final GetHoldingsPension getHoldings;
  final DeletePensionUsecase deletePension;
  final CommonRefreshAggregatorAccountUseCase
      commonRefreshAggregatorAccountUseCase;

//
  YourPensionsCubit(
      {required this.deletePension,
      required this.getHoldings,
      required this.commonRefreshAggregatorAccountUseCase})
      : super(YourPensionsInitial());
  late List<InvestmentHoldingsEntity> data;

  getPensions(String id, String source) {
    emit(YourPensionsLoading());
    final result = getHoldings({"id": id, "source": source});
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getPensions(id, source);
        } else {
          emit(YourPensionsError(l.displayErrorMessage()));
        }
      }, (r) async {
        data = r;

        emit(YourPensionsLoaded(r, false));
      });
    });
  }

  refreshAggregator(PensionsEntity aggre) {
    final result = commonRefreshAggregatorAccountUseCase({
      "connectionId": "${aggre.aggregator!.connectionId}",
      "customerId": "${aggre.aggregator!.customerId}",
      "institutionId": "${aggre.aggregator!.institutionId}",
      "returnTo": "https://www.getwedge.com",
      "provider": aggre.source
    });
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          refreshAggregator(aggre);
        } else {
          emit(YourPensionsError(l.displayErrorMessage()));
          getPensions(aggre.aggregatorId, aggre.source);
        }
      }, (r) {
        emit(YourPensionsLoaded(data, false));

        getPensions(aggre.aggregatorId, aggre.source);
      });
    });
  }

  deletePensionData(String id) {
    // emit(YourPensionsLoading());
    final result = deletePension(DeleteParams(id: id));
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          deletePensionData(id);
        } else {
          emit(YourPensionsError(l.displayErrorMessage()));
        }
      }, (r) {
        emit(YourPensionsLoaded(data, true));
      });
      ;
    });
  }
}

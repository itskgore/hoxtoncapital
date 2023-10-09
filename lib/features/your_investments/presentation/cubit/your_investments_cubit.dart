import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/common/domain/usecases/refresh_aggregator_usecase.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/entities/investments_holdings_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/invesntment/investment_main/domain/usecases/delete_investment_usecase.dart';
import 'package:wedge/features/your_investments/domain/usecases/get_holdings.dart';

part 'your_investments_state.dart';

class YourInvestmentsCubit extends Cubit<YourInvestmentsState> {
  final GetHoldings getHoldings;
  final CommonRefreshAggregatorAccountUseCase
      commonRefreshAgreegatorAccountUsecase;
  final DeleteInvestment deleteInvestments;

  YourInvestmentsCubit(
      {required this.getHoldings,
      required this.deleteInvestments,
      required this.commonRefreshAgreegatorAccountUsecase})
      : super(YourInvestmentsInitial());
  late List<InvestmentHoldingsEntity> data;

  getHolding(String id, String source) {
    emit(YourInvestmentsLoading());
    final result = getHoldings({"id": id, "source": source});
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getHolding(id, source);
        } else {
          emit(YourInvestmentsError(l.displayErrorMessage()));
        }
      }, (r) {
        data = r;
        emit(YourInvestmentsLoaded(
            investmentHoldingsEntity: r, isDeletePerformed: false));
      });
    });
  }

  refreshAggregator(InvestmentEntity aggre) {
    final result = commonRefreshAgreegatorAccountUsecase({
      "connectionId": "${aggre.aggregator!.connectionId}",
      "customerId": "${aggre.aggregator!.customerId}",
      "institutionId": "${aggre.aggregator!.institutionId}",
      "returnTo": "https://www.getwedge.com",
      "provider": "${aggre.source}"
    });
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          refreshAggregator(aggre);
        } else {
          emit(YourInvestmentsError(l.displayErrorMessage()));
          getHolding(aggre.aggregatorId, aggre.source ?? "");
        }
      }, (r) {
        emit(YourInvestmentsLoaded(
            investmentHoldingsEntity: data,
            isDeletePerformed: false,
            reconnctUrl: r));
        // getHolding(aggre.aggregatorId, aggre.source ?? "");
      });
    });
  }

  deleteInvestmentsData(String id) {
    // emit(YourInvestmentsLoading());
    final result = deleteInvestments(DeleteParams(id: id));
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          deleteInvestmentsData(id);
        } else {
          emit(YourInvestmentsError(l.displayErrorMessage()));
        }
      }, (r) {
        emit(YourInvestmentsLoaded(
            investmentHoldingsEntity: data, isDeletePerformed: true));
      });
      ;
    });
  }
}

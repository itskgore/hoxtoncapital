import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/invesntment/investment_main/domain/usecases/delete_investment_usecase.dart';
import 'package:wedge/features/assets/invesntment/investment_main/domain/usecases/get_investments_usecase.dart';

part 'investments_state.dart';

class InvestmentsCubit extends Cubit<InvestmentsState> {
  final GetInvestments getInvestments;
  final DeleteInvestment deleteInvestments;

  InvestmentsCubit(
      {required this.getInvestments, required this.deleteInvestments})
      : super(InvestmentsInitial());

  late AssetsEntity _assetsEntity;

  getData() {
    final result = getInvestments(NoParams());
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(InvestmentsError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        _assetsEntity = data;
        emit(InvestmentsLoaded(assets: data, deleteMessageSent: false));
      });
    });
  }

  deleteData(id) {
    final result = deleteInvestments(DeleteParams(id: id));
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          deleteData(id);
        } else {
          emit(InvestmentsError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        emit(InvestmentsLoaded(assets: _assetsEntity, deleteMessageSent: true));
      });
    });
  }
}

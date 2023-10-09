import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/stocks/stocks_main/domain/usecases/delete_stocks_usecase.dart';
import 'package:wedge/features/assets/stocks/stocks_main/domain/usecases/get_stocks_usecase.dart';

part 'stocks_state.dart';

class StocksCubit extends Cubit<StocksState> {
  final GetStocks getStocks;
  final DeleteStocksBonds deleteStocksBonds;

  StocksCubit({required this.getStocks, required this.deleteStocksBonds})
      : super(StocksInitial());

  late AssetsEntity _assetsEntity;

  getData() {
    final _result = getStocks(NoParams());
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(StocksError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        _assetsEntity = data;
        emit(StocksLoaded(assets: data, deleteMessageSent: false));
      });
    });
  }

  deletestocksBonds(id) {
    final _result = deleteStocksBonds(DeleteParams(id: id));
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          deletestocksBonds(id);
        } else {
          emit(StocksError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        emit(StocksLoading());
        emit(StocksLoaded(assets: _assetsEntity, deleteMessageSent: true));
      });
    });
  }
}

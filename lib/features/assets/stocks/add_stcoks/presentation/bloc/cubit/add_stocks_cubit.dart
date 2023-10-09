import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/stocks_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/domain/usecases/add_custom_assets_usecase.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/domain/usecases/update_custom_assets_usecase.dart';

part 'add_stocks_state.dart';

class AddStocksCubit extends Cubit<AddStocksState> {
  final AddStocksBonds addStocksBonds;
  final UpdateStocksBonds updateStocksBonds;

  AddStocksCubit(
      {required this.addStocksBonds, required this.updateStocksBonds})
      : super(AddStocksInitial(
            status: false,
            message: "",
            data: StocksAndBondsEntity(
              symbol: "",
              name: "",
              createdAt: "",
              value: ValueEntity(amount: 0, currency: ""),
              id: '',
              quantity: 0,
            )));

  var _stocksBonds = StocksAndBondsEntity(
    symbol: "",
    name: "",
    value: ValueEntity(amount: 0, currency: ""),
    id: '',
    quantity: 0,
  );

  addAsset(
    name,
    quantity,
    currentAmount,
    currency,
    symbol,
  ) {
    final _result = addStocksBonds(StocksBondsParams(
        name: name,
        symbol: symbol,
        quantity: double.parse(quantity),
        value: ValueEntity(
            amount: double.parse(currentAmount), currency: currency),
        id: ""));
    emit(AddStocksLoading());
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          addAsset(name, quantity, currentAmount, currency, symbol);
        } else {
          emit(AddStocksInitial(
              status: false,
              message: failure.displayErrorMessage(),
              data: _stocksBonds));
        }
      },
          //if success
          (data) {
        emit(AddStocksInitial(status: true, message: "", data: data));
      });
    });
  }

  updateAsset(name, quantity, currentAmount, id, currency, symbol) {
    final _result = updateStocksBonds(StocksBondsParams(
        name: name,
        symbol: symbol,
        quantity: double.parse(quantity),
        value: ValueEntity(
            amount: double.parse(currentAmount), currency: currency),
        id: id));
    emit(AddStocksLoading());

    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          updateAsset(name, quantity, currentAmount, id, currency, symbol);
        } else {
          emit(
            AddStocksInitial(
                status: false,
                message: failure.displayErrorMessage(),
                data: _stocksBonds),
          );
        }
      },
          //if success
          (data) {
        emit(AddStocksInitial(status: true, message: "", data: data));
      });
    });
  }
}

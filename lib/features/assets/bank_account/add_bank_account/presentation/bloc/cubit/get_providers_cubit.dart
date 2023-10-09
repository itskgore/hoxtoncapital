import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/provider_records_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/domain/usecases/get_providers.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/domain/usecases/get_top_institutes.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/domain/usecases/params.dart';

part 'get_providers_state.dart';

class GetProvidersCubit extends Cubit<GetProvidersState> {
  GetProvidersCubit({required this.getTopInstitute, required this.getProviders})
      : super(GetProvidersLoading());

  final GetProviders getProviders;
  final GetTopInstitute getTopInstitute;
  ProviderResponseEntity fixedData = ProviderResponseEntity(
      cursor: ProviderCursorEntity(
        currentPage: 0,
        perPage: 0,
        totalRecords: 0,
      ),
      records: []);

  getData(String country) {
    if (country.isEmpty) {
      emit(GetProvidersLoading());
    }
    final result = getTopInstitute(ProviderParams(param: country));
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData(country);
        } else {
          return emit(GetProvidersError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        fixedData = data;
        emit(GetProvidersLoaded(
            data: fixedData, searchData: data, textFieldClicked: false));
      });
    });
  }

  searchData(String name, bool textfieldClicked) {
    final result = getProviders(ProviderParams(param: name));
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          searchData(name, textfieldClicked);
        } else {
          emit(GetProvidersError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        emit(GetProvidersLoaded(
            data: fixedData,
            searchData: data,
            textFieldClicked: textfieldClicked));
      });
    });
  }
}

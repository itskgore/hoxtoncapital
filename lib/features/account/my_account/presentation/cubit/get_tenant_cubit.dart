import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/data_models/tenant_model.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../../domain/usecase/get_tenant_usecase.dart';

part 'get_tenant_state.dart';

class GetTenantCubit extends Cubit<GetTenantState> {
  GetTenantCubit({required this.getTenantUseCase}) : super(GetTenantInitial());
  GetTenantUseCase getTenantUseCase;

  getTanent() {
    emit(GetTenantLoading());
    final result = getTenantUseCase(NoParams());
    result.then((value) =>
        value.fold((l) => emit(GetTenantError(l.displayErrorMessage())), (r) {
          emit(GetTenantLoaded(r));
        }));
  }
}

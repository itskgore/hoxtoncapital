import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/contants/enums.dart';
import 'package:wedge/core/entities/dashboard_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/home/domain/usecase/get_dashboard_usecase.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  GetDashboardData getDashboardDataUseCase;

  DashboardCubit({required this.getDashboardDataUseCase})
      : super(DashboardInitial());

  getDashboardData({required bool shouldLoad}) {
    if (shouldLoad) {
      emit(DashboardLoading());
    }
    final result = getDashboardDataUseCase(NoParams());
    result.then((value) => value.fold((error) {
          if (error is TokenExpired) {
            getDashboardData(shouldLoad: false);
          } else {
            emit(DashboardError(error: error.displayErrorMessage()));
          }
        }, (r) {
          emit(DashboardLoading());
          emit(DashboardLoaded(data: r));
        }));
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/pension_report_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/user_services/generic_domain/generic_usecases/get_pension_report_usecase.dart';

part 'pension_report_state.dart';

class PensionReportRecordsCubit extends Cubit<PensionReportRecordsState> {
  final GetPensionReportUsecase getPensionReportUsecase;

  PensionReportRecordsCubit(this.getPensionReportUsecase)
      : super(PensionReportRecordsInitial());

  getData(
    String urlParameters,
  ) async {
    emit(PensionReportRecordsLoading());
    final result = getPensionReportUsecase(urlParameters);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getData(urlParameters);
        } else {
          emit(PensionReportRecordsError(error: l.displayErrorMessage()));
        }
      }, (data) {
        emit(PensionReportRecordsLoaded(
          data: data,
        ));
      });
    });
  }
}

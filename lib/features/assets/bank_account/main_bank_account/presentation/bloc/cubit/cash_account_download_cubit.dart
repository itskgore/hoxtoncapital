import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/common/domain/usecases/excel_download.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';

import '../../../../../../../core/error/failures.dart';

part 'cash_account_download_state.dart';

class CashAccountDownloadCubit extends Cubit<CashAccountDownloadState> {
  final ExcelDownload excelDownload;

  CashAccountDownloadCubit(this.excelDownload)
      : super(CashAccountDownloadInitial());

  downloadSummary({required String aggregatorId, required String month}) {
    final result =
        excelDownload({'aggregatorAccountId': aggregatorId, 'month': month});
    result.then((value) => value.fold((l) {
          if (l is TokenExpired) {
            downloadSummary(aggregatorId: aggregatorId, month: month);
          } else {
            emit(CashAccountDownloadError(
                l.responseMsg ?? l.displayErrorMessage()));
          }
        }, (r) async {
          await exportTextAsCSV(r);
          emit(CashAccountDownloadLoaded());
        }));
  }
}

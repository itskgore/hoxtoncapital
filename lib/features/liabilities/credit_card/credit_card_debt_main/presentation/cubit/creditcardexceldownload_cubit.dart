import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/common/domain/usecases/excel_download.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';

part 'creditcardexceldownload_state.dart';

class CreditCardExcelDownloadCubit extends Cubit<CreditCardExcelDownloadState> {
  ExcelDownload excelDownload;

  CreditCardExcelDownloadCubit(this.excelDownload)
      : super(CreditcardexceldownloadInitial());

  downloadSummary({required String aggregatorId, required String month}) {
    final result =
        excelDownload({'aggregatorAccountId': aggregatorId, 'month': month});
    result.then((value) => value.fold((l) {
          if (l is TokenExpired) {
            downloadSummary(aggregatorId: aggregatorId, month: month);
          } else {
            emit(CreditcardexceldownloadError(
                l.responseMsg ?? l.displayErrorMessage()));
          }
        }, (r) async {
          await exportTextAsCSV(r);
          emit(CreditcardexceldownloadLoaded());
        }));
  }
}

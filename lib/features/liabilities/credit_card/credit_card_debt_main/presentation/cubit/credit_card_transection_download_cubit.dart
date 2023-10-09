// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../../../core/error/failures.dart';
// import '../../domain/repository/credit_card_repository.dart';
// import 'credit_card_transaction_state.dart';
//
// class CreditCardTransactionDownloadCubit
//     extends Cubit<CreditCardTransactionState> {
//   // final GetDownloadCreditCardTransaction getDownloadCreditCardTransaction;
//   late dynamic transactionDate;
//
//   CreditCardTransactionDownloadCubit({
//     required this.getDownloadCreditCardTransaction,
//   }) : super(CreditCardTransactionInitial());
//
//   getCreditCardTransactionDownloadedData(
//       {required String month, required String aggregatorAccountId}) {
//     emit(CreditCardTransactionLoading());
//     final result = getDownloadCreditCardTransaction({
//       "month": month,
//       "aggregatorAccountId": aggregatorAccountId,
//     });
//
//     result.then((value) {
//       value.fold((l) {
//         if (l is TokenExpired) {
//           getCreditCardTransactionDownloadedData(
//               month: month, aggregatorAccountId: aggregatorAccountId);
//         } else {
//           emit(CreditCardTransactionError(l.displayErrorMessage()));
//         }
//       }, (r) {
//         transactionDate = r;
//         emit(CreditCardTransactionDownload(r));
//       });
//     });
//   }
// }

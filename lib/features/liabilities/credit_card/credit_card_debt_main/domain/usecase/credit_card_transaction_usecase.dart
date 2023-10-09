//
// class GetCreditCardTransaction
//     extends UseCase<CardAndCashTransactionModel, Map<String, dynamic>> {
//   final MainCreditCardRepo mainCreditCardRepo;
//   GetCreditCardTransaction(this.mainCreditCardRepo);
//
//   @override
//   Future<Either<Failure, CardAndCashTransactionModel>> call(
//       Map<String, dynamic> params) {
//     return mainCreditCardRepo.getCreditCardTransaction(
//         source: params['source'],
//         date: params['date'],
//         page: params['page'],
//         aggregatorAccountId: params['aggregatorAccountId']);
//   }
// }

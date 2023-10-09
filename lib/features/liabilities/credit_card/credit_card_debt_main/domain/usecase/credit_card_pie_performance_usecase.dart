// import 'package:dartz/dartz.dart';
// import 'package:wedge/core/error/failures.dart';
//
// import '../../../../../../core/usecases/usecase.dart';
// import '../../data/model/credit_card_pie_performance_model.dart';
// import '../repository/credit_card_repository.dart';
//
// class GetCreditCardPiePerformance
//     extends UseCase<List<CreditCardPiePerformanceModel>, Map<String, dynamic>> {
//   final MainCreditCardRepo mainCreditCardRepo;
//   GetCreditCardPiePerformance(this.mainCreditCardRepo);
//
//   @override
//   Future<Either<Failure, List<CreditCardPiePerformanceModel>>> call(
//       Map<String, dynamic> params) {
//     return mainCreditCardRepo.getCreditCardPiePerformance(
//       month: params['month'],
//       aggregatorAccountId: params['aggregatorAccountId'],
//     );
//   }
// }

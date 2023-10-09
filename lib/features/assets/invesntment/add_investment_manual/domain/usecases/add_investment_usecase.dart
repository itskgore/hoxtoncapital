import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/domain/repositories/add_investment_repository.dart';

class AddInvestment implements UseCase<InvestmentEntity, InvestmentParams> {
  final AddInvestmentRepository repository;

  AddInvestment(this.repository);

  @override
  Future<Either<Failure, InvestmentEntity>> call(
      InvestmentParams params) async {
    return await repository.addInvestment("", params.name, params.country,
        params.policyNumber, params.initialValue, params.currentValue);
  }
}

class InvestmentParams extends Equatable {
  late final String id;
  late final String name;
  late final String country;
  late final String policyNumber;
  late final ValueEntity initialValue;
  late final ValueEntity currentValue;

  InvestmentParams({
    required this.id,
    required this.name,
    required this.country,
    required this.policyNumber,
    required this.initialValue,
    required this.currentValue,
  });

  @override
  List<Object> get props =>
      [id, name, country, policyNumber, initialValue, currentValue];
}

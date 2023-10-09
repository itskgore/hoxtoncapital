part of 'aggregation_result_cubit.dart';

abstract class AggregationResultState extends Equatable {
  const AggregationResultState();

  @override
  List<Object> get props => [];
}

class AggregationResultInitial extends AggregationResultState {}

class AggregationResultLoading extends AggregationResultState {}

class AggregationResultLoaded extends AggregationResultState {
  final AssetLiabilitiesChartEntity assetLiabilitiesChartEntity;
  final List<Map<String, dynamic>> series;
  final List<Map<String, dynamic>> modelIds;

  const AggregationResultLoaded(
      {required this.assetLiabilitiesChartEntity,
      required this.series,
      required this.modelIds});
}

class AggregationResultError extends AggregationResultState {
  final String errorMsg;

  const AggregationResultError(this.errorMsg);
}

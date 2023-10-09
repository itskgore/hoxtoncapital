part of 'aggregator_reconnect_cubit.dart';

abstract class AggregatorReconnectState extends Equatable {
  const AggregatorReconnectState();

  @override
  List<Object> get props => [];
}

class AggregatorReconnectInitial extends AggregatorReconnectState {}

class AggregatorReconnectLoading extends AggregatorReconnectState {}

class AggregatorReconnectLoaded extends AggregatorReconnectState {
  final Map<String, dynamic> reconnectData;

  const AggregatorReconnectLoaded(this.reconnectData);
}

class AggregatorReconnectError extends AggregatorReconnectState {
  final String errorMsg;

  const AggregatorReconnectError(this.errorMsg);
}

part of 'get_account_data_cubit.dart';

abstract class GetAccountDataState extends Equatable {
  const GetAccountDataState();

  @override
  List<Object> get props => [];
}

class GetAccountDataInitial extends GetAccountDataState {}

class GetAccountDataLoading extends GetAccountDataState {}

class GetAccountDataLoaded extends GetAccountDataState {
  final AssetLiabilityOnboardingListEntity data;

  const GetAccountDataLoaded({
    required this.data,
  });
}

class GetAccountDataLoadedButEmpty extends GetAccountDataState {}

class GetAccountDataError extends GetAccountDataState {
  final String errorMsg;

  const GetAccountDataError(this.errorMsg);
}

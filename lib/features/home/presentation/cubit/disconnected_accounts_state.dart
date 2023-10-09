import 'package:flutter/cupertino.dart';

import '../../data/model/disconnected_account_entity.dart';

@immutable
abstract class DisconnectedAccountsState {}

class DisconnectedAccountsInitialState extends DisconnectedAccountsState {}

class DisconnectedAccountsLoadingState extends DisconnectedAccountsState {}

class DisconnectedAccountsLoadedState extends DisconnectedAccountsState {
  final List<DisconnectedAccountsEntity> disconnectedAccounts;

  DisconnectedAccountsLoadedState(this.disconnectedAccounts);
}

class DisconnectedAccountsErrorState extends DisconnectedAccountsState {
  final String error;

  DisconnectedAccountsErrorState(this.error);
}

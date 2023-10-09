import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ask_auth_state.dart';

class AskAuthCubit extends Cubit<AskAuthState> {
  AskAuthCubit() : super(AskAuthInitial());

  switchToggle(bool val) {
    if (val) {
      emit(AskAuthInitial());
    } else {
      emit(AskAuthLoading());
    }
  }
}

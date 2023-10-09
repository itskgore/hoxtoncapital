import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'passcode_login_state.dart';

class PasscodeLoginCubit extends Cubit<PasscodeLoginState> {
  PasscodeLoginCubit() : super(PasscodeLoginInitial());
}

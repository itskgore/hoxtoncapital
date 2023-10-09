import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/auth/personal_details/presentation/cubit/personal_details_state.dart';

import '../../../../../app.dart';
import '../../../../../core/config/app_config.dart';
import '../../../../../core/helpers/navigators.dart';
import '../../../../home/presentation/pages/home_page.dart';
import '../../domain/usecases/personal_details_usecase.dart';
import '../pages/welcome_screen.dart';

class PersonalDetailsCubit extends Cubit<PersonalDetailsState> {
  PersonalDetailsCubit({required this.personalDetailsUseCase})
      : super(PersonalDetailsInitial());
  final PersonalDetailsUseCase personalDetailsUseCase;

  updatePersonalDetails(dynamic body) {
    emit(PersonalDetailsLoading());
    final result = personalDetailsUseCase(body);
    result.then((value) => value.fold((l) {
          if (l is TokenExpired) {
            updatePersonalDetails(body);
          } else {
            emit(PersonalDetailsError(l.displayErrorMessage()));
          }
        }, (r) async {
          final userData = LoginModel.fromJson(jsonDecode(
              locator<SharedPreferences>()
                      .getString(RootApplicationAccess.loginUserPreferences) ??
                  ""));
          userData.isProfileCompleted = true;
          locator<SharedPreferences>().setString(
              RootApplicationAccess.loginUserPreferences, jsonEncode(userData));
          emit(PersonalDetailsLoaded(personDetailsModel: r));

          final userdata = locator<SharedPreferences>()
                  .getString(RootApplicationAccess.loginUserPreferences) ??
              "";
          final data = LoginModel.fromJson(json.decode(userdata));
          await Future.delayed(const Duration(seconds: 2));
          if (data.isOnboardingCompleted) {
            cupertinoNavigator(
                context: navigatorKey.currentContext!,
                screenName: HomePage(),
                type: NavigatorType.PUSHREMOVEUNTIL);
          } else {
            cupertinoNavigator(
                context: navigatorKey.currentContext!,
                screenName: const WelcomeScreen(),
                type: NavigatorType.PUSHREMOVEUNTIL);
          }
        }));
  }
}

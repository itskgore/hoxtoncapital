import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/helpers/biometrics_auth.dart';
import 'package:wedge/core/widgets/dialog/wedge_new_custom_dialog_box.dart';
import 'package:wedge/dependency_injection.dart';

part 'enable_biometric_switch_state.dart';

class EnableBiometricSwitchCubit extends Cubit<EnableBiometricSwitchState> {
  EnableBiometricSwitchCubit() : super(EnableBiometricSwitchInitial());

  enableBioMetrics({required bool selection}) async {
    if (await BioMetricsAuth().checkIfDeviceHasBiometrics()) {
      locator<SharedPreferences>().setBool(
          RootApplicationAccess.isUserBioMetricIsEnabledPreference, selection);
      emit(EnableBiometricSwitchInitial());
      if (selection) {
        emit(EnableBiometricSwitchIsSelected());
        await Future.delayed(const Duration(seconds: 1));
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async {
                // Return false to restrict the back button when the dialog is visible
                return false;
              },
              child: NewCustomDialogBox(
                onPressedPrimary: () {
                  Navigator.pop(context);
                },
                title: 'Biometrics enabled',
                primaryButtonText: "Continue",
                description:
                    'You have successfully enabled biometrics for Hoxton app.',
              ),
            );
          },
        );
      }
    } else {
      emit(EnableBiometricSwitchIsNotSelected());
      await Future.delayed(const Duration(seconds: 1));
      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              // Return false to restrict the back button when the dialog is visible
              return false;
            },
            child: NewCustomDialogBox(
              isSuccess: false,
              onPressedPrimary: () {
                Navigator.pop(context);
              },
              title: 'Biometrics Not Enabled',
              primaryButtonText: "Continue",
              showWarningIcon: true,
              description:
                  'Please enable biometrics on your mobile device to start using biometrics login on the Hoxton App.',
            ),
          );
        },
      );
    }
  }

  checkIfEnabled() {
    emit(EnableBiometricSwitchLoading());
    BioMetricsAuth().checkIfDeviceHasBiometrics().then((value) {
      if (value) {
        final bool isUserBioMetricIsEnabled = locator<SharedPreferences>()
                .getBool(
                    RootApplicationAccess.isUserBioMetricIsEnabledPreference) ??
            false;
        if (isUserBioMetricIsEnabled) {
          emit(EnableBiometricSwitchIsSelected());
        } else {
          emit(EnableBiometricSwitchIsNotSelected());
        }
      } else {
        emit(EnableBiometricSwitchIsNotSelected());
      }
    });
  }
}

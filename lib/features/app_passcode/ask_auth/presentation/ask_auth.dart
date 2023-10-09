import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/app_passcode/ask_auth/cubit/ask_auth_cubit.dart';

class AskAuth extends StatefulWidget {
  final Function(bool) onTap;

  const AskAuth({Key? key, required this.onTap}) : super(key: key);

  @override
  State<AskAuth> createState() => _AskAuthState();
}

class _AskAuthState extends State<AskAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              translate!.authenticationRequired,
              style: TitleHelper.h9,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              translate!.selectTheAuthenticationType,
              style: SubtitleHelper.h10.copyWith(height: 1.7),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    locator<SharedPreferences>().setBool(
                        RootApplicationAccess.authBioSelectedPreferences, true);
                    widget.onTap(true);
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/fingerprint.svg",
                        width: 100,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        translate!.bioMetrics,
                        style: SubtitleHelper.h9,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    locator<SharedPreferences>().setBool(
                        RootApplicationAccess.authBioSelectedPreferences,
                        false);
                    widget.onTap(false);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/pincode.png",
                        width: 100,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        translate!.appPasscode,
                        style: SubtitleHelper.h9,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Text(
                  translate!.setAsDefaultForFuture,
                  style: SubtitleHelper.h9.copyWith(height: 1.7),
                ),
                const Spacer(),
                BlocProvider(
                  create: (context) => AskAuthCubit(),
                  child: BlocBuilder<AskAuthCubit, AskAuthState>(
                    bloc: context.read<AskAuthCubit>().switchToggle(true),
                    builder: (context, state) {
                      return Transform.scale(
                        scale: 0.9,
                        child: CupertinoSwitch(
                          activeColor: appThemeColors!.primary,
                          value: state is AskAuthInitial,
                          onChanged: (v) {
                            context.read<AskAuthCubit>().switchToggle(v);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

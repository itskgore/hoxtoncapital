import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';

import '../../../../../dependency_injection.dart';
import '../cubit/user_account_cubit.dart';

class GetUserName extends StatefulWidget {
  const GetUserName({Key? key}) : super(key: key);

  @override
  State<GetUserName> createState() => _GetUserNameState();
}

class _GetUserNameState extends State<GetUserName> {
  String userName = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      userName = getUserNameFromAccessToken() ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return userName.isEmpty
        ? BlocConsumer<UserAccountCubit, UserAccountState>(
            listener: (context, state) {
              if (state is UserAccountError) {
                showSnackBar(context: context, title: state.errorMsg);
              }
              if (state is UserAccountLoaded) {
                locator<SharedPreferences>().setString(
                    RootApplicationAccess.usernameFullNamePreferences,
                    "${state.userAccountDataEntity.firstName} ${state.userAccountDataEntity.lastName}");
              }
            },
            builder: (context, state) {
              if (state is UserAccountLoading) {
                return buildCircularProgressIndicator();
              } else if (state is UserAccountError) {
                return Text(translate!.hello,
                    style: TitleHelper.h8.copyWith(
                        color: appThemeColors!.textLight,
                        fontWeight: FontWeight.w400));
              } else if (state is UserAccountLoaded) {
                return Text(
                    "${translate!.hello}, ${state.userAccountDataEntity.firstName}",
                    style: SubtitleHelper.h8.copyWith(
                        color: appThemeColors!.textLight,
                        fontWeight: FontWeight.w400));
              } else {
                return Container();
              }
            },
          )
        : Text("${translate!.hello}, $userName",
            style: SubtitleHelper.h8.copyWith(
                color: appThemeColors!.textLight, fontWeight: FontWeight.w400));
  }
}

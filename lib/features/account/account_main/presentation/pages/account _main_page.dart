import 'package:flutter/material.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/contants/string_contants.dart';
import '../../../../../core/utils/wedge_app_bar.dart';
import '../../../my_account/presentation/pages/user_account_main.dart';
import '../../../third_party_access/presentation/pages/third_party_access_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: translate!.account_label,
            bottom: TabBar(
                labelColor: appThemeColors?.primary,
                labelPadding: const EdgeInsets.all(10),
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                indicatorColor: appThemeColors?.primary,
                tabs: [
                  Text(
                    translate.myAccount,
                  ),
                  Text(translate.advisoryTeamAccess)
                ])),
        body: TabBarView(
          children: [UserAccountMain(), const ThirdPartyAccessPage()],
        ),
      ),
    );
  }
}

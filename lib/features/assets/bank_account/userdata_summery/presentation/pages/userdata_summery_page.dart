import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dialog/dashboard_value_card.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/presentation/bloc/cubit/userdatasummery_cubit.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/presentation/widgets/user_summery_card.dart';

import '../../../../../all_accounts_types/presentation/pages/all_account_types.dart';

class UserDataSummeryPage extends StatefulWidget {
  @override
  _UserDataSummeryPageState createState() => _UserDataSummeryPageState();
}

class _UserDataSummeryPageState extends State<UserDataSummeryPage> {
  bool _stateAlive = true; //to control the listener
  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);

    return BlocConsumer<UserDataSummeryCubit, UserDataSummeryState>(
      bloc: context.read<UserDataSummeryCubit>().getHoxtonDataSummery(),
      listenWhen: (context, state) =>
          _stateAlive && state is UserDataSummeryLoaded,
      listener: (context, state) {
        if (state is UserDataSummeryLoaded) {
          if (state.data.investments.isEmpty && state.data.pensions.isEmpty) {
            _stateAlive = false;
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        // AddBankAccountPage()

                        const AllAccountTypes()));
          }
        }
        if (state is UserDataSummeryError) {
          showSnackBar(context: context, title: state.errorMsg);
        }
      },
      builder: (context, state) {
        if (state is UserDataSummeryLoaded) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              actions: [getWireDashIcon(context)],
              title: Text(
                "${translate!.hello} ${state.clientName}",
                style: const TextStyle(
                    fontSize: 19, fontFamily: kSecondortfontFamily),
              ),
              bottom: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 0.0),
                  child: Text(translate.userdataSummeryTitle)),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: kpadding, right: kpadding),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  DashboardValueCard(
                      mainValue:
                          "${state.data.summary.total.currency} ${state.data.summary.total.amount}",
                      mainTitle: translate.totalPensionsInvestmentsValue,
                      leftValue:
                          "${state.data.summary.pensions.currency} ${state.data.summary.pensions.amount} ",
                      leftTitle: translate.pensions,
                      rightTitle: translate.investments,
                      rightvalue:
                          "${state.data.summary.investments.currency} ${state.data.summary.investments.amount} "),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "${translate.your} ${translate.pensions} (${state.data.pensions.length})",
                          style: const TextStyle(
                              fontSize: kfontMedium,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: state.data.pensions.length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PensionCard(
                                currentvalue:
                                    "${state.data.pensions[index].currentValue.currency} ${state.data.pensions[index].currentValue.amount}",
                                name: state.data.pensions[index].name,
                                policyNumber:
                                    state.data.pensions[index].policyNumber),
                          );
                        }),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "${translate.your} ${translate.investments} (${state.data.investments.length})",
                          style: const TextStyle(
                              fontSize: kfontMedium,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: state.data.investments.length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PensionCard(
                                currentvalue:
                                    "${state.data.investments[index].currentValue.currency} ${state.data.investments[index].currentValue.amount}",
                                name: state.data.investments[index].name,
                                policyNumber:
                                    state.data.investments[index].policyNumber),
                          );
                        }),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 50,
                child: MaterialButton(
                  color: appThemeColors!.primary,
                  // style: ElevatedButton.styleFrom(primary: appThemeColors!.primary),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                // AddBankAccountPage()
                                const AllAccountTypes()));
                  },
                  child: Text(
                    translate.next,
                    style: const TextStyle(
                        fontSize: kfontMedium, color: kfontColorLight),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Builder(builder: (context) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          });
        }
      },
    );
  }
}

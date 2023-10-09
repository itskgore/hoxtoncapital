import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/firebase_analytics.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/features/calculators/opportunity_cost_calculator/presentation/pages/opportunity_calculator_page.dart';
import 'package:wedge/features/calculators/retirement_calculator/presentation/pages/retirement_calculator.dart';
import 'package:wedge/features/home/presentation/pages/home_page.dart';

class CalculatorMainPage extends StatelessWidget {
  bool? isFromDashboard;

  CalculatorMainPage({Key? key, this.isFromDashboard}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return WillPopScope(
      onWillPop: () async {
        if (isFromDashboard ?? false) {
          return true;
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: appThemeColors!.bg,
        key: scaffoldKey,
        appBar: wedgeAppBar(
          context: context,
          title: translate!.calculators,
          leadingIcon: GestureDetector(
              onTap: () {
                if (isFromDashboard ?? false) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const HomePage()),
                      (Route<dynamic> route) => false);
                }
              },
              child: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 120.0,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/icons/calculators_main.png'),
                    fit: BoxFit.fill,
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  translate.calculatorsMainScreenSubtitle,
                  textAlign: TextAlign.left,
                  style: SubtitleHelper.h10.copyWith(
                    height: 1.8,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                mainButtons(
                    onTap: () {
                      AppAnalytics().trackScreen(
                          screenName: "Opportunity Calculator",
                          parameters: {'screenName': 'Opportunity Calculator'});
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  OpportunityCalculatorPage()));
                    },
                    title: translate.opportunityCostCalculator),
                mainButtons(
                    onTap: () {
                      AppAnalytics().trackScreen(
                          screenName: "Opportunity Calculator",
                          parameters: {'screenName': 'Opportunity Calculator'});
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  RetirementCalculator()));
                    },
                    title: translate.retirementCalculator),
                // mainButtons(
                //     onTap: () {
                //       Navigator.push(
                //           context,
                //           CupertinoPageRoute(
                //               builder: (BuildContext context) =>
                //                   RetirementWithdrawalCalculator()));
                //     },
                //     title: "Retirement Withdrawal Calculator"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container mainButtons({required String title, required Function onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appThemeColors!.textLight,
        boxShadow: [
          BoxShadow(
              color: appThemeColors!.textDark!.withOpacity(0.122),
              blurRadius: 10.0,
              spreadRadius: 1.5),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          onTap: () {
            onTap();
          },
          title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: appThemeColors!.primary),
          ),
          trailing: const Icon(
            Icons.arrow_right,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

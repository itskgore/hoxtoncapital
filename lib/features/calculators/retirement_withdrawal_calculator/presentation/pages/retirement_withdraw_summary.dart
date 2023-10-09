import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/calculators/retirement_withdrawal_calculator/presentation/pages/retirement_withdraw_calculator.dart';

class RetirementWithdrawSummary extends StatefulWidget {
  const RetirementWithdrawSummary({Key? key}) : super(key: key);

  @override
  _RetirementWithdrawSummaryState createState() =>
      _RetirementWithdrawSummaryState();
}

class _RetirementWithdrawSummaryState extends State<RetirementWithdrawSummary> {
  // Keys
  var scaffoldKey = GlobalKey<ScaffoldState>();

  setMail() {
    locator.get<WedgeDialog>().success(
        context: context,
        title:
            "The complete retirement projection report has been emailed to your registered email id.",
        info: "",
        onClicked: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      key: scaffoldKey,
      appBar: wedgeAppBar(
          context: context,
          title: "Retirement Withdrawal Calculator",
          leadingIcon: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              ))),
      bottomNavigationBar: BottomNavSingleButtonContainer(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: appThemeColors!.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        RetirementWithdrawalCalculator()));
          },
          child: const Text(
            "Re calculate",
            style: TextStyle(fontSize: kfontMedium, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Column(
                  children: [
                    Text("16,758,242",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextHelper.h1.copyWith(
                            color: kDashboardValueMainTextColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            fontFamily: kSecondortfontFamily)),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Total withdrawals",
                      style: TextStyle(
                        // color: kDashboardValueMainTextColor,
                        fontSize: kfontMedium,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              getRowData(
                  subTitle1: "Total interest earned",
                  subTitle2: "Number of payouts",
                  title1: "AED 15,234,651",
                  title2: "582"),
              getRowData(
                  subTitle1: "Initial withdrawal",
                  subTitle2: "Final payout",
                  title1: "AED 17,541",
                  title2: "45,395"),
              getRowData(
                  subTitle1: "Age at retirement",
                  subTitle2: "Age at last payout",
                  title1: "65",
                  title2: "110"),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Text("Balance",
                    style: TextHelper.h3.copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                width: double.infinity,
                color: kDividerColor,
                child: const Center(
                  child: Text("Chart"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  setMail();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/download_icon.png",
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Email full report",
                      style: TextHelper.h5
                          .copyWith(color: const Color(0xfff428DFF)),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getRowData(
      {required String title1,
      required String subTitle1,
      required String title2,
      required String subTitle2}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          rowContainer(title1, subTitle1),
          const SizedBox(
            width: 20,
          ),
          rowContainer(title2, subTitle2),
        ],
      ),
    );
  }

  Expanded rowContainer(String title1, String subTitle1) {
    return Expanded(
        child: Container(
      height: 75,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$title1",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextHelper.h5.copyWith(
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(
              height: 5,
            ),
            Text("$subTitle1",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextHelper.h6.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                )),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: const Color(0xfffEAEBE1),
          borderRadius: BorderRadius.circular(10)),
    ));
  }
}

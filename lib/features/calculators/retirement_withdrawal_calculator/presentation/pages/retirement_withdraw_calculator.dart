import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/features/calculators/calculator_main_page/presentation/pages/calculator_main_page.dart';
import 'package:wedge/features/calculators/retirement_withdrawal_calculator/presentation/pages/retirement_withdraw_form.dart';
import 'package:wedge/features/calculators/retirement_withdrawal_calculator/presentation/widgets/indicators.dart';

class RetirementWithdrawalCalculator extends StatefulWidget {
  RetirementWithdrawalCalculator({Key? key}) : super(key: key);

  @override
  State<RetirementWithdrawalCalculator> createState() =>
      _RetirementWithdrawalCalculatorState();
}

class _RetirementWithdrawalCalculatorState
    extends State<RetirementWithdrawalCalculator> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  double currentAge = 60.0;
  double retirementAge = 60.0;

  changeVal(double value, bool isCurrentAge) {
    setState(() {
      if (isCurrentAge) {
        currentAge = value;
      } else {
        retirementAge = value;
      }
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
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => CalculatorMainPage()),
                    (Route<dynamic> route) => false);
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
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        const RetirementWithdrawForm()));
          },
          child: const Text(
            "Next",
            style: TextStyle(fontSize: kfontMedium, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              RetirementCalculatorIndicators(
                isFirst: true,
                indicators: [
                  {
                    'isSelected': true,
                  },
                  {
                    'isSelected': false,
                  }
                ],
              ),
              Text(
                "Please use the slider below to set your current age and retirement age",
                style: TextHelper.h5
                    .copyWith(height: 1.6, color: const Color(0xfff4F4F4F)),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Column(
                        children: List.generate(
                            29,
                            (index) => index == 0
                                ? const Text("60")
                                : index == 28
                                    ? const Text("20")
                                    : Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10.6),
                                        height: 1,
                                        width: 20,
                                        decoration: const BoxDecoration(
                                            color: Colors.transparent),
                                      )),
                      ),
                      Container(
                        height: 400,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Container(
                            child: Slider(
                              activeColor: const Color(0xfff428DFF),
                              inactiveColor: const Color(0xfffEAEBE1),
                              value: currentAge,
                              min: 20.0,
                              max: 60.0,
                              // divisions: 30,
                              // label: val.toString(),
                              onChanged: (double newValue) {
                                changeVal(newValue, true);
                              },
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: List.generate(
                            41,
                            (index) => Container(
                                  margin: const EdgeInsets.only(bottom: 7.6),
                                  height: 1,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                      color: Color(0xfffCFCFCF)),
                                )),
                      ),

                      // Column(
                      //   children: List.generate(31, (index) {
                      //     if (index == 0) {
                      //       return Text("40");
                      //     } else if (index == 30) {
                      //       return Text("70");
                      //     } else {
                      //       return Container(

                      //       );
                      //     }
                      //   }),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      Column(
                        children: List.generate(
                            41,
                            (index) => Container(
                                  margin: const EdgeInsets.only(bottom: 7.6),
                                  height: 1,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                      color: Color(0xfffCFCFCF)),
                                )),
                      ),
                      Container(
                        height: 400,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Container(
                            child: Slider(
                              activeColor: const Color(0xfff428DFF),
                              inactiveColor: const Color(0xfffEAEBE1),
                              value: retirementAge,
                              min: 40.0,
                              max: 70.0,
                              // divisions: 30,
                              // label: val.toString(),
                              onChanged: (double newValue) {
                                changeVal(newValue, false);
                              },
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: List.generate(
                            29,
                            (index) => index == 0
                                ? const Text("70")
                                : index == 28
                                    ? const Text("40")
                                    : Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10.6),
                                        height: 1,
                                        width: 20,
                                        decoration: const BoxDecoration(
                                            color: Colors.transparent),
                                      )),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "${currentAge.round()}",
                        style:
                            TextHelper.h4.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Current Age",
                        style: TextHelper.h6,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${retirementAge.round()}",
                        style:
                            TextHelper.h4.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Retirement age",
                        textAlign: TextAlign.center,
                        style: TextHelper.h6,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

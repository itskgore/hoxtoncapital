import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/features/calculators/calculator_main_page/presentation/pages/calculator_main_page.dart';
import 'package:wedge/features/calculators/retirement_calculator/presentation/pages/retirement_calculator_form.dart';
import 'package:wedge/features/calculators/retirement_withdrawal_calculator/presentation/widgets/indicators.dart';

class RetirementCalculator extends StatefulWidget {
  RetirementCalculator({Key? key}) : super(key: key);

  @override
  State<RetirementCalculator> createState() => _RetirementCalculatorState();
}

class _RetirementCalculatorState extends State<RetirementCalculator> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  double currentAge = 20.0;
  double retirementAge = 60.0;

  changeVal(double value, bool isCurrentAge) {
    setState(() {
      if (isCurrentAge) {
        currentAge = value;
      } else {
        retirementAge = value;
      }
    });
    // print(retirementAge);
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      key: scaffoldKey,
      appBar: wedgeAppBar(
        context: context,
        title: translate!.retirementCalculator,
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
            )),
      ),
      bottomNavigationBar: BottomNavSingleButtonContainer(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: appThemeColors!.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            if (retirementAge >= currentAge) {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          RetirementCalculatorForm(
                            retirementAge:
                                int.parse(retirementAge.toStringAsFixed(0)),
                            currentAge:
                                int.parse(currentAge.toStringAsFixed(0)),
                          )));
            } else {
              showSnackBar(
                  context: context, title: translate.retirementAgeValidation);
            }
          },
          child: Text(
            translate.next,
            style: TextStyle(
                fontSize: appThemeHeadlineSizes!.h9,
                color: appThemeColors!.textLight),
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
                indicators: const [
                  {
                    'isSelected': true,
                  },
                  {
                    'isSelected': false,
                  },
                  {
                    'isSelected': false,
                  }
                ],
              ),
              Text(
                translate.retirementCalculatorDescription,
                style: SubtitleHelper.h10.copyWith(
                    height: 1.6, color: const Color.fromRGBO(79, 79, 79, 1)),
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
                              activeColor: appThemeColors!.outline,
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
                              activeColor: appThemeColors!.outline,
                              inactiveColor: const Color(0xfffEAEBE1),
                              value: retirementAge,
                              min: 40.0,
                              max: 70.0,
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
                        style: SubtitleHelper.h9
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        translate.currentAge,
                        style: SubtitleHelper.h11,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${retirementAge.round()}",
                        style: SubtitleHelper.h9
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        translate.retirementAge,
                        textAlign: TextAlign.center,
                        style: SubtitleHelper.h11,
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

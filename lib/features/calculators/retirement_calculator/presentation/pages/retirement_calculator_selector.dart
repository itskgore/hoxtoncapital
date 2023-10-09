import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/features/calculators/retirement_calculator/presentation/bloc/cubit/calculator_insights_cubit.dart';
import 'package:wedge/features/calculators/retirement_calculator/presentation/pages/retirement_summary.dart';
import 'package:wedge/features/calculators/retirement_withdrawal_calculator/presentation/widgets/indicators.dart';

class RetirementCalculatorSelector extends StatefulWidget {
  final currentAnnualIncome;
  final currentMonthlyRetirementSaving;
  final expectedAnnulRetirement;
  final expectedAnnualgrowth;
  final expectedAnnulGRateAfterRetirement;
  final inflation;
  final currentAge;
  final retirementAge;

  const RetirementCalculatorSelector(
      {Key? key,
      required this.currentAnnualIncome,
      required this.currentMonthlyRetirementSaving,
      required this.expectedAnnualgrowth,
      required this.expectedAnnulGRateAfterRetirement,
      required this.expectedAnnulRetirement,
      required this.inflation,
      required this.currentAge,
      required this.retirementAge})
      : super(key: key);

  @override
  _RetirementCalculatorSelectorState createState() =>
      _RetirementCalculatorSelectorState();
}

class _RetirementCalculatorSelectorState
    extends State<RetirementCalculatorSelector> {
  // Keys
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextFieldValidator _validator = TextFieldValidator();

  final TextEditingController _cashSavingsTowardsRetirement =
      TextEditingController();
  final TextEditingController _monthlyIncomePostRetirement =
      TextEditingController();

  // Controllers
  List<PensionsInsightsEntity> pensions = [];
  List<InvestmentsInsightsEntity> investments = [];

  @override
  void dispose() {
    _cashSavingsTowardsRetirement.dispose();
    _monthlyIncomePostRetirement.dispose();
    super.dispose();
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
              Navigator.pop(context);
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
            print(pensions.length);
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => RetirementSummaryPage(
                          cashSavingsTowardsRetirement:
                              _cashSavingsTowardsRetirement.text,
                          currentAge: widget.currentAge,
                          currentAnnualIncome: widget.currentAnnualIncome,
                          currentMonthlyRetirementSaving:
                              widget.currentMonthlyRetirementSaving,
                          expectedAnnualgrowth: widget.expectedAnnualgrowth,
                          expectedAnnulGRateAfterRetirement:
                              widget.expectedAnnulGRateAfterRetirement,
                          expectedAnnulRetirement:
                              widget.expectedAnnulRetirement,
                          inflation: widget.inflation,
                          investments: investments,
                          monthlyIncomePostRetirement:
                              _monthlyIncomePostRetirement.text,
                          pensions: pensions,
                          retirementAge: widget.retirementAge,
                        )));
            // submit();
          },
          child: Text(
            translate.calculate,
            style: TextStyle(
                fontSize: appThemeSubtitleSizes!.h9,
                color: appThemeColors!.textLight),
          ),
        ),
      ),
      body: BlocBuilder<CalculatorInsightsCubit, CalculatorInsightsState>(
        bloc: context.read<CalculatorInsightsCubit>().getData(),
        builder: (context, state) {
          if (state is CalculatorInsightsLoaded) {
            return SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      RetirementCalculatorIndicators(
                        isFirst: false,
                        indicators: const [
                          {
                            'isSelected': true,
                          },
                          {
                            'isSelected': true,
                          },
                          {
                            'isSelected': true,
                          }
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: (state.data!.pensions.details.isNotEmpty),
                        child: Container(
                          width: double.infinity,
                          child: Text(translate.selectYourPensions,
                              style: TitleHelper.h10.copyWith(),
                              textAlign: TextAlign.left),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: List.generate(
                            state.data!.pensions.details.length, (index) {
                          final data = state.data!.pensions.details[index];
                          bool isChecked = pensions
                              .where((e) => e.id == data.id)
                              .toList()
                              .isNotEmpty;
                          return buildCheckContainers(index, data, isChecked,
                              onTap: (_) {
                            if (_) {
                              setState(() {
                                pensions.add(data);
                                // print(pensions);
                              });
                            } else {
                              setState(() {
                                int i = pensions.indexWhere(
                                    (element) => element.id == data.id);
                                pensions.removeAt(i);
                                // print(i);
                              });
                            }
                          });
                        }),
                      ),
                      Visibility(
                        visible: (state.data!.investments.details.isNotEmpty),
                        child: Container(
                          width: double.infinity,
                          child: Text(translate.selectYourInvestment,
                              style: TitleHelper.h10.copyWith(),
                              textAlign: TextAlign.left),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: List.generate(
                            state.data!.investments.details.length, (index) {
                          final data = state.data!.investments.details[index];
                          bool isChecked = investments
                              .where((e) => e.id == data.id)
                              .toList()
                              .isNotEmpty;
                          return buildCheckContainerInvestment(
                              index, data, isChecked, onTap: (_) {
                            if (_) {
                              setState(() {
                                investments.add(data);
                              });
                            } else {
                              setState(() {
                                int i = investments.indexWhere(
                                    (element) => element.id == data.id);
                                investments.removeAt(i);
                                // print(i);
                              });
                            }
                          });
                        }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(translate.otherCashSaving,
                            style: TitleHelper.h10.copyWith(),
                            textAlign: TextAlign.left),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormTextField(
                        suffixWidget: Text(getCurrency()),
                        hintText: translate.otherCashSaving,
                        isDemicalAllowed: true,
                        allowNum: true,
                        inputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textEditingController: _cashSavingsTowardsRetirement,
                        validator: (value) => _validator.validateAmount(
                            value?.trim(), translate.otherCashSavingValidation),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(translate.additionalMonthlyIncome,
                            style: TitleHelper.h10.copyWith(),
                            textAlign: TextAlign.left),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormTextField(
                        suffixWidget: Text(getCurrency()),
                        hintText: translate.monthlyIncomePostRetirement,
                        isDemicalAllowed: true,
                        allowNum: true,
                        inputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textEditingController: _monthlyIncomePostRetirement,
                        validator: (value) => _validator.validateAmount(
                            value?.trim(),
                            translate.monthlyIncomePostRetirementValidation),
                      ),
                    ],
                  )),
            );
          } else if (state is CalculatorInsightsLoading) {
            return buildCircularProgressIndicator();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Container buildCheckContainers(
      int index, PensionsInsightsEntity data, bool isChecked,
      {required Function onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appThemeColors!.textLight,
        boxShadow: [
          BoxShadow(
              color: appThemeColors!.textDark!.withOpacity(0.122),
              blurRadius: 9.9,
              spreadRadius: 0.5),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          onTap(!isChecked);
        },
        child: Container(
          padding: const EdgeInsets.all(15.0),

          // margin: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                // flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // width: 130,
                                child: Text(
                                  data.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 130,
                                child: Text(
                                  "${getCurrency() + " " + data.balance.toStringAsFixed(2)}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Color(0xfff4F4F4F)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 50,
                child: Checkbox(
                  checkColor: appThemeColors!.textLight,
                  activeColor:
                      lighten(appThemeColors!.primary ?? Colors.green, .3),
                  value: isChecked,
                  onChanged: (bool? value) {
                    onTap(value!);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildCheckContainerInvestment(
      int index, InvestmentsInsightsEntity data, bool isChecked,
      {required Function onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appThemeColors!.textLight,
        boxShadow: [
          BoxShadow(
              color: appThemeColors!.textDark!.withOpacity(0.122),
              blurRadius: 9.9,
              spreadRadius: 0.5),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          onTap(!isChecked);
        },
        child: Container(
          padding: const EdgeInsets.all(15.0),

          // margin: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                // flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // width: 130,
                                child: Text(
                                  data.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 130,
                                child: Text(
                                  "${getCurrency() + " " + data.balance.toStringAsFixed(2)}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Color(0xfff4F4F4F)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 30,
                child: Checkbox(
                  checkColor: appThemeColors!.textLight,
                  activeColor:
                      lighten(appThemeColors!.primary ?? Colors.green, .3),
                  value: isChecked,
                  onChanged: (bool? value) {
                    onTap(value!);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

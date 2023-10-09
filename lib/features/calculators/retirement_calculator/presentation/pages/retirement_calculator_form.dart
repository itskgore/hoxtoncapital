import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/features/calculators/retirement_calculator/presentation/pages/retirement_calculator_selector.dart';
import 'package:wedge/features/calculators/retirement_withdrawal_calculator/presentation/widgets/indicators.dart';

class RetirementCalculatorForm extends StatefulWidget {
  final retirementAge;
  final currentAge;

  const RetirementCalculatorForm(
      {Key? key, required this.retirementAge, required this.currentAge})
      : super(key: key);

  @override
  _RetirementCalculatorFormState createState() =>
      _RetirementCalculatorFormState();
}

class _RetirementCalculatorFormState extends State<RetirementCalculatorForm> {
  @override
  void initState() {
    super.initState();
    _valueModel = ValueEntity(amount: 0, currency: getCurrency());
  }

  // Keys
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextFieldValidator _validator = TextFieldValidator();

  final TextEditingController _currentAnnualIncome = TextEditingController();
  final TextEditingController _currentMonthlyRetirementSaving =
      TextEditingController();
  final TextEditingController _expectedAnnulRetirement =
      TextEditingController();
  final TextEditingController _expectedAnnualgrowth = TextEditingController();
  final TextEditingController _expectedAnnulGRateAfterRetirement =
      TextEditingController();
  final TextEditingController _inflation = TextEditingController();
  ValueEntity? _valueModel;

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => RetirementCalculatorSelector(
                    currentAge: widget.currentAge,
                    currentAnnualIncome: _currentAnnualIncome.text,
                    currentMonthlyRetirementSaving:
                        _currentMonthlyRetirementSaving.text,
                    expectedAnnualgrowth: _expectedAnnualgrowth.text,
                    expectedAnnulGRateAfterRetirement:
                        _expectedAnnulGRateAfterRetirement.text,
                    expectedAnnulRetirement: _expectedAnnulRetirement.text,
                    inflation: _inflation.text,
                    retirementAge: widget.retirementAge,
                  )));
    }
  }

  @override
  void dispose() {
    _currentAnnualIncome.dispose();
    _currentMonthlyRetirementSaving.dispose();
    _expectedAnnualgrowth.dispose();
    _expectedAnnulGRateAfterRetirement.dispose();
    _expectedAnnulRetirement.dispose();
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
            submit();
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'isSelected': false,
                  }
                ],
              ),
              Text(
                translate.retirementCalculatorFormDescription,
                textAlign: TextAlign.left,
                style: SubtitleHelper.h10
                    .copyWith(height: 1.6, color: const Color(0xfff4F4F4F)),
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomFormTextField(
                        suffixWidget: Text(getCurrency()),
                        hintText: translate.currentAnnualIncome,
                        isDemicalAllowed: true,
                        allowNum: true,
                        inputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textEditingController: _currentAnnualIncome,
                        validator: (value) => _validator.validateAmount(
                            value?.trim(),
                            translate.currentAnnualIncomeValidation),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormTextField(
                        suffixWidget: Text(getCurrency()),
                        hintText: translate.currentMonthlySaving,
                        isDemicalAllowed: true,
                        allowNum: true,
                        inputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textEditingController: _currentMonthlyRetirementSaving,
                        validator: (value) => _validator.validateAmount(
                            value?.trim(),
                            translate.currentMonthlySavingValidation),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormTextField(
                        hintText: translate.expectedAnnualGrowth,
                        isDemicalAllowed: true,
                        allowNum: true,
                        inputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textEditingController: _expectedAnnualgrowth,
                        validator: (value) => _validator.validateAmount(
                            value?.trim(),
                            translate.expectedAnnualGrowthValidation),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormTextField(
                        suffixWidget: Text(getCurrency()),
                        hintText: translate.expectedAnnualRetirementExp,
                        isDemicalAllowed: true,
                        allowNum: true,
                        inputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textEditingController: _expectedAnnulRetirement,
                        validator: (value) => _validator.validateAmount(
                            value?.trim(),
                            translate.expectedAnnualRetirementExpValidation),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormTextField(
                        hintText: translate.expectedAnnualGrowthRateAfterRetire,
                        isDemicalAllowed: true,
                        allowNum: true,
                        inputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textEditingController:
                            _expectedAnnulGRateAfterRetirement,
                        validator: (value) => _validator.validateAmount(
                            value?.trim(),
                            translate
                                .expectedAnnualGrowthRateAfterRetireValidation),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormTextField(
                        hintText: translate.inflationField,
                        isDemicalAllowed: true,
                        allowNum: true,
                        inputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textEditingController: _inflation,
                        validator: (value) => _validator.validateAmount(
                            value?.trim(), translate.inflationFieldValidation),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

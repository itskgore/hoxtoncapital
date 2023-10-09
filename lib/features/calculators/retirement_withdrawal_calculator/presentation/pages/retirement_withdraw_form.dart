import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/dropdown/wedge_custom_dropdown.dart';
import 'package:wedge/core/widgets/inputFields/currency_text_feild.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/features/calculators/retirement_withdrawal_calculator/presentation/pages/retirement_withdraw_summary.dart';
import 'package:wedge/features/calculators/retirement_withdrawal_calculator/presentation/widgets/indicators.dart';

class RetirementWithdrawForm extends StatefulWidget {
  const RetirementWithdrawForm({Key? key}) : super(key: key);

  @override
  _RetirementWithdrawFormState createState() => _RetirementWithdrawFormState();
}

class _RetirementWithdrawFormState extends State<RetirementWithdrawForm> {
  // Keys
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  //Controllers || DropdownHolders
  String _withdrawData = "Monthly";
  String _paymentType = "End of period";
  ValueEntity? _investment;
  ValueEntity? _firstWithdraw;
  TextFieldValidator _validator = TextFieldValidator();
  final TextEditingController _annualInterest = TextEditingController();
  final TextEditingController _inflation = TextEditingController();
  List<String> _withdrawDropDown = [
    'Monthly',
    'Quaterly',
    'Half Yearly',
    'Yearly'
  ];
  List<String> _paymentDropDown = ['End of period', 'Beginning of period'];

  Future<void> submit() async {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                const RetirementWithdrawSummary()));
    // if (_formKey.currentState!.validate()) {
    //   Navigator.push(
    //       context,
    //       CupertinoPageRoute(
    //           builder: (BuildContext context) => RetirementWithdrawSummary()));
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _inflation.dispose();
    _annualInterest.dispose();
    super.dispose();
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
            submit();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RetirementCalculatorIndicators(
                isFirst: false,
                indicators: [
                  {
                    'isSelected': false,
                  },
                  {
                    'isSelected': true,
                  }
                ],
              ),
              Text(
                "Please fill up the following information.",
                textAlign: TextAlign.left,
                style: TextHelper.h5
                    .copyWith(height: 1.6, color: const Color(0xfff4F4F4F)),
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CurrencyTextField(
                        hintText: "Investment at retirement",
                        errorMsg: "Investment at retirement is required",
                        currencyModel: _investment,
                        onChange: (value) {
                          _investment = value;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormTextField(
                        hintText: "Annual interest rate (%)",
                        isDemicalAllowed: true,
                        allowNum: true,
                        inputType: TextInputType.number,
                        textEditingController: _annualInterest,
                        validator: (value) => _validator.validateAmount(
                            value?.trim(), "Annual interest rate"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      WedgeCustomDropDown(
                          items: _withdrawDropDown,
                          value: _withdrawData,
                          onChanged: (_) {
                            _withdrawData = _;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      CurrencyTextField(
                        hintText: "First withdrawal",
                        errorMsg: "First withdrawal is required",
                        currencyModel: _firstWithdraw,
                        onChange: (value) {
                          _firstWithdraw = value;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      WedgeCustomDropDown(
                          items: _paymentDropDown,
                          value: _paymentType,
                          onChanged: (_) {
                            _paymentType = _;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormTextField(
                        hintText: "Inflation (%)",
                        isDemicalAllowed: true,
                        allowNum: true,
                        inputType: TextInputType.number,
                        textEditingController: _inflation,
                        validator: (value) => _validator.validateAmount(
                            value?.trim(), "Inflation"),
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

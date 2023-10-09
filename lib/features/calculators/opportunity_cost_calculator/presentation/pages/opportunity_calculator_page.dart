import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_currency_picker.dart';
import 'package:wedge/features/calculators/opportunity_cost_calculator/presentation/bloc/cubit/oppurtunity_calculator_cubit.dart';
import 'package:wedge/features/calculators/opportunity_cost_calculator/presentation/widgets/calculator_value_container.dart';

class OpportunityCalculatorPage extends StatefulWidget {
  String? transactions;

  OpportunityCalculatorPage({Key? key, this.transactions}) : super(key: key);

  @override
  _OpportunityCalculatorPageState createState() =>
      _OpportunityCalculatorPageState();
}

class _OpportunityCalculatorPageState extends State<OpportunityCalculatorPage> {
  Country _selectedDialogCurrency =
      CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);

  final TextEditingController _moneyToSpend = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OppurtunityCalculatorCubit>().resetCalculator();
    //assign default country and currency
    _selectedDialogCurrency =
        CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
    getCostFromTransactions();
  }

  getCostFromTransactions() {
    if (widget.transactions != null) {
      _moneyToSpend.text = widget.transactions!;
      context
          .read<OppurtunityCalculatorCubit>()
          .moneySpentOnchanged(double.parse(widget.transactions ?? "0.0"));
    }
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    _moneyToSpend.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(context: context, title: translate!.opportunityCost),
      body: Padding(
        padding: const EdgeInsets.all(kpadding),
        child:
            BlocBuilder<OppurtunityCalculatorCubit, OppurtunityCalculatorState>(
          // bloc: context.read<OppurtunityCalculatorCubit>().onLoad(),
          builder: (context, state) {
            if (state is OppurtunityCalculatorInitial) {
              return ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (v) {
                      if (v == "" || v.isEmpty) {
                        v = "0.0";
                      }
                      context
                          .read<OppurtunityCalculatorCubit>()
                          .moneySpentOnchanged(double.parse(v));
                    },
                    controller: _moneyToSpend,
                    // validator: (value) => validator.validateAmount(value?.trim()),
                    // controller: _currentbalance,
                    enableSuggestions: true,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\-?\d*\.?\d*)'))
                    ],
                    //3
                    // keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        fillColor: appThemeColors!.textLight,
                        filled: true,
                        border: ktextFeildOutlineInputBorder,
                        hintText: translate.moneyToSpend,
                        suffixStyle: TextStyle(color: appThemeColors!.textDark),
                        errorStyle: kerrorTextstyle,
                        suffix: GestureDetector(
                            onTap: () async {
                              WedgeCurrencyPicker(
                                  context: context,
                                  countryPicked: (Country country) {
                                    setState(() {
                                      _selectedDialogCurrency = country;
                                    });
                                  });
                            },
                            child: Container(
                                width: 60,
                                child: Row(
                                  children: [
                                    Text(
                                      _selectedDialogCurrency.currencyCode
                                          .toString(),
                                      style: const TextStyle(
                                          color: kfontColorDark),
                                    ),
                                    const Icon(Icons.arrow_drop_down)
                                  ],
                                )))),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "${_selectedDialogCurrency.currencyCode} ${numberFormat.format(state.totalValue)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TitleHelper.h5.copyWith(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: TextStyle(
                          fontSize: appThemeHeadlineSizes!.h10,
                          color: appThemeColors!.disableText,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: translate.yourInvestmentWorth,
                          ),
                          TextSpan(
                              text: ' ${state.investmentPeriod} ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(text: translate.years),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: TitleHelper.h10.copyWith(color: Colors.green),
                        children: <TextSpan>[
                          TextSpan(
                              text: translate.interestEarned,
                              style: TitleHelper.h10.copyWith()),
                          TextSpan(
                              text:
                                  '  ${_selectedDialogCurrency.currencyCode} ${numberFormat.format(state.interestEarned)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                  ),
                  // Text(
                  //   "Your investment worth after ${state.investmentPeriod} years",
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     // color: kDashboardValueMainTextColor,
                  //     fontSize: kfontMedium,
                  //     fontWeight: FontWeight.w300,
                  //   ),
                  // ),

                  const SizedBox(
                    height: 30,
                  ),
                  CalculatorValueContainer(
                    text: "${state.annualReturn}%",
                    onMinusPressed: () {
                      if (_moneyToSpend.text == "" ||
                          _moneyToSpend.text.isEmpty) {
                        _moneyToSpend.text = "0.0";
                      }
                      context
                          .read<OppurtunityCalculatorCubit>()
                          .decreaseAnnualReturn(
                              double.parse(_moneyToSpend.text));
                    },
                    onPlusPressed: () {
                      if (_moneyToSpend.text == "" ||
                          _moneyToSpend.text.isEmpty) {
                        _moneyToSpend.text = "0.0";
                      }
                      // print("dd");
                      context
                          .read<OppurtunityCalculatorCubit>()
                          .increaseAnnualReturn(
                              double.parse(_moneyToSpend.text));
                    },
                    title: translate.annualReturnOnSavings,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CalculatorValueContainer(
                    text: "${state.investmentPeriod} ${translate.years}",
                    onMinusPressed: () {
                      if (_moneyToSpend.text == "" ||
                          _moneyToSpend.text.isEmpty) {
                        _moneyToSpend.text = "0.0";
                      }
                      context
                          .read<OppurtunityCalculatorCubit>()
                          .decreaseInvestmentPeriod(
                              double.parse(_moneyToSpend.text));
                    },
                    onPlusPressed: () {
                      if (_moneyToSpend.text == "" ||
                          _moneyToSpend.text.isEmpty) {
                        _moneyToSpend.text = "0.0";
                      }
                      context
                          .read<OppurtunityCalculatorCubit>()
                          .increaseInvestmentPeriod(
                              double.parse(_moneyToSpend.text));
                    },
                    title: translate.investmentPersion,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CalculatorValueContainer(
                    text: "${state.annualInflation} %",
                    onMinusPressed: () {
                      if (_moneyToSpend.text == "" ||
                          _moneyToSpend.text.isEmpty) {
                        _moneyToSpend.text = "0.0";
                      }
                      context
                          .read<OppurtunityCalculatorCubit>()
                          .decreaseInflation(double.parse(_moneyToSpend.text));
                    },
                    onPlusPressed: () {
                      if (_moneyToSpend.text == "" ||
                          _moneyToSpend.text.isEmpty) {
                        _moneyToSpend.text = "0.0";
                      }
                      context
                          .read<OppurtunityCalculatorCubit>()
                          .increaseInflation(double.parse(_moneyToSpend.text));
                    },
                    title: translate.annualInflationRate,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),

                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.blueAccent)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: Text(
                              translate.opportunityCostInformation,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

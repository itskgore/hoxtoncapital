import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/calculators/retirement_calculator/presentation/pages/retirement_calculator.dart';
import 'package:wedge/features/calculators/retirement_calculator/presentation/widgets/calculator_chart.dart';

class RetirementSummaryPage extends StatefulWidget {
  final currentAnnualIncome;
  final currentMonthlyRetirementSaving;
  final expectedAnnulRetirement;
  final expectedAnnualgrowth;
  final expectedAnnulGRateAfterRetirement;
  final inflation;
  final currentAge;
  final retirementAge;
  final List<PensionsInsightsEntity> pensions;
  final List<InvestmentsInsightsEntity> investments;
  final cashSavingsTowardsRetirement;
  final monthlyIncomePostRetirement;

  const RetirementSummaryPage(
      {Key? key,
      required this.currentAnnualIncome,
      required this.currentMonthlyRetirementSaving,
      required this.expectedAnnualgrowth,
      required this.expectedAnnulGRateAfterRetirement,
      required this.expectedAnnulRetirement,
      required this.inflation,
      required this.currentAge,
      required this.retirementAge,
      required this.pensions,
      required this.investments,
      required this.cashSavingsTowardsRetirement,
      required this.monthlyIncomePostRetirement})
      : super(key: key);

  @override
  _RetirementSummaryPageState createState() => _RetirementSummaryPageState();
}

class _RetirementSummaryPageState extends State<RetirementSummaryPage> {
  // Keys
  double _ageSliderValue = 0.0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<charts.Series<LinearSales, num>> goalchartData = [];
  double _recommondedBalance = 0.0;
  double _currentBalance = 0.0;
  double _totalRetirementTarget = 0.0;
  double _shortFall = 0.0;
  double _amountYouNeedToSaveMonthly = 0.0;
  double _currentMonthlysavings = 0.0;
  double _additionalAmountNeeded = 0.0;
  double _targetedAnnualRetirement = 0.0;

  @override
  void initState() {
    super.initState();
    _ageSliderValue = 25.0;
    _currentMonthlysavings =
        double.parse((widget.currentMonthlyRetirementSaving).toString());
    _calculateData(_ageSliderValue);
  }

  _calculateData(double yearsToInvest) {
    List<Map> goalTableData = [];
    List<Map> currentTableData = [];

    //  ========================== <> ========================================
    double _totalPenInv = 0.0; //Combined value of your pensions and Investments
    double n1 = 0.0; //years to invest
    double ac =
        double.parse(widget.currentAge.toString()); // current age  iiinputs
    double ar = double.parse(
        widget.retirementAge.toString()); // retirement age  iiinputs
    // double rg = 0.0; // Expected Annual growth
    double ri = convertToPercentage(
        double.parse(widget.inflation.toString())); //Annual Inflation iiinputs
    double re = double.parse(widget.expectedAnnulRetirement
        .toString()); //Expected Annual Retirment expenses iiinputs
    double rxa = convertToPercentage(double.parse(widget.expectedAnnualgrowth
        .toString())); //Expected Annual Growth iiinputs
    double rx = convertToPercentage(double.parse(widget
        .expectedAnnulGRateAfterRetirement
        .toString())); //Expected Annual Growth rate after Retirement iiinputs
    // double rxi = 0.0; //growth after retiremnet(inflation adjusted)
    // double cv = 0.0; // current value
    // double ir = 0.0; //cash savings after retirement
    double sr = double.parse(widget.currentMonthlyRetirementSaving.toString()) *
        12.0; //Current Annual retirement savings    iiinputs
    double rei = 0.0; //Inflation-Adjusted Retirement Expenses
    double np = 1.0; //no of payments  iiinputs
    double ypr = yearsToInvest; //Years to Pay Out After Retire.    iiinputs
    double yprRental = 0.0; //Years to Pay Out After Retirement
    // double vcs = 0.0; //Value of Other Income at Retirement
    double sTotal = 0.0; //Total Needed to Fund 100% of Retirement
    double ia = double.parse(widget.currentAnnualIncome
        .toString()); //Current Annual Income  iiinputs
    double aric = double.parse(
        widget.retirementAge.toString()); //Age when rental income starts
    double ric = widget.monthlyIncomePostRetirement == ""
        ? 0.0
        : double.parse(widget.monthlyIncomePostRetirement
            .toString()); //Rental Income iiinputs
    double sfr = 0.0; //Shortfall at Retirement
    double asn = 0.0; //Additional Annual Savings Needed
    double vcsr = 0.0; //Value of Current Savings at Retirement
    double vccr = 0.0; // Value of Current Contributions at Retirement
    double voir = 0.0; // Value of other income at Retirement
    double totalPSalarytoReachGoal =
        0; // Total % of Salary to Save to Reach Goal
    double cac = 0.0; //current total contrubution %
    double oi = widget.cashSavingsTowardsRetirement == ""
        ? 0.0
        : double.parse(
            widget.cashSavingsTowardsRetirement.toString()); //other income M22

    //  ========================== <> ========================================
    // print("=========================== " +
    //     widget.monthlyIncomePostRetirement.toString());
    widget.pensions.forEach((element) {
      //sum of pensions
      _totalPenInv += element.balance;
    });

    widget.investments.forEach((element) {
      //sum of investments
      _totalPenInv += element.balance;
    });

    // _totalPenInv += oi;
    cac = sr / ia;

    // inflation adjusted retirement expenses M6

    n1 = ar - ac; //Years to Invest Before Retire.
    rei = re * pow(1 + ri, n1);

    // years to payout after retirement M17
    //=G7-(M15-G6)
    yprRental = ypr - (aric - ar);
    print("Years to pay out after retirement  " + yprRental.toString());

    // total needed to fund for retirement M7
    //=M6*((1-(1/(1+((1+G12)/(1+G13)-1)/G30)^(G7*G30)))/((1+G12)/(1+G13)-1)/G30)*(1+((1+G12)/(1+G13)-1)/G30)
    if (((1 + rx) / (1 + ri) - 1) == 0) {
      sTotal = rei * yprRental;
    } else {
      sTotal = rei *
          ((1 - (1 / pow((1 + ((1 + rx) / (1 + ri) - 1) / np), (ypr * np)))) /
              ((1 + rx) / (1 + ri) - 1) /
              np) *
          (1 + ((1 + rx) / (1 + ri) - 1) / np);
    }

    print("total needed to fund " + sTotal.toString());

    // value of current savings retirement M11
    //R13*((1+R11)^(R12))

    vcsr = _totalPenInv * pow((1 + rxa), (n1));
    print("Value of Current Savings at Retirement " + vcsr.toString());

    //value of current contributions at retirement M12
    //(G25)*((1+G11)^(G8)-1)/(G11)
    vccr = (sr) * (pow((1 + rxa), (n1)) - 1) / (rxa);
    print("Value of Current Contributions at Retirement " + vccr.toString());

    // value of other income at retirement M18
    //=(M16)*((1+G13/G30)^(M17*G30)-1)/(G13/G30)
    voir = (ric) * (pow((1 + ri / np), (yprRental * np)) - 1) / (ri / np);
    print("Value of Other Income at Retirement " + voir.toString());

    // shortfall at retirement M24
    //=M7-M11-M12-M18-M22

    sfr = sTotal - vcsr - vccr - voir - oi;
    print("shortfall at retirement " + sfr.toString());

    // additional annual savings needed M26
    //==M24*G11/((1+(G11/G31))^(G8*G31)-1)

    // asn = sfr * rxa / (pow((1 + (rxa / 1)), (n1 * 1))) - 1;
    asn = sfr * rxa / (pow((1 + (rxa / 1)), (n1 * 1)) - 1);
    print("Additional Annual Savings Needed $_ageSliderValue $sfr $rxa $n1 " +
        (asn / 12).toString());

    // total % of salary to save to reach goal M27
    //=(M26+G25)/G16

    totalPSalarytoReachGoal = 100 * ((asn + sr) / ia);
    print("total % of salary to save to reach goal " +
        totalPSalarytoReachGoal.toString());

    double salaryBasis = 0;
    double lastBalance = _totalPenInv; //,IF(D46>=$G$6,$M$6*(1+$G$13)^(D46-$G$6)

    double maxRecommanded = 0.0;
    for (int i = 1; i <= (ypr + n1); i++) {
      double age = ac + i - 1;
      double ret = 0; //return
      double annualContrib =
          0.0; //,IF(D45=$G$6-1,$M$22,0)+IF(C45<=$G$8,F45*$M$27,0))

      double rentalIncome =
          0.0; //IF(AND(D45>=$M$15,D45<($M$15+$M$17)),$M$16*(1+$G$13)^(D45-$M$15),0)))
      double payoutWithdrawal = 0.0;
      double estInvReturn = 0.0;
      double currentBalance = 0.0; //M44+G45+L45+J45-K45)

      if (age > ar - 1) {
        ret = rx; //exp annual ret after retirement %
      } else {
        ret = rxa;
      }

      if (age >= ar) {
        salaryBasis = rei * pow((1 + ri), (age - ar));
      } else {
        if (ac >= ar) {
          salaryBasis = re;
        } else {
          salaryBasis = ia;
        }
      }

      if (age == ar - 1) {
        annualContrib = oi; // convertToPercentage(totalPSalarytoReachGoal);
      }
      if (i <= n1) {
        annualContrib +=
            (salaryBasis * convertToPercentage(totalPSalarytoReachGoal));
      }

      if (age >= aric && age < (aric + yprRental)) {
        rentalIncome = ric * pow((1 + ri), (age - aric));
      }

      estInvReturn = lastBalance * (ret / 1);

      // if (age >= ar) {
      //   payoutWithdrawal = salaryBasis - rentalIncome;
      // }

      if (age >= ar) {
        //payout (withdrawal)
        if (salaryBasis - rentalIncome >= lastBalance + estInvReturn) {
          payoutWithdrawal = lastBalance + estInvReturn;
        } else {
          payoutWithdrawal = salaryBasis - rentalIncome;
        }
      }

      // if (i != 0) {
      currentBalance =
          lastBalance + annualContrib + estInvReturn - payoutWithdrawal;

      if (maxRecommanded < currentBalance) {
        maxRecommanded = currentBalance;
      }
      // }

      // if (i == 0) {
      //   print("last bal =======>" + lastBalance.toString());
      //   print("annaul con =======>" + annualContrib.toString());
      //   print("estimated inv =======>" + estInvReturn.toString());
      //   print("rentalIncome =======>" + rentalIncome.toString());
      //   print("payoutWithdrawal =======>" + payoutWithdrawal.toString());
      //   print("currentBalance =======>" + currentBalance.toString());
      // }

      lastBalance = currentBalance;

      goalTableData.add({
        "year": i,
        "Age": age.toStringAsFixed(0),
        "Return": "${ret * 100}",
        "Salary Basis": salaryBasis,
        "Annual Contribution": annualContrib,
        "Rental Income": rentalIncome,
        "Payout Withdrawal": payoutWithdrawal,
        "Est.Inv.Return": estInvReturn,
        "Balance": currentBalance,
      });
    }

    // ============================================= <curren scenario>======================
    lastBalance = _totalPenInv;
    int i = 1;

    double currentPathMax = 0;
    while (lastBalance >= 0) {
      //&& i <= (ypr + n1)
      double age = ac + i - 1;
      double ret = 0;
      double annualContrib =
          0.0; //,IF(D45=$G$6-1,$M$22,0)+IF(C45<=$G$8,F45*$M$27,0))

      double rentalIncome =
          0.0; //IF(AND(D45>=$M$15,D45<($M$15+$M$17)),$M$16*(1+$G$13)^(D45-$M$15),0)))
      double payoutWithdrawal = 0.0;
      double interest = 0.0;
      double currentBalance = 0.0; //M44+G45+L45+J45-K45)

      if (age > ar - 1) {
        //return
        ret = rx;
      } else {
        ret = rxa;
      }

      if (age >= ar) {
        //salary basis
        salaryBasis = rei * pow((1 + ri), (age - ar));
      } else {
        if (ac >= ar) {
          salaryBasis = re;
        } else {
          salaryBasis = ia;
        }
      }

      if (age == ar - 1) {
        // annual contribution
        annualContrib = oi;
        // annualContrib = convertToPercentage(totalPSalarytoReachGoal);
      }
      if (i <= n1) {
        annualContrib += (sr);
      }

      if (age >= aric && age < (aric + yprRental)) {
        //rental income
        rentalIncome = ric * pow((1 + ri), (age - aric));
      }

      // if (i != 1) {
      // interest = goalTableData[i - 2]["Balance"] * (ret / 1);
      interest = lastBalance * (ret / 1);

      // ret = double.parse(goalTableData[i]["Return"].toString()) / 100;
      // }

      if (age >= ar) {
        //payout (withdrawal)
        if (salaryBasis - rentalIncome >= lastBalance + interest) {
          payoutWithdrawal = lastBalance + interest;
        } else {
          payoutWithdrawal = salaryBasis - rentalIncome;
        }
      }

      currentBalance = lastBalance + //balance
          annualContrib +
          interest -
          payoutWithdrawal;

      if (currentPathMax < currentBalance) {
        currentPathMax = currentBalance;
      }

      // if (i == 2) {
      //   print("last bal =======>" + lastBalance.toString());
      //   print("annaul con =======>" + annualContrib.toString());
      //   print("rentalIncome =======>" + rentalIncome.toString());
      //   print("interst =======>" + interest.toString());
      //   print("currentBalance =======>" + currentBalance.toString());
      // }

      lastBalance = currentBalance;

      currentTableData.add({
        "year": i,
        "Age": age.toStringAsFixed(0),
        "Return": "${ret * 100}",
        "Salary Basis": salaryBasis,
        "Annual Contribution": annualContrib,
        "Rental Income": rentalIncome,
        "Payout Withdrawal": payoutWithdrawal,
        "Interest Earned": interest,
        "Balance": currentBalance,
      });

      i++;
      if (i >= (ypr + n1) || lastBalance == 0) {
        break;
      }
    }

    goalchartData = _createChartData(goalTableData, currentTableData);

    setState(() {
      _amountYouNeedToSaveMonthly = double.parse(
          ((asn / 12) + (sr / 12)).toStringAsFixed(0)); //display purpose
      _additionalAmountNeeded = double.parse((asn / 12).toStringAsFixed(0));
      _shortFall = double.parse(sfr.toStringAsFixed(0));

      _totalRetirementTarget =
          goalTableData[goalTableData.length - 1]["Balance"];

      _recommondedBalance = double.parse(maxRecommanded.toStringAsFixed(2));
      _currentBalance = double.parse(currentPathMax.toStringAsFixed(2));
      _targetedAnnualRetirement =
          double.parse((_amountYouNeedToSaveMonthly * 12).toStringAsFixed(0));
    });

    //  console.print("Data $currentTableData");
    // console.print("Data $currentTableData");
  }

  double convertToPercentage(double v) {
    return v / 100;
  }

  List<charts.Series<LinearSales, num>> _createChartData(
      List gdata, List cData) {
    List<LinearSales> goalData = [];
    List<LinearSales> currentData = [];
    gdata.forEach((element) {
      goalData.add(LinearSales(int.parse(element["Age"]), element["Balance"]));
    });

    cData.forEach((element) {
      currentData
          .add(LinearSales(int.parse(element["Age"]), element["Balance"]));
    });

    // console.print(goalData.);

    return [
      new charts.Series<LinearSales, int>(
        id: 'Goal',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            appThemeColors!.charts!.calculatorCharts!.recommended!),
        domainFn: (LinearSales sales, _) => sales.age,
        measureFn: (LinearSales sales, _) => sales.balance,
        data: goalData,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Current',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            appThemeColors!.charts!.calculatorCharts!.currentPath!),
        domainFn: (LinearSales sales, _) => sales.age,
        measureFn: (LinearSales sales, _) => sales.balance,
        data: currentData,
        // displayName: "Goal Savings"
      ),
    ];
  }

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

  changeAgeVal(double value) {
    _additionalAmountNeeded = 0.0;
    double v = double.parse(value.toStringAsFixed(0));
    setState(() {
      _ageSliderValue = v;
    });
    _calculateData(v);
  }

  AppLocalizations? translate;

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: appThemeColors!.bg,
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            getWireDashIcon(context)
            // IconButton(
            //     onPressed: () {
            //       changeAgeVal(25.0);
            //     },
            //     icon: Icon(Icons.ac_unit_outlined))
          ],
          leading: Container(),

          // GestureDetector(
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //     child: Icon(
          //       Icons.arrow_back_ios,
          //     )),
          centerTitle: true,
          title: Text(
            translate!.retirementCalculator,
            style: TextStyle(fontSize: 19, color: appThemeColors!.primary),
          ),
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: appThemeColors!.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          RetirementCalculator()),
                  (route) => false);
            },
            child: Text(
              translate!.reCalculator,
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
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                          getCurrency() +
                              " " +
                              numberFormat.format(_amountYouNeedToSaveMonthly),

                          // double.parse(_amountYouNeedToSaveMonthly.toString())
                          //     .toStringAsFixed(0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TitleHelper.h6.copyWith(
                            color: lighten(
                                appThemeColors!.primary ?? Colors.green, .15),
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        translate!.amtYouNeedToSave,
                        style: TextStyle(
                          color: appThemeColors!.disableText,
                          fontSize: appThemeHeadlineSizes!.h10,
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
                  subTitle1: translate!.targetedAnnualRetirement,
                  subTitle2: translate!.currentlyMonthlySaving,
                  title1:
                      "${getCurrency()} ${numberFormat.format(_targetedAnnualRetirement)} ",
                  title2:
                      "${getCurrency()} ${numberFormat.format(_currentMonthlysavings)} ",
                ),

                RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: TextStyle(
                      fontSize: 14.0,
                      color: appThemeColors!.textDark,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: translate!.addAnAddition,
                          style: TitleHelper.h10.copyWith()),
                      TextSpan(
                          text:
                              '${getCurrency()} ${numberFormat.format(_additionalAmountNeeded)} ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: appThemeColors!.disableText!)),
                      TextSpan(
                          text: translate!.addAnAdditionMonthlyCatchUp,
                          style: TitleHelper.h10.copyWith()),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                      "${translate!.yearsToPayOutAfterRetire} ${double.parse(_ageSliderValue.toString()).toStringAsFixed(0)}  (${double.parse((_ageSliderValue + widget.retirementAge).toString()).toStringAsFixed(0)}) ",
                      style: SubtitleHelper.h10
                          .copyWith(color: appThemeColors!.disableText),
                      textAlign: TextAlign.center),
                ),
                Container(
                  child: Slider(
                    activeColor: appThemeColors!.outline,
                    inactiveColor: const Color(0xfffEAEBE1),
                    value: _ageSliderValue,
                    min: 10.0,
                    max: 40.0,
                    // divisions: 30,
                    // label: val.toString(),
                    onChanged: (double newValue) {
                      changeAgeVal(newValue);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      40,
                      (index) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            height: 20,
                            width: 1,
                            decoration:
                                const BoxDecoration(color: Color(0xfffCFCFCF)),
                          )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    translate!.retirementSavingOverTime,
                    style: TitleHelper.h9.copyWith(),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  // color: kDividerColor,
                  child: Center(
                      child: CalculatorChart(
                    goalchartData,
                    animate: true,
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          appThemeColors!.charts!.calculatorCharts!.recommended,
                    ),
                  ),
                  title: Transform.translate(
                      offset: const Offset(-16, -2),
                      child: Text(translate!.recommended,
                          style: SubtitleHelper.h10
                              .copyWith(color: Colors.grey[700]))),
                  // trailing: Text(
                  //   "${getCurrency()} ${numberFormat.format(_recommondedBalance)} ", //
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  subtitle: Transform.translate(
                      offset: const Offset(-16, -2),
                      child: Text(
                          "${getCurrency()} ${numberFormat.format(_recommondedBalance)} ",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: appThemeColors!.textDark))),

                  //  Text(
                  //   "${getCurrency()} ${numberFormat.format(_recommondedBalance)} ", //
                  //   // overflow: TextOverflow.ellipsis,
                  // ),
                ),
                ListTile(
                  leading: Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  title: Transform.translate(
                      offset: const Offset(-16, -2),
                      child: Text(translate!.currentPath,
                          style: SubtitleHelper.h10
                              .copyWith(color: Colors.grey[700]))),
                  // trailing: SizedBox(
                  //   width: MediaQuery.of(context).size.width - 250,
                  //   child: Text(
                  //     "${getCurrency()} ${numberFormat.format(_currentBalance)}",
                  //     softWrap: true,
                  //   ),
                  // ),
                  subtitle: Transform.translate(
                      offset: const Offset(-16, -2),
                      child: Text(
                          "${getCurrency()} ${numberFormat.format(_currentBalance)}",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: appThemeColors!.textDark))),

                  //
                ),
                const Divider(),
                ListTile(
                  title: Text(translate!.shortFall,
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    "${getCurrency()} ${numberFormat.format(_shortFall)} ",
                    style: TextStyle(color: appThemeColors!.textDark),
                    // softWrap: true,
                  ),
                ),
                const Divider(),
                // SizedBox(
                //   height: 30,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     setMail();
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset(
                //         "assets/icons/download_icon.png",
                //         width: 20,
                //       ),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       Text(
                //         "Email full report",
                //         style: TextHelper.h5
                //             .copyWith(color: const Color(0xfff428DFF)),
                //       )
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
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
      decoration: BoxDecoration(
          color: appThemeColors!.primary!.withOpacity(0.19),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$title1",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TitleHelper.h10.copyWith(
                  // fontSize: ,
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
                    fontSize: 13, color: appThemeColors!.disableText)),
          ],
        ),
      ),
    ));
  }
}

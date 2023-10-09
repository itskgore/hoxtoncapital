import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/features/assets/invesntment/investment_main/presentation/pages/add_investment_main_page.dart';

class YodleeInvestmentFramePage extends StatefulWidget {
  const YodleeInvestmentFramePage({super.key});
  @override
  _YodleeInvestmentFramePageState createState() =>
      _YodleeInvestmentFramePageState();
}

class _YodleeInvestmentFramePageState extends State<YodleeInvestmentFramePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Yodlee Investment Account Login Interface"),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => InvestmentsMainPage()));
                },
                child: const Text("next"))
          ],
        ),
      ),
    );
  }
}

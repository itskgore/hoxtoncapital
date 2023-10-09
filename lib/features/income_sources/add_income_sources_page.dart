import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/features/assets/assets_widget.dart';
import 'package:wedge/features/home/presentation/pages/home_page.dart';

import 'other_income/other_income/presentation/pages/other_income_page.dart';
import 'primary_income/primary_income/presentation/pages/primary_income_page.dart';
import 'rental_income/rental_income/presentation/pages/rental_income_page.dart';

class AddIncomeSourcesPage extends StatefulWidget {
  // AddIncomeSourcesPage({Key key}) : super(key: key);

  @override
  _AddIncomeSourcesPageState createState() => _AddIncomeSourcesPageState();
}

class _AddIncomeSourcesPageState extends State<AddIncomeSourcesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: wedgeAppBar(context: context, title: ADD_INCOME_SOURCE),
      body: ListView(
        children: [
          AssetsWidget(
              name: PRIMARY_INCOME,
              icon: "assets/icons/Bank.png",
              page: const PrimaryIncomePage(),
              total: "00",
              onBack: () {
                setState(() {});
              }),
          AssetsWidget(
              name: RENTAL_INCOME,
              icon: "assets/icons/Bank.png",
              page: RentalIncomePage(),
              total: "00",
              onBack: () {
                setState(() {});
              }),
          AssetsWidget(
              name: OTHER,
              icon: "assets/icons/Bank.png",
              page: OtherIncomePage(),
              total: "00",
              onBack: () {
                setState(() {});
              }),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(width: 1.0, color: Color(0xfffe7e7e7))),
        ),
        height: 140,
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const HomePage()));
                },
                child: const Text(ADD_LATER)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text(
                ADD_YOUR_FINANCIALDATA_MESSAGE,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

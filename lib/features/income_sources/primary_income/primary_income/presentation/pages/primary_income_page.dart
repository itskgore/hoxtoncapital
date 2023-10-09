import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/wedge_card.dart';
import 'package:wedge/features/income_sources/primary_income/add_primary_income/presentation/pages/add_primary_income_page.dart';

class PrimaryIncomePage extends StatefulWidget {
  const PrimaryIncomePage({super.key});

  @override
  _PrimaryIncomePageState createState() => _PrimaryIncomePageState();
}

class _PrimaryIncomePageState extends State<PrimaryIncomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: wedgeAppBar(context: context, title: PRIMARY_INCOME),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return WedgeCard(
                value: "23000", icon: Icons.assessment, onTap: () {});
          }),
      bottomNavigationBar: BottomNavSingleButtonContainer(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: appThemeColors!.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => AddPrimaryIncomePage()));
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              Text(
                ADD_MORE,
                style: TextStyle(fontSize: kfontMedium),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

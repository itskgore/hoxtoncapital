import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/features/assets/invesntment/add_investment/presentation/pages/add_investment_page.dart';
import 'package:wedge/features/assets/pension/add_pesnion/presentation/pages/add_pension_page.dart';
import 'package:wedge/features/home/presentation/widgets/sub_widgets/line_chart.dart';

class PensionInvestmentDetailsPage extends StatefulWidget {
  const PensionInvestmentDetailsPage({Key? key}) : super(key: key);

  @override
  _PensionInvestmentDetailsPageState createState() =>
      _PensionInvestmentDetailsPageState();
}

class _PensionInvestmentDetailsPageState
    extends State<PensionInvestmentDetailsPage> {
  List<bool> isSelected = [true, false];
  AppLocalizations? translate;

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: AppBar(
        title: Text("${translate!.pensions} & ${translate!.investments}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kpadding),
        child: ListView(
          children: [
            Center(
              child: SizedBox(
                height: 40,
                child: ToggleButtons(
                    fillColor: appThemeColors!.primary,
                    selectedColor: kfontColorLight,
                    textStyle: const TextStyle(color: kfontColorDark),
                    borderRadius: BorderRadius.circular(kborderRadius),
                    onPressed: (index) {
                      setState(() {
                        if (index == 0) {
                          isSelected = [true, false];
                        } else {
                          isSelected = [false, true];
                        }
                      });
                    },
                    isSelected: isSelected,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.6,
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Center(child: Text(PENSIONS)),
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.6,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Center(child: Text(translate!.investments)),
                          )),
                    ]),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            isSelected[0] ? _pensions() : _investments()
          ],
        ),
      ),
    );
  }

  Widget _listTile(index) {
    return Padding(
      padding: const EdgeInsets.only(top: kpadding),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kborderRadius),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40.0,
                width: 150.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                          fontSize: kfontMedium,
                          fontFamily: kSecondortfontFamily),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "RL360",
                              style: TextStyle(
                                  fontFamily: kSecondortfontFamily,
                                  fontSize: kfontMedium),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              "assets/icons/hox_logo.png",
                              width: 20,
                              height: 20,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        const Text(
                          "United arab emirates",
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40.0,
                width: 110.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "200,000",
                          style: TextStyle(
                              fontFamily: kSecondortfontFamily,
                              fontSize: kfontMedium),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          "Current value",
                          style: TextStyle(
                              // fontFamily: kSecondortfontFamily,
                              fontSize: 14.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_right)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pensions() {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: [
        const SizedBox(
          height: 28,
        ),
        const Text(
          "Pension performance",
          style: TextStyle(
              fontSize: kfontLarge,
              fontWeight: FontWeight.w500,
              fontFamily: kSecondortfontFamily),
        ),
        const SizedBox(
          height: 16,
        ),
        NetworthLineChart(),
        const SizedBox(
          height: 20,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pensions (3)",
              style: TextStyle(
                  fontSize: kfontLarge,
                  fontWeight: FontWeight.w500,
                  fontFamily: kSecondortfontFamily),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return _listTile(index);
          },
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
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
                      builder: (BuildContext context) =>
                          const AddInvestmentPage()));
            },
            child: const Text(
              'Add New',
              style: TextStyle(fontSize: kfontMedium, color: kfontColorLight),
            ),
          ),
        ),
      ],
    );
  }

  Widget _investments() {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: [
        const SizedBox(
          height: 28,
        ),
        const Text(
          "Investments performance",
          style: TextStyle(
              fontSize: kfontLarge,
              fontWeight: FontWeight.w500,
              fontFamily: kSecondortfontFamily),
        ),
        const SizedBox(
          height: 16,
        ),
        NetworthLineChart(),
        const SizedBox(
          height: 20,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Investments (3)",
              style: TextStyle(
                  fontSize: kfontLarge,
                  fontWeight: FontWeight.w500,
                  fontFamily: kSecondortfontFamily),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return _listTile(index);
          },
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
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
                      builder: (BuildContext context) =>
                          const AddPensionPage()));
            },
            child: const Text(
              'Add New',
              style: TextStyle(fontSize: kfontMedium, color: kfontColorLight),
            ),
          ),
        ),
      ],
    );
  }
}

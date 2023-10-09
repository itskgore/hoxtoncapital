import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';

import '../../core/config/app_config.dart';
import 'add_income_sources_page.dart';

class IncomeSourceSuccessPage extends StatelessWidget {
  // const AddAssetSuccessPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: wedgeAppBar(context: context, title: SUCCESS),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                addAssetsSuccessMessage(PRIMARY_INCOME),
                style: TextStyle(fontSize: kfontMedium, color: kfontColorDark),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 80,
                        child: Icon(
                          Icons.comment_bank,
                          color: appThemeColors!.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 1,
                        color: Colors.grey[200],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 20.0),
                          child: Text(
                            "454000 GBP",
                            style: TextStyle(
                                fontSize: kfontMedium,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Account Type ",
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Country",
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
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
                      builder: (BuildContext context) => AddIncomeSourcesPage()
                      // AddBankAccountPage()
                      ));
            },
            child: Text(
              ADD_MORE,
              style: TextStyle(fontSize: kfontMedium),
            ),
          ),
        ));
  }
}

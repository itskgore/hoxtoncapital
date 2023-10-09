import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_currency_picker.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';

import '../../../../income_source_success.dart';

class AddPrimaryIncomePage extends StatefulWidget {
  // AddPrimaryIncomePage({Key key}) : super(key: key);

  @override
  _AddPrimaryIncomePageState createState() => _AddPrimaryIncomePageState();
}

class _AddPrimaryIncomePageState extends State<AddPrimaryIncomePage> {
  Country _selectedDialogCurrency =
      CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);

  @override
  void initState() {
    super.initState();
    _selectedDialogCurrency =
        CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: wedgeAppBar(context: context, title: ADD_PRIMARY_INCOME),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text(
                addAssetsTitleMessage(PRIMARY_INCOME),
                style: kheadingDescriptionText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              const TextField(
                //1
                decoration: InputDecoration(
                  border: ktextFeildOutlineInputBorder,
                  hintText: EMPLOYER_NAME_BUSINESS_DESCRIPTION,
                ),
              ),
              const SizedBox(
                height: ktextBoxGap,
              ),
              const TextField(
                //1
                decoration: InputDecoration(
                  border: ktextFeildOutlineInputBorder,
                  hintText: EMPLOYER_NAME_BUSINESS_DESCRIPTION,
                ),
              ),
              const SizedBox(
                height: ktextBoxGap,
              ),
              TextField(
                //2
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: ktextFeildOutlineInputBorder,
                    hintText: MONTHLY_INCOME,
                    suffixStyle: const TextStyle(color: Colors.black),
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
                                _selectedDialogCurrency.currencyCode.toString(),
                                style: const TextStyle(color: kfontColorDark),
                              ),
                              const Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        ))),
              ),
              const SizedBox(
                height: ktextBoxGap,
              ),
              const SizedBox(
                height: ktextBoxGap,
              ),
            ],
          ),
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
                      builder: (BuildContext context) =>
                          IncomeSourceSuccessPage()
                      // AddBankAccountPage()
                      )).then((value) {
                FocusManager.instance.primaryFocus?.unfocus();
              });
            },
            child: const Text(
              SAVE,
              style: TextStyle(fontSize: kfontMedium),
            ),
          ),
        ));
  }
}

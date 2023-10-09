import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_currency_picker.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';

class AddMortgagePage extends StatefulWidget {
  // AddMortgagePage({Key key}) : super(key: key);

  @override
  _AddMortgagePageState createState() => _AddMortgagePageState();
}

class _AddMortgagePageState extends State<AddMortgagePage> {
  //define country and currency pickers
  Country _selectedDialogCurrency =
      CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);

  AppLocalizations? translate;

  @override
  void initState() {
    super.initState();
    //assign default country and currency
    _selectedDialogCurrency =
        CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
    _selectedDialogCountry =
        CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          backgroundColor: kBackgroundColor,
          iconTheme: IconThemeData(
            color: appThemeColors!.primary, //change your color here
          ),
          elevation: 0.0,
          title: const Text(
            ADD_MORTGAGE,
            style: TextStyle(color: kfontColorDark),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 40,
              ),
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: ktextFeildOutlineInputBorder,
                  labelText: translate!.mortgageProviderName,
                ),
              ),
              const SizedBox(
                height: ktextBoxGap,
              ),
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: ktextFeildOutlineInputBorder,
                  labelText: translate!.mortgageProviderName,
                ),
              ),
              const SizedBox(
                height: ktextBoxGap,
              ),
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: ktextFeildOutlineInputBorder,
                    labelText: translate!.outStanding,
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
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: ktextFeildOutlineInputBorder,
                  labelText: translate!.interestRate,
                ),
              ),
              const SizedBox(
                height: ktextBoxGap,
              ),
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: ktextFeildOutlineInputBorder,
                  labelText: translate!.termRemaining,
                ),
              ),
              const SizedBox(
                height: ktextBoxGap,
              ),
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: ktextFeildOutlineInputBorder,
                    labelText: translate!.monthlyPayment,
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
                height: 10,
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
              Navigator.pop(context, true);
            },
            child: Text(
              translate!.save,
              style:
                  const TextStyle(fontSize: kfontMedium, color: Colors.white),
            ),
          ),
        ));
  }
}

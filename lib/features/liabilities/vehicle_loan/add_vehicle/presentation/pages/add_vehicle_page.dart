import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_country_picker.dart';
import 'package:wedge/core/utils/wedge_currency_picker.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';

class AddVehiclePage extends StatefulWidget {
  // AddVehiclePage({Key key}) : super(key: key);

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  //define country and currency pickers
  Country _selectedDialogCurrency =
      CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);

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
    var translate = translateStrings(context);
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: wedgeAppBar(context: context, title: ADD_VEHICLE),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: ktextFeildOutlineInputBorder,
                  hintText: translate!.vehicleName,
                ),
              ),
              const SizedBox(
                height: ktextBoxGap,
              ),
              GestureDetector(
                onTap: () {
                  WedgeCountryPicker(
                      context: context,
                      countryPicked: (Country country) {
                        setState(() {
                          _selectedDialogCountry = country;
                        });
                      });
                },
                child: Container(
                  child: Center(
                      child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      // CountryPickerUtils.getDefaultFlagImage(
                      //     _selectedDialogCountry),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Text(_selectedDialogCountry.name.toString()),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  )),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: ktextfeildBorderRadius,
                  ),
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
                    hintText: translate.value,
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
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: const Text(
              SAVE,
              style: TextStyle(fontSize: kfontMedium, color: Colors.white),
            ),
          ),
        ));
  }
}

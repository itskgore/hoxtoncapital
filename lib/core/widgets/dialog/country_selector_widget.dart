import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';

import '../../contants/string_contants.dart';
import '../../contants/theme_contants.dart';
import '../../utils/wedge_country_picker.dart';

class CountrySelector extends StatefulWidget {
  CountrySelector({Key? key, required this.onChange, this.updateCountry})
      : super(key: key);
  String? updateCountry;
  Function(String) onChange;

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);
  String? _country;
  @override
  void initState() {
    if (widget.updateCountry != null) {
      try {
        if (widget.updateCountry!.length == 3) {
          _country = getCountryNameFromISO3(
              name: widget.updateCountry!, isTrim: false);
        } else {
          _country =
              CountryPickerUtils.getCountryByIsoCode(widget.updateCountry!)
                  .name;
        }
      } catch (e) {
        if (widget.updateCountry!.length == 3) {
          _country = getCountryNameFromISO3(
              name: widget.updateCountry!, isTrim: false);
        } else {
          _country = widget.updateCountry!;
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          WedgeCountryPicker(
              context: context,
              countryPicked: (Country country) {
                widget.onChange(country.iso3Code!);
                setState(() {
                  _country = country.name;
                  _selectedDialogCountry = country;
                });
              });
        },
        child: Container(
          height: 53,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xfffD6D6D6)),
            borderRadius: ktextfeildBorderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(bottom: 15),
          alignment: Alignment.center,
          child: Row(
            children: [
              _country?.isEmpty ?? false
                  ? Text(
                      translate!.selectCountry,
                      overflow: TextOverflow.ellipsis,
                      style: SubtitleHelper.h10
                          .copyWith(color: appThemeColors!.disableText),
                    )
                  : Expanded(
                      child: Text(
                        _country ??
                            _selectedDialogCountry.name
                                .toString()
                                .toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: SubtitleHelper.h10,
                      ),
                    ),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      );
}

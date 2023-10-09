import 'package:country_currency_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/countries.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';

class WedgeCountryCodePicker {
  //to get all the global currencies with countries
  final context;
  final Function(Country) countryPicked;
  final TextEditingController _nameContr = TextEditingController();
  TextFieldValidator validator = TextFieldValidator();

  WedgeCountryCodePicker({this.context, required this.countryPicked}) {
    showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)), //this right here
              child: CountryCodePickerWidget(
                nameContr: _nameContr,
                countryPicked: (_) {
                  return countryPicked(_);
                },
                validator: validator,
                dummySearch: CountriesWithCodes().countriesWithCode,
              ),
            )));
  }
}

class CountryCodePickerWidget extends StatefulWidget {
  CountryCodePickerWidget({
    Key? key,
    required this.countryPicked,
    required TextEditingController nameContr,
    required this.dummySearch,
    required this.validator,
  })  : _nameContr = nameContr,
        super(key: key);
  final Function(Country) countryPicked;
  final TextEditingController _nameContr;
  List<dynamic> dummySearch;
  final TextFieldValidator validator;

  @override
  State<CountryCodePickerWidget> createState() => _CurrencyPickerWidgetState();
}

class _CurrencyPickerWidgetState extends State<CountryCodePickerWidget> {
  List<dynamic> dummySearchData = [];

  @override
  void initState() {
    dummySearchData = widget.dummySearch;
    super.initState();
  }

  @override
  void dispose() {
    widget._nameContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 360,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                translate!.selectCountryCode,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: appThemeHeadlineFont,
                    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
                    fontSize: appThemeHeadlineSizes!.h8),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: CustomFormTextField(
                inputDecoration: InputDecoration(
                  hintText: translate!.searchByCountry,
                  hintStyle: TextStyle(fontFamily: appThemeSubtitleFont),
                ),
                paddingBottom: 5,
                autoFocused: true,
                onChanged: (onChangeValue) {
                  if (onChangeValue.isNotEmpty) {
                    setState(() {
                      dummySearchData = CountriesWithCodes().countriesWithCode;

                      dummySearchData.removeWhere((element) {
                        String value =
                            "${element['country']} ${element['alpha3']}"
                                .toLowerCase();
                        if (!value.contains(onChangeValue.toLowerCase())) {
                          return true;
                        } else {
                          return false;
                        }
                      });
                    });
                  } else {
                    setState(() {
                      dummySearchData = CountriesWithCodes().countriesWithCode;
                    });
                  }
                },
                hintText: translate!.searchByCountry,
                inputType: TextInputType.text,
                allowNum: true,
                textEditingController: widget._nameContr,
                validator: (value) =>
                    widget.validator.validateName(value?.trim(), ""),
              ),
            ),
            Expanded(
              child: dummySearchData.isEmpty
                  ? Center(
                      child: Text(
                        translate!.noCountryCodeFound,
                        style: TextStyle(fontFamily: appThemeSubtitleFont),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                          children:
                              List.generate(dummySearchData.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            widget.countryPicked(Country(
                              phoneCode: "${dummySearchData[index]['alpha3']}",
                              currencyName:
                                  "${dummySearchData[index]['country']}",
                              iso3Code: "${dummySearchData[index]['alpha3']}",
                            ));
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 0.08))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 70,
                                    child: Text(
                                      "(${dummySearchData[index]['alpha3']})",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: appThemeSubtitleSizes!.h10,
                                          fontFamily: appThemeSubtitleFont),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${dummySearchData[index]['country']}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: appThemeSubtitleSizes!.h10,
                                          fontFamily: appThemeSubtitleFont),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

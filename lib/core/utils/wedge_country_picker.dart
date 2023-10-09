import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/countries.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';

class WedgeCountryPicker {
  final context;
  final Function(Country) countryPicked;
  final TextEditingController _nameContr = TextEditingController();
  TextFieldValidator validator = TextFieldValidator();
  WedgeCountryPicker({this.context, required this.countryPicked}) {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async {
                // Return false to restrict the back button when the dialog is visible
                return false;
              },
              child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: Colors.pink),
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.0)), //this right here
                    child: CountryPickerWidget(
                      nameContr: _nameContr,
                      countryPicked: (_) {
                        return countryPicked(_);
                      },
                      validator: validator,
                      dummySearch: CountriesWithCodes().countriesWithCode,
                    ),
                  )),
            ));
  }

  Widget _buildCountryDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8.0),
          // Text("(${country.phoneCode})"),
          const SizedBox(width: 8.0),
          Flexible(child: Text(country.name ?? ''))
        ],
      );
}

class CountryPickerWidget extends StatefulWidget {
  CountryPickerWidget({
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
  State<CountryPickerWidget> createState() => _CurrencyPickerWidgetState();
}

class _CurrencyPickerWidgetState extends State<CountryPickerWidget> {
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
              translate!.selectCountry,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: appThemeHeadlineFont,
                  fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
                  fontSize: appThemeHeadlineSizes!.h8),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: CustomFormTextField(
              inputDecoration: InputDecoration(
                  hintText: 'Search by country',
                  hintStyle: TextStyle(fontFamily: appThemeSubtitleFont)),
              paddingBottom: 5,
              onChanged: (newValue) {
                if (newValue.isNotEmpty) {
                  setState(() {
                    dummySearchData = CountriesWithCodes().countriesWithCode;

                    dummySearchData.removeWhere((element) {
                      String value =
                          "${element['country']} ${element['currencyCode']}"
                              .toLowerCase();
                      if (!value.contains(newValue.toLowerCase())) {
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
              hintText: "Search by country",
              inputType: TextInputType.text,
              textEditingController: widget._nameContr,
              validator: (value) =>
                  widget.validator.validateName(value?.trim(), "country"),
            ),
          ),
          Expanded(
            child: dummySearchData.isEmpty
                ? Center(
                    child: Text(
                      "No country found",
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
                            currencyCode:
                                "${dummySearchData[index]['currencyCode']}",
                            currencyName:
                                "${dummySearchData[index]['currencyCode']}",
                            iso3Code: "${dummySearchData[index]['alpha3']}",
                            isoCode: "${dummySearchData[index]['alpha3']}",
                            name: "${dummySearchData[index]['country']}",
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
                                Text(
                                    "(${dummySearchData[index]['currencyCode']})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: appThemeSubtitleSizes!.h10,
                                        fontFamily: appThemeSubtitleFont)),
                                const SizedBox(
                                  width: 10,
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
    );
  }
}

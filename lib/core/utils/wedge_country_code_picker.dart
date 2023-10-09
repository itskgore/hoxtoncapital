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
  final bool? showCounterCode;
  final String? popTitle;
  final String? placeholder;
  final Function(Country) countryPicked;
  final TextEditingController _nameContr = TextEditingController();
  TextFieldValidator validator = TextFieldValidator();
  WedgeCountryCodePicker(
      {this.context,
      required this.countryPicked,
      this.showCounterCode,
      this.placeholder,
      this.popTitle}) {
    showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)), //this right here
              child: CountryCodePickerWidget(
                placeholder: placeholder,
                nameController: _nameContr,
                showCounterCode: showCounterCode,
                popTitle: popTitle,
                countryPicked: (_) {
                  return countryPicked(_);
                },
                validator: validator,
                dummySearch: CountriesWithCodes().countriesWithPhoneCode,
              ),
            )));
  }
}

class CountryCodePickerWidget extends StatefulWidget {
  final Function(Country) countryPicked;
  final TextEditingController _nameController;
  final TextFieldValidator validator;
  final bool? showCounterCode;
  List<dynamic> dummySearch;
  String? popTitle;
  CountryCodePickerWidget({
    Key? key,
    required this.countryPicked,
    required TextEditingController nameController,
    required this.validator,
    this.popTitle,
    this.placeholder,
    this.showCounterCode,
    required this.dummySearch,
  })  : _nameController = nameController,
        super(key: key);

  String? placeholder;

  @override
  State<CountryCodePickerWidget> createState() =>
      _CountryCodePickerWidgetState();
}

class _CountryCodePickerWidgetState extends State<CountryCodePickerWidget> {
  List<dynamic> dummySearchData = [];

  @override
  void initState() {
    dummySearchData = widget.dummySearch;
    super.initState();
  }

  @override
  void dispose() {
    widget._nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              widget.popTitle ?? "Select currency",
              textAlign: TextAlign.center,
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
                hintText: widget.placeholder ?? translate!.searchByCurrency,
                hintStyle: TextStyle(fontFamily: appThemeSubtitleFont),
              ),
              paddingBottom: 5,
              autoFocused: true,
              onChanged: (_) {
                if (_.isNotEmpty) {
                  setState(() {
                    dummySearchData =
                        CountriesWithCodes().countriesWithPhoneCode;
                    dummySearchData.removeWhere((element) {
                      String value =
                          "${element['country_name']} ${element['country_calling_code']}"
                              .toLowerCase();
                      if (!value.contains(_.toLowerCase())) {
                        return true;
                      } else {
                        return false;
                      }
                    });
                  });
                } else {
                  setState(() {
                    dummySearchData =
                        CountriesWithCodes().countriesWithPhoneCode;
                  });
                }
              },
              hintText: "Search by currency",
              inputType: TextInputType.text,
              textEditingController: widget._nameController,
              validator: (value) =>
                  widget.validator.validateName(value?.trim(), "currency"),
            ),
          ),
          Expanded(
            child: dummySearchData.isEmpty
                ? Center(
                    child: Text(
                      "No currency found",
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
                                "${dummySearchData[index]['country_calling_code']}",
                            currencyName:
                                "${dummySearchData[index]['country_name']}",
                            isoCode:
                                "${dummySearchData[index]['alpha_3_code']}",
                            phoneCode:
                                "${dummySearchData[index]['country_calling_code']}",
                            iso3Code:
                                "${dummySearchData[index]['country_calling_code']}",
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
                                widget.showCounterCode ?? true
                                    ? Text(
                                        "(+${dummySearchData[index]['country_calling_code']})",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                appThemeSubtitleSizes!.h10,
                                            fontFamily: appThemeSubtitleFont),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "${dummySearchData[index]['country_name']}",
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

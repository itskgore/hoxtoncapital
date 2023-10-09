import 'package:country_currency_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/countries.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';

class WedgeCurrencyPicker {
  //to get all the global currencies with countries
  final context;
  final bool? showCounterCode;
  final String? popTitle;
  final String? placeholder;
  final Function(Country) countryPicked;
  final TextEditingController _nameContr = TextEditingController();
  TextFieldValidator validator = TextFieldValidator();

  WedgeCurrencyPicker(
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
              child: CurrencyPickerWidget(
                placeholder: placeholder,
                nameController: _nameContr,
                showCounterCode: showCounterCode,
                popTitle: popTitle,
                countryPicked: (_) {
                  return countryPicked(_);
                },
                validator: validator,
                dummySearch: CountriesWithCodes().countriesWithCode,
              ),
            )));
  }
}

class CurrencyPickerWidget extends StatefulWidget {
  final Function(Country) countryPicked;
  final TextEditingController _nameController;
  final TextFieldValidator validator;
  final bool? showCounterCode;
  List<dynamic> dummySearch;
  String? popTitle;
  CurrencyPickerWidget({
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
  State<CurrencyPickerWidget> createState() => _CurrencyPickerWidgetState();
}

class _CurrencyPickerWidgetState extends State<CurrencyPickerWidget> {
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
      child: Column(children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            widget.popTitle ?? "Select currency",
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
              hintText: widget.placeholder ?? translate!.searchByCurrency,
              hintStyle: TextStyle(fontFamily: appThemeSubtitleFont),
            ),
            paddingBottom: 5,
            autoFocused: true,
            onChanged: (_) {
              if (_.isNotEmpty) {
                setState(() {
                  dummySearchData = CountriesWithCodes().countriesWithCode;
                  dummySearchData.removeWhere((element) {
                    String value =
                        "${element['country']} ${element['currencyCode']}"
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
                  dummySearchData = CountriesWithCodes().countriesWithCode;
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
                      children: List.generate(dummySearchData.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        widget.countryPicked(Country(
                          currencyCode:
                              "${dummySearchData[index]['currencyCode']}",
                          currencyName: "${dummySearchData[index]['country']}",
                          iso3Code: "${dummySearchData[index]['currencyCode']}",
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
                          child: Row(children: [
                            widget.showCounterCode ?? true
                                ? Text(
                                    "(${dummySearchData[index]['currencyCode']})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: appThemeSubtitleSizes!.h10,
                                        fontFamily: appThemeSubtitleFont),
                                  )
                                : const SizedBox(),
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
                          ]),
                        ),
                      ),
                    );
                  })),
                ),
        ),
      ]),
    );
  }
}

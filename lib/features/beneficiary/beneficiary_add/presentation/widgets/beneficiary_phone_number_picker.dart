import 'package:country_currency_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/widgets/dialog/custom_country_code_picker.dart';

class PhoneNumberPicker extends StatefulWidget {
  final String title;
  final String placeHolder;
  String countryCode;
  final String searchPlaceholder;
  final Function(Country) onCountryChange;
  final String? Function(String?) validator;
  final TextEditingController controller;

  PhoneNumberPicker(
      {Key? key,
      required this.title,
      required this.placeHolder,
      required this.countryCode,
      required this.onCountryChange,
      required this.validator,
      required this.searchPlaceholder,
      required this.controller})
      : super(key: key);

  @override
  State<PhoneNumberPicker> createState() => _PhoneNumberPickerState();
}

class _PhoneNumberPickerState extends State<PhoneNumberPicker> {
  AppLocalizations? translate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    var underlineInputBorder = UnderlineInputBorder(
        borderSide: BorderSide(
            width: 0.5, color: lighten(appThemeColors!.disableText!, .2)));
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          Text(
            widget.title,
            style: SubtitleHelper.h10,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r"\d")),
            ],
            // textAlign: TextAlign.center,
            style: SubtitleHelper.h10.copyWith(
              color: appThemeColors!.outline,
              fontStyle: FontStyle.italic,
            ),
            decoration: InputDecoration(
                prefixIcon: GestureDetector(
                  onTap: () {
                    WedgeCountryCodePicker(
                        context: context,
                        countryPicked: (Country country) {
                          setState(() {
                            widget.countryCode = country.phoneCode!;
                          });
                          widget.onCountryChange(country);
                        });
                  },
                  child: Container(
                    width: 150,
                    child: Row(
                      children: [
                        Text(
                          widget.countryCode.isEmpty
                              ? translate!.countryCode("+44")
                              : translate!.countryCode(widget.countryCode),
                          style: SubtitleHelper.h10.copyWith(
                              fontStyle: FontStyle.italic,
                              color: widget.countryCode.isEmpty
                                  ? lighten(appThemeColors!.textDark!, .5)
                                  : appThemeColors!.outline),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                        ),
                        const Spacer(),
                        Container(
                          height: 20,
                          width: 1,
                          color: lighten(appThemeColors!.disableText!, .5),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
                disabledBorder: underlineInputBorder,
                focusedBorder: underlineInputBorder,
                enabledBorder: underlineInputBorder,
                border: underlineInputBorder,
                hintStyle: SubtitleHelper.h10.copyWith(
                    fontStyle: FontStyle.italic,
                    // fontWeight: FontWeight.w200,
                    color: lighten(appThemeColors!.textDark!, .5)),
                hintText: widget.placeHolder),
          ),
        ],
      ),
    );
  }
}

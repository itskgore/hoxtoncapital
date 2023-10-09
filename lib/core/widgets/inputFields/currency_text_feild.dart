import 'dart:convert';
import 'dart:math' as math;

import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/user_preferences_model.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/dependency_injection.dart';

import '../../contants/string_contants.dart';
import '../../data_models/value_model.dart';
import '../../helpers/textfeild_validator.dart';
import '../../utils/wedge_currency_picker.dart';

class CurrencyTextField extends StatefulWidget {
  CurrencyTextField(
      {required this.onChange,
      required this.hintText,
      required this.errorMsg,
      this.currencyModel,
      this.isOptional,
      this.enabled,
      this.disableCurrency,
      this.showIconAsPrefix,
      this.isFromUpdateBalance,
      this.currencyString,
      Key? key})
      : super(key: key);
  Function(ValueEntity) onChange;
  String hintText;
  String errorMsg;
  ValueEntity? currencyModel;
  bool? enabled;
  bool? isOptional;
  bool? disableCurrency;
  bool? isFromUpdateBalance;
  String? currencyString;
  bool? showIconAsPrefix;
  @override
  State<CurrencyTextField> createState() => CurrencyTextFieldState();
}

class CurrencyTextFieldState extends State<CurrencyTextField> {
  TextFieldValidator validator = TextFieldValidator();
  final TextEditingController _outStandingController = TextEditingController();
  Country _remainingAmountCurrency =
      CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);

  ValueEntity _currencyModel =
      ValueModel(amount: 0, currency: DEFAULT_CURRENCY);

  bool selfChange = false;
  changeCurrency(String currency) {
    if (!selfChange) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _currencyModel.currency = getCurrencyNamefromISO3(currency);
          widget.onChange(_currencyModel);
          _remainingAmountCurrency =
              CountryPickerUtils.getCountryByCurrencyCode(
                  getCurrencyNamefromISO3(currency));
        });
      });
    }
  }

  @override
  void initState() {
    if (widget.currencyModel != null) {
      setEditData();
      setCurrency();
    } else {
      setCurrencyUserPref();
    }
    super.initState();
  }

  setEditData() {
    if (widget.isFromUpdateBalance ?? false) {
      _outStandingController.text = "";
    } else {
      if (widget.currencyModel!.amount.toInt() < 0) {
        _outStandingController.text = "";
      } else {
        _outStandingController.text = widget.currencyModel!.amount.toString();
      }
    }
    if (widget.currencyModel!.currency.isEmpty) {
      setCurrencyUserPref();
    } else {
      _currencyModel = ValueModel(
          amount: widget.currencyModel!.amount,
          currency: widget.currencyModel!.currency);
    }
  }

  setCurrencyUserPref() {
    final data = locator<SharedPreferences>()
        .getString(RootApplicationAccess.userPreferences);
    if (data != null && data.isNotEmpty) {
      final userPref = UserPreferencesModel.fromJson(jsonDecode(data));
      _currencyModel.amount = 0;
      _currencyModel.currency = userPref.preference.currency;
      widget.onChange(_currencyModel);
      _remainingAmountCurrency = CountryPickerUtils.getCountryByCurrencyCode(
          userPref.preference.currency);
    } else {
      _currencyModel = ValueModel(
          amount: 0, currency: _remainingAmountCurrency.currencyCode!);
    }
  }

  setCurrency() {
    try {
      // setState(() {
      _remainingAmountCurrency = CountryPickerUtils.getCountryByCurrencyCode(
          widget.currencyModel!.currency);
      // });

      // print(_remainingAmountCurrency);
    } catch (e) {
      _remainingAmountCurrency =
          CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
    }
  }

  @override
  void dispose() {
    _outStandingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.currencyModel != null) {
      Future.delayed(const Duration(milliseconds: 200), () async {
        if (_outStandingController.text.isEmpty) {
          setState(() {
            if (widget.currencyModel!.amount.toString() != "0") {
              _outStandingController.text =
                  widget.currencyModel!.amount.toString();
              _currencyModel = widget.currencyModel!;
              // _currencyModel = ValueModel(
              //     amount: widget.currencyModel!.amount,
              //     currency: widget.currencyModel!.currency);
              // print(_currencyModel);
              setCurrency();
            }
          });
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 73,
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              enabled: widget.enabled ?? true,

              // enabled: widget.enabled ?? true,
              validator: widget.isOptional ?? false
                  ? null
                  : (value) {
                      return validator.validateAmountWithZero(
                          value?.trim(), widget.hintText);
                    },
              controller: _outStandingController,
              onChanged: (value) {
                final double? amount = double.tryParse(value);
                if (amount != null) {
                  _currencyModel.amount = amount;
                  _currencyModel.currency =
                      _remainingAmountCurrency.currencyCode!;
                  widget.onChange(_currencyModel);
                }
              },
              inputFormatters: <TextInputFormatter>[
                DecimalTextInputFormatter(decimalRange: 2),
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                FilteringTextInputFormatter.allow(
                  RegExp(r'(^\-?\d*\.?\d*)'),
                )
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12),
                prefixIcon: widget.showIconAsPrefix ?? false
                    ? currencyWidget(context)
                    : null,
                suffixIcon: widget.showIconAsPrefix ?? false
                    ? null
                    : currencyWidget(context),
                fillColor: widget.enabled ?? true
                    ? Colors.white
                    : const Color(0xfffF0F1E8),
                filled: true,
                // hintStyle: const TextStyle(
                //     color: WedgeColors.hintTextColor, fontSize: 15),

                enabledBorder: ktextFeildOutlineInputBorder,
                focusedBorder: ktextFeildOutlineInputBorderFocused,
                border: ktextFeildOutlineInputBorder,
                labelText: widget.hintText,
                labelStyle: labelStyle,
                suffixStyle: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          // GestureDetector(
          //     onTap: () async {
          //       WedgeCurrencyPicker(
          //           context: context,
          //           countryPicked: (Country country) {
          //             _currencyModel.currency = country.currencyName!;
          //             widget.onChange(_currencyModel);
          //             setState(() {
          //               _remainingAmountCurrency = country;
          //             });
          //           });
          //     },
          //     child: Container(
          //       width: 85,
          //       height: 61,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: const BorderRadius.only(
          //             topRight: Radius.circular(10),
          //             bottomRight: Radius.circular(10),
          //           ),
          //           border: Border.all(
          //             color: WedgeColors.textFieldBorderColor,
          //             width: 0.5,
          //           )),
          //       alignment: Alignment.center,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             _remainingAmountCurrency.currencyCode.toString(),
          //             style: const TextStyle(
          //                 color: WedgeColors.titleColor, fontSize: 14),
          //           ),
          //           const Icon(
          //             Icons.arrow_drop_down_rounded,
          //             color: WedgeColors.iconColor,
          //             size: 30,
          //           )
          //         ],
          //       ),
          //     )),
        ],
      ),
    );
  }

  Widget currencyWidget(BuildContext context) {
    return widget.currencyString != null
        ? SizedBox(
            width: 60,
            child: Row(
              children: [
                Text(
                  widget.currencyString ?? "",
                  style: TextStyle(
                    color: kfontColorDark,
                    fontFamily: appThemeHeadlineFont,
                  ),
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.only(
                left: widget.showIconAsPrefix ?? false ? 10 : 0),
            child: GestureDetector(
                onTap: widget.disableCurrency ?? false
                    ? () {}
                    : () {
                        WedgeCurrencyPicker(
                            context: context,
                            countryPicked: (Country country) {
                              setState(() {
                                _currencyModel.currency = country.currencyCode!;
                                selfChange = true;

                                widget.onChange(_currencyModel);
                                setState(() {
                                  _remainingAmountCurrency = country;
                                });
                              });
                            });
                      },
                child: SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      Text(
                        _currencyModel.currency,
                        style: TextStyle(
                          color: appThemeColors!.textDark,
                          fontFamily: appThemeHeadlineFont,
                        ),
                      ),
                      widget.disableCurrency ?? false
                          ? Container()
                          : Icon(
                              Icons.arrow_drop_down,
                              color: appThemeColors!.textDark,
                            )
                    ],
                  ),
                )),
          );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

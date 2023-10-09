import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/entities/stocks_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/inputFields/currency_text_feild.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/presentation/bloc/cubit/add_stocks_cubit.dart';
import 'package:wedge/features/assets/stocks/search_stocks/presentation/pages/search_stocks_page.dart';
import 'package:wedge/features/assets/stocks/stocks_main/presentation/pages/add_stocks_main_page.dart';

import '../../../../bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';

class AddStocksPage extends StatefulWidget {
  // AddCustomAssets({Key key}) : super(key: key);
  final StocksAndBondsEntity? assetData;

  AddStocksPage({this.assetData});

  @override
  _AddCustomAssetsState createState() => _AddCustomAssetsState();
}

class _AddCustomAssetsState extends State<AddStocksPage> {
  AppLocalizations? translate;
  Country _selectedDialogCurrency =
      CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);

  final _formKey = GlobalKey<FormState>();
  TextFieldValidator validator = TextFieldValidator();

  TextEditingController _assetName = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _currentValue = TextEditingController();

  bool _isAddingOnprogress = false;

  @override
  void initState() {
    super.initState();
    _selectedDialogCurrency =
        CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);

    ///if editing
    if (widget.assetData != null) {
      // _assetName.text = widget.assetData!.name.toString();
      // _quantity.text = widget.assetData!.quantity.toString();
      // _currentValue.text = widget.assetData!.value.amount.toString();
      _firstNameContr.text = widget.assetData!.name;
      _holdings.text = widget.assetData!.quantity.toString();
      _valueModel = widget.assetData!.value;
      data = {
        "crypto": _firstNameContr.text,
        "symbol": widget.assetData!.symbol,
        "currency": {
          "price": _valueModel!.amount,
          "currency": _valueModel!.currency
        }
      };
    }
  }

  // controller
  final TextEditingController _firstNameContr = TextEditingController();
  final TextEditingController _holdings = TextEditingController();
  ValueEntity? _valueModel;

  var data = {};

  @override
  void dispose() {
    // TODO: implement dispose
    _firstNameContr.dispose();
    _holdings.dispose();
    _quantity.dispose();
    _currentValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    return BlocConsumer<AddStocksCubit, AddStocksState>(
      listener: (context, state) {
        if (state is AddStocksInitial) {
          if (!state.status) {
            if (state.message.toString().isNotEmpty) {
              showSnackBar(context: context, title: state.message.toString());
            }
          }
          if (state.status) {
            _isAddingOnprogress = false;
            if (getIsUserInOnBoardingState()) {
              final manualBankSuccessModel = ManualBankSuccessModel(
                bankName: _firstNameContr.text.trim(),
                location: _holdings.text.trim(),
                currentAmount: _valueModel!.amount.toString(),
                currency: _valueModel!.currency,
              );
              cupertinoNavigator(
                  context: context,
                  screenName: BankSuccessPage(
                      isManuallyAdded: true,
                      manualBankSuccessModel: manualBankSuccessModel),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            } else {
              locator.get<WedgeDialog>().success(
                  context: context,
                  title: widget.assetData == null
                      ? translate!.yourStocksdetailAddedSuccussfully
                      : translate!.yourStocksDetailUpdatedSuccessfully,
                  // "In some cases it may take a while to establish a secure connection to the banking institution. So, if you have added your bank and don't see the information in the home screen, don't worry. We'll be working fast to fetch the details and show you the comprehensive financial data as soon as possible.",
                  info: "",
                  onClicked: () {
                    // int count = 0;
                    // Navigator.of(context).popUntil((_) => count++ >= 2);
                    Navigator.pop(context);
                    if (RootApplicationAccess
                                .assetsEntity?.stocksBonds.length ==
                            1 &&
                        widget.assetData == null) {
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  StocksMainPage()));
                    } else {
                      Navigator.pop(context, state.data);
                    }
                  });
            }
          } else {
            _isAddingOnprogress = false;
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: appThemeColors!.bg,
            appBar: wedgeAppBar(
              context: context,
              title: widget.assetData == null
                  ? "${translate!.add} ${translate!.stocksBonds}"
                  : "${translate!.edit} ${translate!.stocksBonds}",
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(kpadding),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CustomFormTextField(
                      onTap: () async {
                        data = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    const SearchStocksPage()));
                        if (data != null) {
                          // print(data);
                          setState(() {
                            _holdings.text = "1";
                            _firstNameContr.text = data['crypto'];
                            if (_quantity.text.isNotEmpty) {
                              double d = data['currency']['price'] *
                                  num.parse(_quantity.text);
                              _valueModel = ValueEntity(
                                  amount: double.parse(d.toStringAsFixed(2)),
                                  currency: data['currency']['currency']);
                            } else {
                              _valueModel = ValueEntity(
                                  amount: data['currency']['price'],
                                  currency: data['currency']['currency']);
                            }
                          });
                        }
                      },
                      hintText: translate!.name,
                      readOnly: true,
                      inputType: TextInputType.text,
                      noRestriction: true,
                      textEditingController: _firstNameContr,
                      validator: (value) => validator.validateName(
                          value?.trim(), translate!.name),
                    ),
                    CustomFormTextField(
                      onChanged: (_) {
                        if (_.length > 0) {
                          num halfValue = 0;

                          setState(() {
                            if (widget.assetData != null) {
                              if (num.parse(_) < widget.assetData!.quantity) {
                                halfValue = widget.assetData!.value.amount /
                                    widget.assetData!.quantity;
                                data['currency']['price'] = halfValue;
                              }
                            }
                            double d = data['currency']['price'] * num.parse(_);
                            _valueModel = ValueEntity(
                                amount: double.parse(d.toStringAsFixed(2)),
                                currency: data['currency']['currency']);
                          });
                        }
                      },
                      //Your stock/bond details have been added successfully.
                      //Number of holdings
                      //You can add the stocks and bonds you hold outside of your investment platform. The rates are updated daily.

                      hintText: translate!.numberOfHoldings,
                      inputType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decimalAllowed: 4,
                      isDemicalAllowed: true,
                      textEditingController: _holdings,
                      validator: (value) => validator.validateAmount(
                          value?.trim(), translate!.numberOfHoldings,
                          showQuantityMsg: true),
                    ),
                    CurrencyTextField(
                      enabled: false,
                      hintText: VALUE,
                      errorMsg: "${translate!.value} ${translate!.isRequired}",
                      currencyModel: _valueModel,
                      onChange: (value) {
                        _valueModel = value;
                      },
                    ),
                    // TextFormField(
                    //   controller: _assetName,
                    //   validator: (value) =>
                    //       validator.validateName(value?.trim()),
                    //   //2
                    //   decoration: InputDecoration(
                    //     fillColor: Colors.white,
                    //     filled: true,
                    //     border: ktextFeildOutlineInputBorder,
                    //     labelText: NAME,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: ktextBoxGap,
                    // ),
                    // TextFormField(
                    //   controller: _quantity,
                    //   validator: (value) =>
                    //       validator.validateQuantity(value?.trim()),
                    //   //3
                    //   inputFormatters: [
                    //     FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                    //     FilteringTextInputFormatter.allow(
                    //         RegExp(r'(^\-?\d*\.?\d{0,2})'))
                    //   ],
                    //   decoration: InputDecoration(
                    //     fillColor: Colors.white,
                    //     filled: true,
                    //     border: ktextFeildOutlineInputBorder,
                    //     labelText: "Number of holdings",
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: ktextBoxGap,
                    // ),
                    // TextFormField(
                    //   controller: _currentValue,
                    //   validator: (value) =>
                    //       validator.validateAmount(value?.trim()),
                    //   //3
                    //   inputFormatters: [
                    //     DecimalTextInputFormatter(decimalRange: 2),
                    //     FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    //     FilteringTextInputFormatter.allow(
                    //         RegExp(r'(^\-?\d*\.?\d*)'))
                    //   ],
                    //   decoration: InputDecoration(
                    //       fillColor: Colors.white,
                    //       filled: true,
                    //       border: ktextFeildOutlineInputBorder,
                    //       labelText: VALUE,
                    //       suffixStyle: TextStyle(color: Colors.black),
                    //       suffix: GestureDetector(
                    //           onTap: () async {
                    //             WedgeCurrencyPicker(
                    //                 context: context,
                    //                 countryPicked: (Country country) {
                    //                   setState(() {
                    //                     _selectedDialogCurrency = country;
                    //                   });
                    //                 });
                    //           },
                    //           child: Container(
                    //             width: 60,
                    //             child: Row(
                    //               children: [
                    //                 Text(
                    //                   _selectedDialogCurrency.currencyCode
                    //                       .toString(),
                    //                   style: TextStyle(color: kfontColorDark),
                    //                 ),
                    //                 Icon(Icons.arrow_drop_down)
                    //               ],
                    //             ),
                    //           ))),
                    // ),
                    // SizedBox(
                    //   height: 30.0,
                    // ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.blueAccent)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: Text(
                                translate!.youCanAddStocksMessage,
                                style: SubtitleHelper.h11.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: ktextBoxGap,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavSingleButtonContainer(
              child: BlocBuilder<AddStocksCubit, AddStocksState>(
                builder: (context, state) {
                  return WedgeSaveButton(
                      onPressed: _isAddingOnprogress
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isAddingOnprogress = true;
                                });
                                if (widget.assetData == null) {
                                  context.read<AddStocksCubit>().addAsset(
                                      _firstNameContr.text.trim(),
                                      _holdings.text.trim(),
                                      _valueModel!.amount.toString(),
                                      _valueModel!.currency,
                                      data['symbol']);
                                } else {
                                  context.read<AddStocksCubit>().updateAsset(
                                      _firstNameContr.text.trim(),
                                      _holdings.text.trim(),
                                      _valueModel!.amount.toString().trim(),
                                      widget.assetData?.id,
                                      _valueModel!.currency,
                                      data['symbol']);
                                }
                              }
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                      title: widget.assetData == null
                          ? translate!.save
                          : translate!.update,
                      isLoaing: state is AddStocksLoading);
                },
              ),
            ));
      },
    );
  }
}

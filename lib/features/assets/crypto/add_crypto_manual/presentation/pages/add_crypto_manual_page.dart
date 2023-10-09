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
import 'package:wedge/core/entities/cryptp_currency_entity.dart';
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
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/domain/usecases/params/add_update_cryto_params.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/presentation/bloc/add_crypto_bloc_cubit.dart';
import 'package:wedge/features/assets/crypto/crypto_main/presentation/pages/crypto_main_page.dart';
import 'package:wedge/features/assets/crypto/crypto_search/presentation/pages/search_crypto_page.dart';

class AddCryptoManualPage extends StatefulWidget {
  const AddCryptoManualPage({Key? key, this.cryptoCurrenciesEntity})
      : super(key: key);

  // AddCryptoManualPage({Key key}) : super(key: key);
  final CryptoCurrenciesEntity? cryptoCurrenciesEntity;

  @override
  _AddCryptoManualPageState createState() => _AddCryptoManualPageState();
}

class _AddCryptoManualPageState extends State<AddCryptoManualPage> {
  Country _selectedDialogCurrency =
      CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);

  AppLocalizations? translate;

  @override
  void initState() {
    super.initState();
    _selectedDialogCurrency =
        CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
    if (widget.cryptoCurrenciesEntity != null) {
      // populate the text fields here
      _nameContr.text = widget.cryptoCurrenciesEntity!.name;
      _quantityContr.text = widget.cryptoCurrenciesEntity!.quantity.toString();
      _valueModel = widget.cryptoCurrenciesEntity!.value;
      data = {
        "crypto": _nameContr.text,
        "symbol": widget.cryptoCurrenciesEntity!.symbol,
        "currency": {
          "price": _valueModel!.amount,
          "currency": _valueModel!.currency
        }
      };
    }
  }

  // fields declarations
  final _formKey = GlobalKey<FormState>();
  final _personalLoanFormKey = GlobalKey<FormState>();
  TextFieldValidator validator = TextFieldValidator();
  final TextEditingController _nameContr = TextEditingController();
  final TextEditingController _quantityContr = TextEditingController();
  ValueEntity? _valueModel;

  Future<void> submit() async {
    final addUpdateBloc =
        BlocProvider.of<AddCryptoBlocCubit>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      if (widget.cryptoCurrenciesEntity != null) {
        // update
        addUpdateBloc.udpateCrypto(AddUpdateCryptoParams(
            name: _nameContr.text,
            symbol: data['symbol'],
            quantity: double.parse(_quantityContr.text),
            value: _valueModel!,
            id: widget.cryptoCurrenciesEntity!.id));
      } else {
        // add
        addUpdateBloc.addCrypto(AddUpdateCryptoParams(
            name: _nameContr.text,
            symbol: data['symbol'],
            quantity: double.parse(_quantityContr.text),
            value: _valueModel!));
      }
    }
  }

  Future<void> addUdpateData(AddUpdateCryptoParams paras) async {
    final addUpdateBloc =
        BlocProvider.of<AddCryptoBlocCubit>(context, listen: false);
  }

  var data = {};

  @override
  void dispose() {
    // TODO: implement dispose
    _nameContr.dispose();
    _quantityContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: widget.cryptoCurrenciesEntity == null
                ? "${translate!.add} ${translate!.cryptoCurrencies}"
                : "${translate!.edit} ${translate!.cryptoCurrencies}"),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
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
                            builder: (context) => const SearchCryptoPage()));
                    if (data != null) {
                      // print(data);
                      _quantityContr.text = "1";
                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() {
                          _nameContr.text = data['crypto'];
                          if (_quantityContr.text.isNotEmpty) {
                            double d = data['currency']['price'] *
                                num.parse(_quantityContr.text);
                            _valueModel = ValueEntity(
                                amount: double.parse(d.toStringAsFixed(2)),
                                currency: data['currency']['currency']);
                          } else {
                            _valueModel = ValueEntity(
                                amount: data['currency']['price'],
                                currency: data['currency']['currency']);
                            // print(_valueModel);
                          }
                        });
                      });
                    }
                  },
                  hintText: NAME,
                  readOnly: true,
                  inputType: TextInputType.text,
                  noRestriction: true,
                  textEditingController: _nameContr,
                  validator: (value) =>
                      validator.validateName(value?.trim(), NAME),
                ),
                CustomFormTextField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      num halfValue = 0;
                      setState(() {
                        if (data.isNotEmpty) {
                          if (widget.cryptoCurrenciesEntity != null) {
                            if (num.parse(value) <
                                widget.cryptoCurrenciesEntity!.quantity) {
                              halfValue =
                                  widget.cryptoCurrenciesEntity!.value.amount /
                                      widget.cryptoCurrenciesEntity!.quantity;
                              data['currency']['price'] = halfValue;
                            }
                          }
                          double d =
                              data['currency']['price'] * num.parse(value);
                          _valueModel = ValueEntity(
                              amount: double.parse(d.toStringAsFixed(2)),
                              currency: data['currency']['currency']);
                        }
                      });
                    }
                  },
                  hintText: QUANTITY,
                  decimalAllowed: 10,
                  isDemicalAllowed: true,
                  inputType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textEditingController: _quantityContr,
                  validator: (value) => validator
                      .validateQuantity(value?.trim(), showDifferentMsg: true),
                ),
                CurrencyTextField(
                  enabled: false,
                  hintText: translate!.value,
                  errorMsg: "${translate!.value} ${translate!.isRequired}",
                  currencyModel: _valueModel,
                  onChange: (value) {
                    _valueModel = value;
                  },
                ),
                const SizedBox(
                  height: ktextBoxGap,
                ),
                const SizedBox(
                  height: ktextBoxGap,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
            child: BlocConsumer<AddCryptoBlocCubit, AddCryptoBlocState>(
          listener: (context, state) {
            if (getIsUserInOnBoardingState()) {
              if (state is AddCryptoBlocLoaded) {
                final manualBankSuccessModel = ManualBankSuccessModel(
                  bankName: _nameContr.text,
                  location: data['symbol'],
                  currentAmount: _valueModel!.toString(),
                  currency: double.parse(_quantityContr.text).toString(),
                );
                cupertinoNavigator(
                    context: context,
                    screenName: BankSuccessPage(
                      isManuallyAdded: true,
                      manualBankSuccessModel: manualBankSuccessModel,
                    ),
                    type: NavigatorType.PUSHREMOVEUNTIL);
              } else {
                locator.get<WedgeDialog>().success(
                    context: context,
                    title: widget.cryptoCurrenciesEntity == null
                        ? translate!.cryptoaddedSuccessfullyMessage
                        : translate!.cryptoUpdatedSuccessfullyMessage,
                    info: "",
                    onClicked: () {
                      Navigator.pop(context);
                      if (RootApplicationAccess
                                  .assetsEntity?.cryptoCurrencies.length ==
                              1 &&
                          widget.cryptoCurrenciesEntity == null) {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    const CryptoMainPage()));
                      } else {
                        Navigator.pop(context, true);
                      }
                    });
              }
            } else if (state is AddCryptoBlocError) {
              showSnackBar(context: context, title: state.error);
            }
          },
          builder: (context, state) {
            return WedgeSaveButton(
                onPressed: state is AddCryptoBlocLoading
                    ? null
                    : () {
                        submit();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                title: widget.cryptoCurrenciesEntity == null
                    ? translate!.save
                    : translate!.update,
                isLoaing: state is AddCryptoBlocLoading);
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       primary: appThemeColors!.primary,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10))),
            //   onPressed: state is AddCryptoBlocLoading
            //       ? null
            //       : () {
            //           submit();
            //         },
            //   child: state is AddCryptoBlocLoading
            //       ? buildCircularProgressIndicator()
            //       : Text(
            //           widget.cryptoCurrenciesEntity == null
            //               ? translate!.save
            //               : translate!.update,
            //           style:
            //               TextStyle(fontSize: kfontMedium, color: Colors.white),
            //         ),
            // );
          },
        )));
  }
}

import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/core/widgets/dialog/country_selector_widget.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/inputFields/currency_text_feild.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/presentation/bloc/cubit/add_manual_bank_cubit.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_drop_down/presentation/pages/custom_assets_drop_down.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/presentation/pages/custom_assets_main_page.dart';

class AddCustomAssetsPage extends StatefulWidget {
  // AddCustomAssets({Key key}) : super(key: key);
  final OtherAssetsEntity? assetData;

  AddCustomAssetsPage({this.assetData});

  @override
  _AddCustomAssetsState createState() => _AddCustomAssetsState();
}

class _AddCustomAssetsState extends State<AddCustomAssetsPage> {
  Country _selectedDialogCurrency =
      CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);

  // Country _selectedDialogCountry =
  //     CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);

  final _formKey = GlobalKey<FormState>();
  TextFieldValidator validator = TextFieldValidator();

  final TextEditingController _assetName = TextEditingController();
  final TextEditingController _currentValue = TextEditingController();
  String? _type = "";

  bool _isAddingOnprogress = false;
  String _country = "GBR";
  ValueEntity? _valueModel;
  GlobalKey<CurrencyTextFieldState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedDialogCurrency =
        CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);

    ///if editing
    if (widget.assetData != null) {
      _assetName.text = widget.assetData!.name.toString();
      _currentValue.text = widget.assetData!.value.amount.toString();
      _type = widget.assetData!.type;
      _country = widget.assetData!.country;
      _valueModel = widget.assetData!.value;
    }
  }

  bool isCustomAssetsFetchLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _currentValue.dispose();
    _assetName.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);

    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
          context: context,
          title: widget.assetData == null
              ? "${translate!.add} ${translate.customAssets}"
              : "${translate!.edit} ${translate.customAssets}",
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    CustomAssetsDropDown(
                      getData: (_) {
                        _type = _;
                      },
                      type: _type ?? "",
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                  ],
                ),
                CustomFormTextField(
                  hintText: translate.name,
                  inputType: TextInputType.text,
                  noRestriction: true,
                  textEditingController: _assetName,
                  validator: (value) =>
                      validator.validateName(value?.trim(), translate.name),
                ),
                CountrySelector(
                    updateCountry: _country,
                    onChange: (_) {
                      setState(() {
                        _country = _;
                        globalKey.currentState?.changeCurrency(_);
                      });
                    }),
                CurrencyTextField(
                    key: globalKey,
                    currencyModel: _valueModel,
                    onChange: (_) {
                      _valueModel =
                          ValueEntity(amount: _.amount, currency: _.currency);
                    },
                    hintText: translate.value,
                    errorMsg: "${translate.value} ${translate.isRequired}"),
                const SizedBox(
                  height: 30.0,
                ),
                const SizedBox(
                  height: ktextBoxGap,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
            child: BlocConsumer<AddCustomAssetsCubit, AddCustomAssetsState>(
          listener: (context, state) {
            if (state is AddCustomAssetsInitial) {
              if (state.status) {
                _isAddingOnprogress = false;

                if (getIsUserInOnBoardingState()) {
                  final manualBankSuccessModel = ManualBankSuccessModel(
                    bankName: _assetName.text.trim(),
                    location: _country,
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
                          ? translate.assetaddedSuccesfullMessage
                          : translate.assetUpdatedSuccessfullyMessage,
                      // "In some cases it may take a while to establish a secure connection to the banking institution. So, if you have added your bank and don't see the information in the home screen, don't worry. We'll be working fast to fetch the details and show you the comprehensive financial data as soon as possible.",
                      info: "",
                      onClicked: () {
                        // int count = 0;
                        // Navigator.of(context).popUntil((_) => count++ >= 2);
                        Navigator.pop(context);
                        if (RootApplicationAccess
                                    .assetsEntity?.otherAssets.length ==
                                1 &&
                            widget.assetData == null) {
                          Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      const CustomAssetsMainPage()));
                        } else {
                          Navigator.pop(context, true);
                        }
                      });
                }
              } else {
                _isAddingOnprogress = false;
              }
            }
            if (state is AddCustomAssetsInitial) {
              if (state.message.toString().isNotEmpty) {
                _isAddingOnprogress = false;
                setState(() {});
                showSnackBar(context: context, title: state.message.toString());
              }
            }
          },
          builder: (context, state) {
            return WedgeSaveButton(
                onPressed: _isAddingOnprogress
                    ? null
                    : () {
                        if (_country.isEmpty) {
                          showSnackBar(
                              context: context, title: "Please select country");
                        } else {
                          if (_formKey.currentState!.validate()) {
                            if (widget.assetData == null) {
                              print(_valueModel!.currency);
                              setState(() {
                                _isAddingOnprogress = true;
                              });
                              context.read<AddCustomAssetsCubit>().addAsset(
                                    _assetName.text.trim(),
                                    _country,
                                    _type,
                                    _valueModel!.amount.toString(),
                                    _valueModel!.currency,
                                  );
                              setState(() {
                                _isAddingOnprogress = false;
                              });
                            } else {
                              setState(() {
                                _isAddingOnprogress = true;
                              });
                              context.read<AddCustomAssetsCubit>().updateAsset(
                                    _assetName.text.trim(),
                                    _country,
                                    _type,
                                    _valueModel!.amount.toString(),
                                    widget.assetData?.id,
                                    _valueModel!.currency,
                                  );
                            }
                          }
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                title: widget.assetData == null
                    ? translate.save
                    : translate.update,
                isLoaing: state is AddCustomAssetsLoading);
          },
        )));
  }
}

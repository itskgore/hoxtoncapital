import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/entities/investment_entity.dart';
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
import 'package:wedge/features/assets/invesntment/add_investment_manual/presentation/bloc/cubit/add_investment_cubit.dart';
import 'package:wedge/features/assets/invesntment/investment_main/presentation/pages/add_investment_main_page.dart';

import '../../../../bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';
import '../../../investment_main/presentation/bloc/cubit/investments_cubit.dart';

class AddInvestmentManualPage extends StatefulWidget {
  final InvestmentEntity? assetData;
  bool? isFromDashboard;

  AddInvestmentManualPage({super.key, this.assetData, this.isFromDashboard});

  @override
  _AddCustomAssetsState createState() => _AddCustomAssetsState();
}

class _AddCustomAssetsState extends State<AddInvestmentManualPage> {
  final _formKey = GlobalKey<FormState>();
  TextFieldValidator validator = TextFieldValidator();

  final TextEditingController _assetName = TextEditingController();
  final TextEditingController _policyNumber = TextEditingController();

  String? _country = "GBR";
  bool _isAddingOnProgress = false;
  ValueEntity? _valueModel;
  ValueEntity? _currentValueModel;
  GlobalKey<CurrencyTextFieldState> globalKey = GlobalKey();
  GlobalKey<CurrencyTextFieldState> globalKey2 = GlobalKey();

  @override
  void initState() {
    super.initState();

    ///if editing
    if (widget.assetData != null) {
      _assetName.text = widget.assetData!.name.toString();
      _policyNumber.text = widget.assetData!.policyNumber.toString();
      _country = widget.assetData!.country;
      _valueModel = widget.assetData!.initialValue;
      _currentValueModel = widget.assetData!.currentValue;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _assetName.dispose();
    _policyNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);

    return BlocConsumer<AddInvestmentCubit, AddInvestmentState>(
      listener: (context, state) {
        if (state is AddInvestmentInitial) {
          if (!state.status) {
            if (state.message.toString().isNotEmpty) {
              showSnackBar(context: context, title: state.message.toString());
            }
          }
          if (state.status) {
            _isAddingOnProgress = false;

            if (getIsUserInOnBoardingState()) {
              final manualBankSuccessModel = ManualBankSuccessModel(
                bankName: _assetName.text.trim(),
                location: _country ?? '',
                currentAmount: _valueModel!.amount.toString(),
                currency: _valueModel!.currency.toString(),
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
                      ? translate!.yourInvestmentaddedSuccessfully
                      : translate!.yourInvestmentUpdatedSuccessfully,
                  // "In some cases it may take a while to establish a secure connection to the banking institution. So, if you have added your bank and don't see the information in the home screen, don't worry. We'll be working fast to fetch the details and show you the comprehensive financial data as soon as possible.",
                  info: "",
                  onClicked: () {
                    Navigator.pop(context);

                    if (RootApplicationAccess
                                .assetsEntity?.investments.length ==
                            1 &&
                        widget.assetData == null) {
                      if (widget.isFromDashboard ?? false) {
                        Navigator.pop(context, true);
                      } else {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    InvestmentsMainPage()));
                      }
                    } else {
                      context.read<InvestmentsCubit>().getData();
                      Navigator.pop(context, state.data);
                    }
                  });
            }
          } else {
            _isAddingOnProgress = false;
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: appThemeColors!.bg,
            appBar: wedgeAppBar(
              context: context,
              title: widget.assetData == null
                  ? "${translate!.add} ${translate.investments}"
                  : "${translate!.edit} ${translate.investments}",
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
                      hintText: translate.investmentFundName,
                      inputType: TextInputType.text,
                      noRestriction: true,
                      textEditingController: _assetName,
                      validator: (value) => validator.validateName(
                          value?.trim(), translate.investmentFundName),
                    ),
                    CustomFormTextField(
                        hintText: translate.policyNumber + translate.optional,
                        allowNum: true,
                        inputType: TextInputType.text,
                        textEditingController: _policyNumber,
                        validator: (value) => null
                        // validator.validateName(value?.trim()),
                        ),
                    CountrySelector(
                      updateCountry: _country,
                      onChange: (value) {
                        _country = value;
                        globalKey.currentState?.changeCurrency(value);
                        globalKey2.currentState?.changeCurrency(value);
                      },
                    ),
                    CurrencyTextField(
                        currencyModel: _valueModel,
                        key: globalKey,
                        onChange: (_) {
                          _valueModel = _;
                        },
                        hintText: translate.initialValue,
                        errorMsg: "${translate.value} ${translate.isRequired}"),
                    CurrencyTextField(
                        currencyModel: _currentValueModel,
                        key: globalKey2,
                        onChange: (_) {
                          _currentValueModel = _;
                        },
                        hintText: translate.currentValue,
                        errorMsg:
                            "${translate.currentValue} ${translate.isRequired}"),
                    const SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavSingleButtonContainer(
                child: WedgeSaveButton(
                    onPressed: _isAddingOnProgress
                        ? null
                        : () {
                            if (_country?.isEmpty ?? false) {
                              showSnackBar(
                                  context: context,
                                  title: "Please select country");
                            } else {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isAddingOnProgress = true;
                                });
                                if (widget.assetData == null) {
                                  context.read<AddInvestmentCubit>().addAsset(
                                      _assetName.text.trim(),
                                      _country,
                                      _policyNumber.text.isEmpty
                                          ? ""
                                          : _policyNumber.text.trim(),
                                      _valueModel!.amount.toString(),
                                      _currentValueModel!.amount.toString(),
                                      _valueModel!.currency,
                                      _currentValueModel!.currency);
                                } else {
                                  context
                                      .read<AddInvestmentCubit>()
                                      .updateAsset(
                                          widget.assetData?.id,
                                          _assetName.text.trim(),
                                          _country,
                                          _policyNumber.text.isEmpty
                                              ? ""
                                              : _policyNumber.text.trim(),
                                          _valueModel!.amount.toString(),
                                          _currentValueModel!.amount.toString(),
                                          _valueModel!.currency,
                                          _currentValueModel!.currency);
                                }
                              }
                            }

                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                    title: widget.assetData == null
                        ? translate.save
                        : translate.update,
                    isLoaing: state is AddInvestmentLoading)));
      },
    );
  }
}

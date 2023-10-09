import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
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
import 'package:wedge/features/assets/bank_account/add_bank_manual/presentation/bloc/cubit/add_manual_bank_cubit.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';

import '../../../main_bank_account/presentation/pages/bank_account_main.dart';

class AddBankManualPage extends StatefulWidget {
  //if editing
  final ManualBankAccountsEntity? manualBankData;
  bool? fromHome;
  Widget? showSkip;
  bool? isFromDashboard;
  Function? onComplete;

  AddBankManualPage(
      {this.manualBankData,
      this.fromHome,
      this.onComplete,
      this.isFromDashboard,
      this.showSkip});

  @override
  _AddBankManualPageState createState() => _AddBankManualPageState();
}

class _AddBankManualPageState extends State<AddBankManualPage> {
  final _formKey = GlobalKey<FormState>();
  TextFieldValidator validator = TextFieldValidator();
  ValueEntity? _valueModel;

  final TextEditingController _bankName = TextEditingController();
  bool _isAddingOnProgress = false;
  String _country = "GBR";
  GlobalKey<CurrencyTextFieldState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.manualBankData != null) {
      _country = widget.manualBankData!.country;
      _bankName.text = widget.manualBankData!.name.toString();
      _valueModel = widget.manualBankData!.currentAmount;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bankName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
          context: context,
          title: widget.manualBankData == null
              ? "${translate!.add} ${translate.cashAccounts}"
              : "${translate!.edit} ${translate.cashAccounts}",
        ),
        body: BlocListener<AddManualBankCubit, AddManualBankState>(
          listener: (context, state) {
            if (state is AddManualBankInitial) {
              if (state.status) {
                _isAddingOnProgress = false;
                if (getIsUserInOnBoardingState()) {
                  final manualBankSuccessModel = ManualBankSuccessModel(
                    bankName: _bankName.text.trim(),
                    location: _country,
                    currentAmount: _valueModel!.amount.toString(),
                    currency: _valueModel!.currency,
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
                      title: widget.manualBankData == null
                          ? translate.assetaddedSuccesfullMessage
                          : translate.assetUpdatedSuccessfullyMessage,
                      // "In some cases it may take a while to establish a secure connection to the banking institution. So, if you have added your bank and don't see the information in the home screen, don't worry. We'll be working fast to fetch the details and show you the comprehensive financial data as soon as possible.",
                      info: "",
                      onClicked: () async {
                        if (widget.showSkip != null) {
                          Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      BankAccountMain(
                                        showSkip: widget.showSkip,
                                      )));
                        } else {
                          Navigator.pop(context);
                          if (RootApplicationAccess
                                      .assetsEntity?.bankAccounts.length ==
                                  1 &&
                              widget.manualBankData == null) {
                            if (widget.isFromDashboard ?? false) {
                              if (widget.onComplete != null) {
                                widget.onComplete!();
                              }
                              Navigator.pop(context, state.data);
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          BankAccountMain(
                                            showSkip: widget.showSkip,
                                          )));
                            }
                          } else {
                            Navigator.pop(context, state.data);
                          }
                        }
                      });
                }
              } else {
                _isAddingOnProgress = false;
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kpadding),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  CustomFormTextField(
                    hintText: translate.bankName,
                    noRestriction: true,
                    inputType: TextInputType.text,
                    textEditingController: _bankName,
                    validator: (value) => validator.validateName(
                        value?.trim(), translate.bankName),
                  ),
                  CountrySelector(
                    onChange: (_) {
                      _country = _;
                      globalKey.currentState?.changeCurrency(_);
                    },
                    updateCountry: _country,
                  ),
                  widget.fromHome != null
                      ? Container()
                      : CurrencyTextField(
                          key: globalKey,
                          hintText: translate.currentBalance,
                          errorMsg:
                              translate.currentBalance + translate.isRequired,
                          currencyModel: _valueModel,
                          onChange: (value) {
                            _valueModel = value;
                          },
                        ),
                  const SizedBox(
                    height: ktextBoxGap,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
            child: BlocConsumer<AddManualBankCubit, AddManualBankState>(
          listener: (context, state) {
            if (state is AddManualBankInitial) {
              if (state.message.toString().isNotEmpty) {
                showSnackBar(context: context, title: state.message);
              }
            }
          },
          builder: (context, state) {
            return WedgeSaveButton(
                onPressed: _isAddingOnProgress
                    ? null
                    : () {
                        if (_country.isEmpty) {
                          showSnackBar(
                              context: context, title: "Please select country");
                        } else {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isAddingOnProgress = true;
                            });
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            print(_valueModel!.currency);

                            if (widget.manualBankData == null) {
                              context.read<AddManualBankCubit>().addBank(
                                    _bankName.text.trim(),
                                    _country,
                                    _valueModel!.currency,
                                    _valueModel!.amount.toString(),
                                  );
                            } else {
                              context.read<AddManualBankCubit>().updateBank(
                                  _bankName.text.trim(),
                                  _country,
                                  _valueModel!.currency,
                                  _valueModel!.amount.toString(),
                                  widget.manualBankData?.id);
                            }
                          }
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                title: widget.manualBankData == null
                    ? translate.save
                    : translate.update,
                isLoaing: state is AddManualBankLoading);
          },
        )));
  }
}

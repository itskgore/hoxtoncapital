import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_currency_picker.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/core/widgets/dialog/country_selector_widget.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dropdown/wedge_custom_dropdown.dart';
import 'package:wedge/core/widgets/inputFields/currency_text_feild.dart';
import 'package:wedge/core/widgets/inputFields/generic_textField.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/presentation/cubit/add_manual_pension_cubit.dart';
import 'package:wedge/features/assets/pension/pension_main/presentation/pages/pension_main_page.dart';

class AddPensionManualPage extends StatefulWidget {
  final PensionsEntity? assetData;
  bool? isFromDashboard;

  AddPensionManualPage({super.key, this.assetData, this.isFromDashboard});

  @override
  _AddPensionManualPageState createState() => _AddPensionManualPageState();
}

class _AddPensionManualPageState extends State<AddPensionManualPage> {
  Country _selectedDialogCurrency =
      CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
  String _country = "GBR";

  AppLocalizations? translate;

  //Createing text Controllers
  final nameController = TextEditingController();
  final policyNameController = TextEditingController();
  final annulIncomeController = TextEditingController();
  final retirementAgeController = TextEditingController();
  final monthlyContriController = TextEditingController();
  final contriAmountController = TextEditingController();
  final averageRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //assign default country and currency
    _selectedDialogCurrency =
        CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
    isUpdating(widget.assetData != null);
  }

  isUpdating(bool isUpdating) {
    if (isUpdating) {
      PensionsEntity entity = widget.assetData!;
      bodyToSend['name'] = entity.name;
      bodyToSend['id'] = entity.id;
      bodyToSend['pensionType'] = entity.pensionType;
      bodyToSend['country'] = entity.country;
      bodyToSend['source'] = entity.source;
      bodyToSend['policyNumber'] = entity.policyNumber;
      bodyToSend['retirementAge'] = entity.retirementAge.toString();
      bodyToSend['averageAnnualGrowthRate'] =
          entity.averageAnnualGrowthRate.toString();
      bodyToSend['monthlyContributionAmount']['currency'] =
          entity.monthlyContributionAmount.currency;
      bodyToSend['monthlyContributionAmount']['amount'] =
          entity.monthlyContributionAmount.amount.toString();
      bodyToSend['annualIncomeAfterRetirement']['currency'] =
          entity.annualIncomeAfterRetirement.currency;
      bodyToSend['annualIncomeAfterRetirement']['amount'] =
          entity.annualIncomeAfterRetirement.amount.toString();
      bodyToSend['currentValue']['currency'] = entity.currentValue.currency;
      bodyToSend['currentValue']['amount'] =
          entity.currentValue.amount.toString();
      // bodyToSend['currentValue']['currency'] = entity.currentValue.currency;
      // bodyToSend['currentValue']['amount'] =
      //     entity.currentValue.amount.toString();

      // Initializing controllers
      nameController.text = entity.name;
      policyNameController.text = entity.policyNumber;
      retirementAgeController.text =
          entity.retirementAge == 0 ? "" : entity.retirementAge.toString();
      averageRateController.text = entity.averageAnnualGrowthRate.toInt() == 0
          ? ""
          : entity.averageAnnualGrowthRate.toString();
      monthlyContriController.text =
          entity.monthlyContributionAmount.amount.toInt() == 0
              ? ""
              : entity.monthlyContributionAmount.amount.toString();
      annulIncomeController.text =
          entity.annualIncomeAfterRetirement.amount.toInt() == 0
              ? ""
              : entity.annualIncomeAfterRetirement.amount.toString();
      contriAmountController.text = entity.currentValue.amount.toInt() == 0
          ? ""
          : entity.currentValue.amount.toString();
      // currentValueController.text = entity.currentValue.amount.toString();

      // Chanding currency and country value
      if (entity.pensionType == "Defined Contribution") {
        _selectedDialogCurrency = CountryPickerUtils.getCountryByCurrencyCode(
            bodyToSend['monthlyContributionAmount']['currency']);
        _country = entity.country;
      } else {
        _selectedDialogCurrency = CountryPickerUtils.getCountryByCurrencyCode(
            bodyToSend['annualIncomeAfterRetirement']['currency']);
        _country = entity.country;
      }

      // Chaning the state of bloc
      BlocProvider.of<AddManualPensionCubit>(context, listen: false).emit(
          AddManualPensionInitial(
              changeType: false,
              pensionType: bodyToSend['pensionType'],
              isLoading: false));
    }
  }

  // body of the request
  Map<String, dynamic> bodyToSend = {
    "id": "",
    "name": "",
    "pensionType": "",
    "country": "",
    "source": "Hoxton",
    "policyNumber": "",
    "monthlyContributionAmount": {"amount": "", "currency": ""},
    "annualIncomeAfterRetirement": {"amount": "", "currency": ""},
    "currentValue": {"amount": "", "currency": ""},
    // "currentValue": {"amount": "", "currency": ""},
    "retirementAge": "",
    "averageAnnualGrowthRate": ""
  };

  Future<void> saveData(String pensionType) async {
    if (pensionType == "Defined Benefit") {
      validatedAndSubmit(_formKeyBenifit, bodyToSend);
    } else {
      validatedAndSubmit(_formKeyContribution, bodyToSend);
    }
  }

  void validatedAndSubmit(GlobalKey<FormState> key, Map<String, dynamic> body) {
    if (_country.isEmpty) {
      showSnackBar(context: context, title: "Please select country");
    } else {
      if (key.currentState!.validate()) {
        key.currentState!.save();
        body['country'] = _country;
        final bloc =
            BlocProvider.of<AddManualPensionCubit>(context, listen: false);
        if (widget.assetData != null) {
          bloc.updatePensionData(body);
        } else {
          // log(body);
          bloc.savePensionData(body);
        }
      }
    }
  }

  List<String> items = ['Defined Benefit', 'Defined Contribution'];

  @override
  void dispose() {
    contriAmountController.dispose();
    nameController.dispose();
    policyNameController.dispose();
    retirementAgeController.dispose();
    averageRateController.dispose();
    monthlyContriController.dispose();
    averageRateController.dispose();
    annulIncomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: widget.assetData == null
                ? "${translate!.add} ${translate!.pensions}"
                : "Edit Pension"),
        body: BlocConsumer<AddManualPensionCubit, AddManualPensionState>(
          listener: (context, state) {
            if (state is AddManualPensionLoaded) {
              if (getIsUserInOnBoardingState()) {
                final manualBankSuccessModel = ManualBankSuccessModel(
                  bankName: bodyToSend['name'],
                  location: bodyToSend['country'],
                  currentAmount: bodyToSend['currentValue']['amount'],
                  currency: bodyToSend['currentValue']['currency'],
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
                        ? translate!.pensionSuccessMessage
                        : "Your pension details have been updated successfully.",
                    info: "",
                    onClicked: () {
                      Navigator.pop(context);
                      if (RootApplicationAccess.assetsEntity?.pensions.length ==
                              1 &&
                          widget.assetData == null) {
                        if (widget.isFromDashboard ?? false) {
                          Navigator.pop(context, state.data);
                        } else {
                          Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      PensionMainPage()));
                        }
                      } else {
                        Navigator.pop(context, state.data);
                      }
                    });
              }
            }
            if (state is AddManualPensionError) {
              showSnackBar(context: context, title: state.errorMsg);
            }
          },
          builder: (context, state) {
            if (state is AddManualPensionInitial) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          height: 53.0,
                          width: double.infinity,
                          child: WedgeCustomDropDown(
                            items: items,
                            onChanged: (_) {
                              BlocProvider.of<AddManualPensionCubit>(context)
                                  .changePensionType(_);
                            },
                            value: state.pensionType,
                          )),
                      const SizedBox(
                        height: ktextBoxGap,
                      ),
                      if (state.pensionType == "Defined Benefit")
                        benifit()
                      else
                        contribution()
                    ],
                  ),
                ),
              );
            } else if (state is AddManualPensionLoading) {
              return Container();
            } else {
              return Container();
            }
          },
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
            child: BlocBuilder<AddManualPensionCubit, AddManualPensionState>(
          builder: (context, state) {
            return WedgeSaveButton(
                onPressed: state is AddManualPensionInitial
                    ? state.isLoading
                        ? null
                        : () {
                            final state =
                                BlocProvider.of<AddManualPensionCubit>(context)
                                    .state;
                            if (state is AddManualPensionInitial) {
                              bodyToSend['pensionType'] = state.pensionType;
                              saveData(state.pensionType);
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                    : () {
                        final state =
                            BlocProvider.of<AddManualPensionCubit>(context)
                                .state;
                        if (state is AddManualPensionInitial) {
                          bodyToSend['pensionType'] = state.pensionType;
                          saveData(state.pensionType);
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                title: widget.assetData == null
                    ? translate!.save
                    : translate!.update,
                isLoaing:
                    state is AddManualPensionInitial ? state.isLoading : false);
          },
        )));
  }

  Text buildText() {
    return Text(
      widget.assetData == null ? translate!.save : translate!.update,
      style: const TextStyle(fontSize: kfontMedium, color: Colors.white),
    );
  }

  final GlobalKey<FormState> _formKeyContribution = GlobalKey<FormState>();

  Widget contribution() {
    return Form(
      key: _formKeyContribution,
      child: Column(
        children: [
          GenericTextField(
            placeholder: translate!.pensionSchemeName,
            onFieldSubmitted: (_) {},
            onSaved: (value) {
              bodyToSend['name'] = value;
            },
            textController: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return "${translate!.pensionSchemeName} ${translate!.isRequired}";
              }
            },
            onChanged: (_) {},
          ),
          const SizedBox(
            height: ktextBoxGap,
          ),
          GenericTextField(
            textController: policyNameController,
            placeholder: translate!.policyNumber + translate!.optional,
            type: TextInputType.number,
            onFieldSubmitted: (_) {},
            onSaved: (value) {
              bodyToSend['policyNumber'] = value ?? "";
            },
            onChanged: (_) {},
          ),
          const SizedBox(
            height: 12,
          ),
          CountrySelector(
            onChange: (_) {
              _country = _;
            },
            updateCountry: _country,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            //4
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              DecimalTextInputFormatter(decimalRange: 2),
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
            ],
            controller: monthlyContriController,
            validator: (value) {
              if (value!.isEmpty) {
                return "${translate!.monthlyContribution} ${translate!.isRequired}";
              }
            },
            onSaved: (value) {
              bodyToSend['monthlyContributionAmount']['amount'] = value;
              bodyToSend['monthlyContributionAmount']['currency'] =
                  _selectedDialogCurrency.currencyCode.toString();
            },
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12),
                filled: true,
                fillColor: Colors.white,
                border: ktextFeildOutlineInputBorder,
                enabledBorder: ktextFeildOutlineInputBorder,
                focusedBorder: ktextFeildOutlineInputBorderFocused,
                labelStyle: labelStyle,
                labelText: translate!.monthlyContribution,
                suffixStyle: const TextStyle(color: Colors.black),
                suffix: GestureDetector(
                    onTap: () async {
                      WedgeCurrencyPicker(
                          context: context,
                          countryPicked: (Country country) {
                            setState(() {
                              _selectedDialogCurrency = country;
                            });
                          });
                    },
                    child: Container(
                      width: 60,
                      child: Row(
                        children: [
                          Text(
                            _selectedDialogCurrency.currencyCode.toString(),
                            style: const TextStyle(color: kfontColorDark),
                          ),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ))),
          ),
          const SizedBox(
            height: ktextBoxGap,
          ),
          TextFormField(
            //4
            controller: contriAmountController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return "${translate!.currentTotalValue} ${translate!.isRequired}";
              }
            },
            inputFormatters: <TextInputFormatter>[
              DecimalTextInputFormatter(decimalRange: 2),
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
            ],
            onSaved: (value) {
              bodyToSend['currentValue']['amount'] = value;
              bodyToSend['currentValue']['currency'] =
                  _selectedDialogCurrency.currencyCode.toString();
            },

            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12),
                filled: true,
                fillColor: Colors.white,
                border: ktextFeildOutlineInputBorder,
                enabledBorder: ktextFeildOutlineInputBorder,
                focusedBorder: ktextFeildOutlineInputBorderFocused,
                labelStyle: labelStyle,
                labelText: translate!.currentTotalValue,
                suffixStyle: const TextStyle(color: Colors.black),
                suffix: GestureDetector(
                    onTap: () async {
                      WedgeCurrencyPicker(
                          context: context,
                          countryPicked: (Country country) {
                            setState(() {
                              _selectedDialogCurrency = country;
                            });
                          });
                    },
                    child: Container(
                      width: 60,
                      child: Row(
                        children: [
                          Text(
                            _selectedDialogCurrency.currencyCode.toString(),
                            style: const TextStyle(color: kfontColorDark),
                          ),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ))),
          ),
          const SizedBox(
            height: ktextBoxGap,
          ),
          TextFormField(
            controller: averageRateController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return "${translate!.averageAnnualGrowthRate} ${translate!.isRequired}";
              }
            },
            inputFormatters: <TextInputFormatter>[
              DecimalTextInputFormatter(decimalRange: 2),
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
            ],
            onSaved: (value) {
              bodyToSend['averageAnnualGrowthRate'] = value;
            },
            decoration: InputDecoration(
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 17.0, horizontal: 12),
              fillColor: Colors.white,
              border: ktextFeildOutlineInputBorder,
              enabledBorder: ktextFeildOutlineInputBorder,
              focusedBorder: ktextFeildOutlineInputBorderFocused,
              labelStyle: labelStyle,
              labelText: translate!.averageAnnualGrowthRate,
              suffixStyle: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  final GlobalKey<FormState> _formKeyBenifit = GlobalKey<FormState>();

  Widget benifit() {
    return Form(
      key: _formKeyBenifit,
      child: Column(
        children: [
          GenericTextField(
            textController: nameController,
            placeholder: translate!.pensionSchemeName,
            onFieldSubmitted: (_) {},
            onSaved: (value) {
              bodyToSend['name'] = value!.trimLeft().trimRight();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return translate!.pensionSchemeName + translate!.isRequired;
              }
            },
            onChanged: (_) {},
          ),
          const SizedBox(
            height: ktextBoxGap,
          ),
          GenericTextField(
            placeholder: translate!.policyNumber + translate!.optional,
            type: TextInputType.number,
            textController: policyNameController,
            onSaved: (value) {
              bodyToSend['policyNumber'] = value ?? "";
            },
            onChanged: (_) {},
          ),
          const SizedBox(
            height: 12,
          ),
          CountrySelector(
            onChange: (_) {
              _country = _;
            },
            updateCountry: _country,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            //3
            keyboardType: TextInputType.number,
            controller: annulIncomeController,
            validator: (value) {
              if (value!.isEmpty) {
                return translate!.annualIncomeinRetirement +
                    translate!.isRequired;
              }
            },
            inputFormatters: <TextInputFormatter>[
              DecimalTextInputFormatter(decimalRange: 2),
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
            ],
            onSaved: (val) {
              bodyToSend['annualIncomeAfterRetirement']['amount'] = val;
              bodyToSend['annualIncomeAfterRetirement']['currency'] =
                  _selectedDialogCurrency.currencyCode.toString();
            },
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12),
                filled: true,
                fillColor: Colors.white,
                border: ktextFeildOutlineInputBorder,
                enabledBorder: ktextFeildOutlineInputBorder,
                focusedBorder: ktextFeildOutlineInputBorderFocused,
                labelStyle: labelStyle,
                labelText: translate!.annualIncomeinRetirement,
                suffixStyle: const TextStyle(color: Colors.black),
                suffix: GestureDetector(
                    onTap: () async {
                      WedgeCurrencyPicker(
                          context: context,
                          countryPicked: (Country country) {
                            setState(() {
                              _selectedDialogCurrency = country;
                            });
                          });
                    },
                    child: Container(
                      width: 60,
                      child: Row(
                        children: [
                          Text(
                            _selectedDialogCurrency.currencyCode.toString(),
                            style: const TextStyle(color: kfontColorDark),
                          ),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ))),
          ),
          const SizedBox(
            height: ktextBoxGap,
          ),
          GenericTextField(
            textController: retirementAgeController,
            placeholder: translate!.retirementAge,
            type: TextInputType.number,
            onFieldSubmitted: (_) {},
            onSaved: (value) {
              bodyToSend['retirementAge'] = value;
            },
            validator: (value) {
              if (int.parse(value!) < 18 || int.parse(value) > 120) {
                return translate!.retirementAgeValidation;
              } else if (value.isEmpty) {
                return translate!.retirementAge + translate!.isRequired;
              }
            },
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}

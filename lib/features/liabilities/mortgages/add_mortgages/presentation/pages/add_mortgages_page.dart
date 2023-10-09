import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/core/widgets/dialog/country_selector_widget.dart';
import 'package:wedge/core/widgets/dialog/custom_date_picker.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/core/widgets/inputFields/currency_text_feild.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';
import 'package:wedge/features/assets/properties/add_properties/presentation/pages/add_property_page.dart';
import 'package:wedge/features/assets/properties/properties_main/presentation/bloc/cubit/properties_cubit.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/domain/params/mortgages_params.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/presentation/cubit/add_mortgages_cubit.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/presentation/widgets/property_widget.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/presentation/pages/mortgage_main_page.dart';
import 'package:wedge/features/liabilities/mortgages/properties/presentation/pages/mortgages_page.dart';

import '../../../mortgages_main/presentation/cubit/mortage_main_cubit.dart';

class AddMortgagesPage extends StatefulWidget {
  AddMortgagesPage(
      {Key? key,
      required this.mortgages,
      this.mortgagesData,
      this.hideAddMore,
      this.isFromLinked})
      : super(key: key);
  List<MortgagesEntity> mortgages;
  bool? hideAddMore = false;
  bool? isFromLinked = false;
  MortgagesEntity? mortgagesData;

  @override
  _AddMortgagesPageState createState() => _AddMortgagesPageState();
}

class _AddMortgagesPageState extends State<AddMortgagesPage> {
  bool _generateRentalIncome = false;
  List<dynamic> _properties = [];
  AppLocalizations? translate;

  @override
  void initState() {
    super.initState();
    editMortgages();
  }

  // Controllers
  final _mortgagesFormKey = GlobalKey<FormState>();
  String? _country;
  TextFieldValidator validator = TextFieldValidator();
  final TextEditingController _providerName = TextEditingController();
  final TextEditingController _interestRate = TextEditingController();
  final TextEditingController _termRemining = TextEditingController();
  GlobalKey<CurrencyTextFieldState> globalKey1 = GlobalKey();
  GlobalKey<CurrencyTextFieldState> globalKey2 = GlobalKey();

  ValueEntity? _outStandingAmount;
  ValueEntity? _monthlyAmount;

  Future<void> editProperty(PropertyEntity data, int index) async {
    var _result = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => AddPropertyPage(
                  isFromLink: true,
                  data: data,
                )));
    if (_result != null) {
      context.read<PropertiesCubit>().getData();
      setState(() {
        _properties[index] = _result;
      });
    }
  }

  Future<void> unlinkProperty(PropertyEntity data, int index) async {
    locator.get<WedgeDialog>().confirm(
        context,
        WedgeConfirmDialog(
            title: translate!.unlinkTheProperty,
            subtitle: translate!.unlinkTheProperty,
            acceptedPress: () {
              showSnackBar(context: context, title: translate!.loading);

              if (widget.mortgagesData != null) {
                // API call
                context.read<PropertiesCubit>().unlinkProperty(UnlinkParams(
                    loanId: widget.mortgagesData!.id, vehicleId: "${data.id}"));
              } else {
                // local remove
                setState(() {
                  _properties.remove(_properties[index]);
                });
              }
              Navigator.pop(context);
            },
            deniedPress: () {
              Navigator.pop(context);
            },
            acceptText: translate!.yesUnlink,
            deniedText: translate!.cancel));
  }

  //Unlink the property
  //This action will unlink the property from the current mortgage.
  //Interest rate should be less than 100%
  //Your mortgage information have been added successfully
  //Mortgage Provider Name
  //Add a property

  editMortgages() {
    if (widget.mortgagesData != null) {
      _country = widget.mortgagesData!.country;
      _providerName.text = widget.mortgagesData!.provider;
      _interestRate.text = widget.mortgagesData!.interestRate.toString();
      _termRemining.text = widget.mortgagesData!.maturityDate.toString();
      _outStandingAmount = widget.mortgagesData!.outstandingAmount;
      _monthlyAmount = widget.mortgagesData!.monthlyPayment;
      RootApplicationAccess.assetsEntity?.properties.forEach((element) {
        if (element.mortgages
            .where((e) => e.id == widget.mortgagesData!.id)
            .toList()
            .isNotEmpty) {
          _properties.add(element);
        }
      });
    }
  }

  Future<void> submitData() async {
    if (_country?.isEmpty ?? false) {
      showSnackBar(context: context, title: "Please select country");
    } else {
      if (_mortgagesFormKey.currentState!.validate() &&
          double.parse(_interestRate.text) <= 100.00) {
        List<Map<String, dynamic>> mortgages = [];
        if (_properties.isNotEmpty) {
          _properties.forEach((element) {
            mortgages.add({"id": element.id.toString()});
          });
        }
        if (widget.mortgagesData != null) {
          // no porperties involved
          context.read<AddMortgagesCubit>().updateMortgages(
              context: context,
              params: AddMortgagesParams(
                hasLoan: _properties.isNotEmpty,
                country: _country ?? "GBR",
                id: widget.mortgagesData!.id,
                provider: _providerName.text,
                interestRate: _interestRate.text,
                properties: _properties.isEmpty ? [] : mortgages,
                monthlyPayment: ValueEntity(
                    amount: _monthlyAmount!.amount,
                    currency: _monthlyAmount!.currency),
                outstandingAmount: ValueEntity(
                    amount: _outStandingAmount!.amount,
                    currency: _outStandingAmount!.currency),
                termRemaining: _termRemining.text,
              ));
        } else {
          // add data
          context.read<AddMortgagesCubit>().addMortgages(
              context: context,
              params: AddMortgagesParams(
                  hasLoan: _properties.isNotEmpty,
                  country: _country ?? "GBR",
                  provider: _providerName.text,
                  interestRate: _interestRate.text,
                  monthlyPayment: ValueEntity(
                      amount: _monthlyAmount!.amount,
                      currency: _monthlyAmount!.currency),
                  outstandingAmount: ValueEntity(
                      amount: _outStandingAmount!.amount,
                      currency: _outStandingAmount!.currency),
                  termRemaining: _termRemining.text,
                  properties: _properties.isEmpty ? [] : mortgages));
        }
      } else {
        if (double.parse(_interestRate.text) >= 100.00) {
          showSnackBar(
              context: context,
              title: translate!.interestRateShouldbeLessThan100);
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _interestRate.dispose();
    _providerName.dispose();
    _termRemining.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: widget.mortgagesData == null
                ? "${translate!.add} ${translate!.mortgage}"
                : "${translate!.edit} ${translate!.mortgage}"),
        body: BlocConsumer<AddMortgagesCubit, AddMortgagesState>(
          listener: (context, state) {
            if (state is AddMortgagesLoaded) {
              // return to summary
              if (getIsUserInOnBoardingState()) {
                final manualBankSuccessModel = ManualBankSuccessModel(
                  bankName: _providerName.text,
                  location: _country ?? "GBR",
                  currentAmount: _outStandingAmount!.amount.toString(),
                  currency: _outStandingAmount!.currency,
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
                    title: widget.mortgagesData == null
                        ? translate!.yourMortgageAddedSuccessfully
                        : translate!.yourMortgageUpdatedSuccessfully,
                    info: "",
                    onClicked: () {
                      Navigator.pop(context);
                      if (RootApplicationAccess
                                  .liabilitiesEntity?.mortgages.length ==
                              1 &&
                          widget.mortgagesData == null) {
                        if (widget.hideAddMore ?? false) {
                          Navigator.pop(context, state.data);
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const MortgageMainPage()));
                        }
                      } else {
                        context.read<MortageMainCubit>().getMortgages(context);
                        Navigator.pop(context, state.data);
                      }
                    });
              }
            } else if (state is AddMortgagesError) {
              // show error snack
              showSnackBar(context: context, title: state.errorMsg);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _mortgagesFormKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CustomFormTextField(
                      hintText: translate!.mortgageProviderName,
                      inputType: TextInputType.text,
                      noRestriction: true,
                      textEditingController: _providerName,
                      validator: (value) => validator.validateName(
                          value?.trim(), translate!.mortgageProviderName),
                    ),
                    CountrySelector(
                      updateCountry: _country,
                      onChange: (value) {
                        setState(() {
                          _country = value;
                          globalKey1.currentState?.changeCurrency(value);
                          globalKey2.currentState?.changeCurrency(value);
                        });
                      },
                    ),
                    CurrencyTextField(
                      key: globalKey1,
                      hintText: translate!.outStanding,
                      errorMsg:
                          "${translate!.outStanding} ${translate!.isRequired}",
                      currencyModel: _outStandingAmount,
                      onChange: (value) {
                        _outStandingAmount = value;
                      },
                    ),
                    CustomFormTextField(
                      hintText: translate!.interestRate,
                      inputType:
                          const TextInputType.numberWithOptions(decimal: true),
                      isDemicalAllowed: true,
                      allowNum: true,
                      textEditingController: _interestRate,
                      validator: (value) => validator.validateAmountWithZero(
                          value?.trim(), translate!.interestRate),
                    ),
                    // CustomFormTextField(
                    //   hintText: "Maturity date",
                    //   isDemicalAllowed: false,
                    //   inputType: TextInputType.number,
                    //   textEditingController: _termRemining,
                    //   validator: (value) =>
                    //       validator.validateAmount(value?.trim()),
                    // ),
                    DatePickerTextField(
                        hintText: translate!.maturityDate,
                        errorMsg:
                            "${translate!.maturityDate} ${translate!.isRequired}",
                        createAt: widget.mortgagesData != null
                            ? widget.mortgagesData!.createdAt
                            : DateTime.now().toIso8601String(),
                        date: _termRemining),
                    CurrencyTextField(
                      key: globalKey2,
                      hintText: translate!.monthlyPayement,
                      errorMsg:
                          "${translate!.monthlyPayement} ${translate!.isRequired}",
                      currencyModel: _monthlyAmount,
                      onChange: (value) {
                        _monthlyAmount = value;
                      },
                    ),
                    const SizedBox(
                      height: ktextBoxGap,
                    ),
                    _properties.isNotEmpty
                        ? widget.isFromLinked ?? false
                            ? Container()
                            : BlocConsumer<PropertiesCubit, PropertiesState>(
                                listener: (context, state) {
                                  if (state is PropertiesError) {
                                    if (state.id != null) {
                                      setState(() {
                                        _properties.removeWhere((element) =>
                                            element.id == state.id);
                                      });
                                    }
                                  } else if (state is PropertiesUnlink) {
                                    setState(() {
                                      _properties.removeWhere(
                                          (element) => element.id == state.id);
                                    });
                                  }
                                },
                                builder: (context, state) {
                                  return PropertyWidget(
                                    mortgages: widget.mortgages,
                                    properties: _properties,
                                    onDeletePresseds: (index) {
                                      unlinkProperty(_properties[index], index);
                                    },
                                    onEditPresseds: (index) {
                                      editProperty(_properties[index], index);
                                    },
                                    isMortgages: true,
                                  );
                                },
                              )
                        : Container(),
                    widget.hideAddMore ?? false
                        ? Container()
                        : widget.isFromLinked ?? false
                            ? Container()
                            : AddNewButton(
                                text: translate!.addProperty,
                                onTap: () async {
                                  late List<PropertyEntity> properties;
                                  late PropertyEntity propertiesData;
                                  if (await isConnectedToInternetData()) {
                                    if (RootApplicationAccess
                                            .assetsEntity?.properties.isEmpty ??
                                        false) {
                                      propertiesData = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddPropertyPage(
                                                    hideAddMore: true,
                                                  )
                                              // AddBankAccountPage()
                                              ));
                                      if (propertiesData != null) {
                                        setState(() {
                                          _properties.addAll([propertiesData]);
                                        });
                                      }
                                    } else {
                                      properties = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  MortgageAddProperties(
                                                    propertiesData: _properties,
                                                  )));
                                      if (properties != null) {
                                        setState(() {
                                          _properties.addAll(properties);
                                        });
                                      }
                                    }
                                  } else {
                                    showSnackBar(
                                        context: context,
                                        title:
                                            "You are disconnected from the internet.");
                                  }
                                },
                              )
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
          child: BlocBuilder<AddMortgagesCubit, AddMortgagesState>(
            builder: (context, state) {
              return WedgeSaveButton(
                  onPressed: state is AddMortgagesLoading
                      ? null
                      : () {
                          submitData();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                  title: widget.mortgagesData == null
                      ? translate!.save
                      : translate!.update,
                  isLoaing: state is AddMortgagesLoading);
            },
          ),
        ));
  }
}

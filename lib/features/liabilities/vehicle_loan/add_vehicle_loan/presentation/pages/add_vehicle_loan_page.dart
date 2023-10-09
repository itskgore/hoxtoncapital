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
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';
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
import 'package:wedge/features/assets/vehicle/add_vehicle/presentation/pages/add_vehicle_manual_page.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/presentation/bloc/cubit/vehicles_cubit.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/params/add_vehicle_loans_params.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/presentation/pages/cubit/add_vehicle_loans_cubit.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/presentation/widgets/property_widget.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/presentation/pages/vehicle_loan_main_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicles/presentation/pages/vehicle_page.dart';

class AddVehicleLoanPage extends StatefulWidget {
  final VehicleLoansEntity? vehicleLoansEntity;
  bool? hideShowMore = false;
  bool? isFromLink = false;

  AddVehicleLoanPage({
    Key? key,
    this.vehicleLoansEntity,
    this.hideShowMore,
    this.isFromLink,
  }) : super(key: key);

  @override
  _AddVehicleLoanPageState createState() => _AddVehicleLoanPageState();
}

class _AddVehicleLoanPageState extends State<AddVehicleLoanPage> {
  AppLocalizations? translate;

  //define country and currency pickers
  Country _selectedDialogCurrency =
      CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);

  bool _generateRentalIncome = false;
  List<VehicleEntity> _properties = [];

  @override
  void initState() {
    super.initState();

    //assign default country and currency
    _selectedDialogCurrency =
        CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
    _selectedDialogCountry =
        CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);
    editData();
  }

  // controllers
  final _vehicleLoanFormKey = GlobalKey<FormState>();
  String? _country;
  TextFieldValidator validator = TextFieldValidator();
  final TextEditingController _providerName = TextEditingController();
  final TextEditingController _interestRate = TextEditingController();
  final TextEditingController _termRemining = TextEditingController();
  ValueEntity? _outStandingAmount;
  ValueEntity? _monthlyAmount;
  GlobalKey<CurrencyTextFieldState> globalKey = GlobalKey();
  GlobalKey<CurrencyTextFieldState> globalKey2 = GlobalKey();

  // initiale the controllers
  void editData() {
    if (widget.vehicleLoansEntity != null) {
      _outStandingAmount = widget.vehicleLoansEntity!.outstandingAmount;
      _monthlyAmount = widget.vehicleLoansEntity!.monthlyPayment;
      _country = widget.vehicleLoansEntity!.country;
      _providerName.text = widget.vehicleLoansEntity!.provider;
      _interestRate.text = widget.vehicleLoansEntity!.interestRate.toString();
      _termRemining.text = widget.vehicleLoansEntity!.maturityDate.toString();
      // _properties = widget.vehicleLoansEntity!.vehicles;
      RootApplicationAccess.assetsEntity?.vehicles.forEach((element) {
        if (element.vehicleLoans
            .where((e) => e.id == widget.vehicleLoansEntity!.id)
            .toList()
            .isNotEmpty) {
          _properties.clear();
          _properties.add(element);
        }
      });
    }
  }

  void submitData() {
    if (_country?.isEmpty ?? false) {
      showSnackBar(context: context, title: "Please select country");
    } else {
      if (_vehicleLoanFormKey.currentState!.validate() &&
          double.parse(_interestRate.text) <= 100.00) {
        if (widget.vehicleLoansEntity != null) {
          // edit data [No unlinking is done here]
          BlocProvider.of<AddVehicleLoansCubit>(context)
              .updateVehicleLoans(AddVehicleLoansParams(
            id: widget.vehicleLoansEntity!.id,
            country: _country ?? widget.vehicleLoansEntity!.country,
            provider: _providerName.text,
            hasLoan: widget.vehicleLoansEntity!.hasLoan,
            interestRate: _interestRate.text,
            monthlyPayment: ValueEntity(
                amount: _monthlyAmount!.amount,
                currency: _monthlyAmount!.currency),
            outstandingAmount: ValueEntity(
                amount: _outStandingAmount!.amount,
                currency: _outStandingAmount!.currency),
            termRemaining: _termRemining.text,
            vehicles: _properties.isEmpty
                ? []
                : [
                    {"id": _properties[0].id}
                  ],
          ));
        } else {
          // add data
          BlocProvider.of<AddVehicleLoansCubit>(context)
              .addVehicleLoans(AddVehicleLoansParams(
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
            vehicles: _properties.isEmpty
                ? []
                : [
                    {"id": _properties[0].id}
                  ],
          ));
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

  void unLinkVehicle(VehicleEntity data, int index) {
    if (widget.vehicleLoansEntity != null) {
      // api call

      //Unlink the vehicle?
      //This action will unlink the vehicle from the current vehicle loan
      //Loan provider name
      //Your vehicle loan information have been added successfully.
      locator.get<WedgeDialog>().confirm(
          context,
          WedgeConfirmDialog(
              title: translate!.unlinktheVehicle,
              subtitle: translate!.unlinkVehicleMessage,
              acceptedPress: () {
                showSnackBar(context: context, title: translate!.loading);

                context.read<VehiclesCubit>().unLinkVehicle(UnlinkParams(
                    loanId: widget.vehicleLoansEntity!.id, vehicleId: data.id));
                Navigator.pop(context);
              },
              deniedPress: () {
                Navigator.pop(context);
              },
              acceptText: translate!.yesUnlink,
              deniedText: translate!.cancel));
    } else {
      // remove from properteries
      locator.get<WedgeDialog>().confirm(
          context,
          WedgeConfirmDialog(
              title: translate!.unlinktheVehicle,
              subtitle: translate!.unlinkVehicleMessage,
              acceptedPress: () {
                setState(() {
                  _properties.remove(data);
                  Navigator.pop(context);
                });
              },
              deniedPress: () {
                Navigator.pop(context);
              },
              acceptText: translate!.yesUnlink,
              deniedText: translate!.cancel));
    }
  }

  void editVehicle(VehicleEntity data) async {
    var _result = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => AddVehicleManualPage(
                  assetData: data,
                  hideShowMore: true,
                )));
    if (_result != null) {
      context.read<VehiclesCubit>().getData();
      setState(() {
        _properties.clear();
        _properties.add(_result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
          context: context,
          title: widget.vehicleLoansEntity == null
              ? "${translate!.add} ${translate!.vehicleLoans}"
              : "${translate!.edit} ${translate!.vehicleLoans}",
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _vehicleLoanFormKey,
            child: ListView(
              children: [
                CustomFormTextField(
                  hintText: translate!.loanProviderName,
                  inputType: TextInputType.text,
                  noRestriction: true,
                  textEditingController: _providerName,
                  validator: (value) => validator.validateName(
                      value?.trim(), translate!.loanProviderName),
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
                  key: globalKey,
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
                  isDemicalAllowed: true,
                  allowNum: true,
                  inputType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textEditingController: _interestRate,
                  validator: (value) => validator.validateAmount(
                      value?.trim(), translate!.interestRate),
                ),
                DatePickerTextField(
                    // onChange: (_) {},
                    hintText: translate!.maturityDate,
                    createAt: widget.vehicleLoansEntity != null
                        ? widget.vehicleLoansEntity!.createdAt
                        : DateTime.now().toIso8601String(),
                    errorMsg:
                        "${translate!.maturityDate} ${translate!.isRequired}",
                    date: _termRemining),
                // CustomFormTextField(
                //   hintText: "Maturity date",
                //   inputType: TextInputType.number,
                //   isDemicalAllowed: false,
                //   textEditingController: _termRemining,
                //   validator: (value) => validator.validateAmount(value?.trim()),
                // ),
                CurrencyTextField(
                  key: globalKey2,
                  hintText: translate!.monthlyPayment,
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
                _properties.length != 0
                    ? widget.isFromLink ?? false
                        ? Container()
                        : BlocConsumer<VehiclesCubit, VehiclesState>(
                            listener: (context, state) {
                              if (state is VehiclesError) {
                                if (state.id != null) {
                                  setState(() {
                                    _properties.clear();
                                  });
                                }
                              } else if (state is VehiclesUnlink) {
                                setState(() {
                                  _properties.clear();
                                });
                              }
                            },
                            builder: (context, state) {
                              return VehicleWidget(
                                  properties: _properties,
                                  onDeletePresseds: (index) {
                                    unLinkVehicle(_properties[index], index);
                                  },
                                  onEditPresseds: (index) async {
                                    editVehicle(_properties[index]);
                                  });
                            },
                          )
                    : Container(),
                _properties.length <= 0
                    ? widget.hideShowMore ?? false
                        ? Container()
                        : AddNewButton(
                            text: "${translate!.add} ${translate!.vehicle}",
                            onTap: () async {
                              late VehicleEntity data;
                              if (RootApplicationAccess
                                      .assetsEntity?.vehicles.isEmpty ??
                                  false) {
                                data = await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            AddVehicleManualPage(
                                              hideShowMore: true,
                                            )
                                        // AddBankAccountPage()
                                        ));
                              } else {
                                if (RootApplicationAccess.assetsEntity!.vehicles
                                    .where((element) => !element.hasLoan)
                                    .toList()
                                    .isEmpty) {
                                  data = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              AddVehicleManualPage(
                                                hideShowMore: true,
                                              )
                                          // AddBankAccountPage()
                                          ));
                                } else {
                                  data = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              const VehiclePage()
                                          // AddBankAccountPage()
                                          ));
                                }
                              }
                              if (data != null) {
                                setState(() {
                                  _properties.clear();
                                  _properties.add(data);
                                });
                              }
                            },
                          )
                    : Container()
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
            child: BlocConsumer<AddVehicleLoansCubit, AddVehicleLoansState>(
          listener: (context, state) {
            if (state is AddVehicleLoansError) {
              showSnackBar(context: context, title: state.errorMsg);
            } else if (state is AddVehicleLoansLoaded) {
              if (getIsUserInOnBoardingState()) {
                final manualBankSuccessModel = ManualBankSuccessModel(
                  bankName: _providerName.text,
                  location: _country ?? "GBR",
                  currentAmount: _outStandingAmount!.amount.toString(),
                  currency: _outStandingAmount!.currency.toString(),
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
                    title: widget.vehicleLoansEntity == null
                        ? translate!.yourVehicleDetailsaddedSuccessfully
                        : translate!.yourVehicleDetailsUpdatedSuccessfully,
                    info: "",
                    onClicked: () {
                      _properties.clear();
                      Navigator.pop(context);
                      if (RootApplicationAccess
                                  .liabilitiesEntity?.vehicleLoans.length ==
                              1 &&
                          widget.vehicleLoansEntity == null) {
                        if (widget.hideShowMore ?? false) {
                          Navigator.pop(context, state.data);
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      VehicleLoanMainPage()));
                        }
                      } else {
                        Navigator.pop(context, state.data);
                      }
                    });
              }
            }
          },
          builder: (context, state) {
            return WedgeSaveButton(
                onPressed: state is AddVehicleLoansLoading
                    ? null
                    : () {
                        submitData();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                title: widget.vehicleLoansEntity == null
                    ? translate!.save
                    : translate!.update,
                isLoaing: state is AddVehicleLoansLoading);
          },
        )));
  }
}

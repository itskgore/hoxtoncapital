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
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/core/widgets/dialog/country_selector_widget.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/inputFields/currency_text_feild.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/presentation/bloc/cubit/add_vehicle_cubit.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/presentation/pages/vehicle_loans_list.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/presentation/pages/vehicles_main_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/presentation/pages/add_vehicle_loan_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/presentation/widgets/vehicle_loans_list.dart';

class AddVehicleManualPage extends StatefulWidget {
  // AddCustomAssets({Key key}) : super(key: key);
  bool? hideShowMore = false;
  final VehicleEntity? assetData;
  bool? isFromLink = false;
  final List<VehicleLoansEntity>? vehicleLoansEntity;

  AddVehicleManualPage(
      {this.assetData,
      this.vehicleLoansEntity,
      this.hideShowMore,
      this.isFromLink});

  @override
  _AddCustomAssetsState createState() => _AddCustomAssetsState();
}

class _AddCustomAssetsState extends State<AddVehicleManualPage> {
  // Country _initCurrency =
  //     CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
  // Country _selectedDialogCountry =
  //     CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);

  AppLocalizations? translate;
  GlobalKey<CurrencyTextFieldState> globalKey = GlobalKey();

  final _formKey = GlobalKey<FormState>();
  TextFieldValidator validator = TextFieldValidator();
  String? _country = "GBR";
  ValueEntity? _valueEntity;
  TextEditingController _assetName = TextEditingController();

  // TextEditingController _currentValue = TextEditingController();

  bool _isAddingOnprogress = false;
  List<VehicleLoansEntity> vehicleLoansEntityData = [];

  @override
  void initState() {
    super.initState();
    // _initCurrency =
    //     CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);

    // _selectedDialogCountry =
    //     CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);

    ///if editing
    if (widget.assetData != null) {
      _assetName.text = widget.assetData!.name.toString();
      _country = widget.assetData!.country;
      _valueEntity = widget.assetData!.value;
      // _currentValue.text = widget.assetData!.value.amount.toString();
      vehicleLoansEntityData = widget.vehicleLoansEntity ?? [];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _assetName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    return BlocConsumer<AddVehicleCubit, AddVehicleState>(
      listener: (context, state) {
        if (state is AddVehicleInitial) {
          if (!state.status) {
            if (state.message.toString().isNotEmpty) {
              showSnackBar(context: context, title: state.message.toString());
            }
          }
          if (state.status) {
            _isAddingOnprogress = false;

            if (getIsUserInOnBoardingState()) {
              final manualBankSuccessModel = ManualBankSuccessModel(
                bankName: _assetName.text.trim(),
                location: _country ?? '',
                currentAmount: _valueEntity!.amount.toString(),
                currency: _valueEntity!.currency.toString(),
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
                      ? translate!.yourVehicleDetailsaddedSuccessfully
                      : translate!.yourVehicleDetailsUpdatedSuccessfully,
                  // "In some cases it may take a while to establish a secure connection to the banking institution.
                  // So, if you have added your bank and don't see the information in the home screen, don't worry.
                  // We'll be working fast to fetch the details and show you the comprehensive financial data as soon as possible.",
                  info: "",
                  onClicked: () {
                    Navigator.pop(context);
                    if (RootApplicationAccess.assetsEntity?.vehicles.length ==
                            1 &&
                        widget.assetData == null) {
                      if (widget.hideShowMore ?? false) {
                        Navigator.pop(context, state.data);
                      } else {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    VehiclesMainPage()));
                      }
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
        // if (state is AddVehicleInitial) {
        //   _isAddingOnprogress = false;
        // }
        return Scaffold(
            backgroundColor: appThemeColors!.bg,
            appBar: wedgeAppBar(
                context: context,
                title: widget.assetData == null
                    ? "${translate!.add} ${translate!.vehicle}"
                    : "${translate!.edit} ${translate!.vehicle}"),
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
                      hintText: VEHICLE_NAME,
                      inputType: TextInputType.text,
                      noRestriction: true,
                      isDemicalAllowed: false,
                      textEditingController: _assetName,
                      validator: (value) => validator.validateName(
                          value?.trim(), translate!.vehicleName),
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
                    //     labelText: VEHICLE_NAME,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: ktextBoxGap,
                    // ),
                    CountrySelector(
                      updateCountry: _country,
                      onChange: (value) {
                        setState(() {
                          _country = value;
                          globalKey.currentState?.changeCurrency(value);
                        });
                      },
                    ),
                    CurrencyTextField(
                      key: globalKey,
                      hintText: translate!.currentValue,
                      errorMsg:
                          "${translate!.currentValue} ${translate!.isRequired}",
                      currencyModel: _valueEntity,
                      onChange: (value) {
                        _valueEntity = value;
                      },
                    ),

                    // GestureDetector(
                    //   onTap: () {
                    //     WedgeCountryPicker(
                    //         context: context,
                    //         countryPicked: (Country country) {
                    //           setState(() {
                    //             _selectedDialogCountry = country;
                    //           });
                    //         });
                    //   },
                    //   child: Container(
                    //     child: Center(
                    //         child: Row(
                    //       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         // CountryPickerUtils.getDefaultFlagImage(
                    //         //     _selectedDialogCountry),
                    //         // SizedBox(
                    //         //   width: 10,
                    //         // ),
                    //         Text(_selectedDialogCountry.name.toString()),
                    //         Spacer(),
                    //         Icon(Icons.arrow_drop_down),
                    //         SizedBox(
                    //           width: 5,
                    //         ),
                    //       ],
                    //     )),
                    //     height: 60,
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border.all(color: Colors.grey),
                    //       borderRadius: ktextfeildBorderRadius,
                    //     ),
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
                    //       labelText: CURRENT_VALUE,
                    //       suffixStyle: TextStyle(color: Colors.black),
                    //       suffix: GestureDetector(
                    //           onTap: () async {
                    //             WedgeCurrencyPicker(
                    //                 context: context,
                    //                 countryPicked: (Country country) {
                    //                   setState(() {
                    //                     _initCurrency = country;
                    //                   });
                    //                 });
                    //           },
                    //           child: Container(
                    //             width: 60,
                    //             child: Row(
                    //               children: [
                    //                 Text(
                    //                   _initCurrency.currencyCode.toString(),
                    //                   style: TextStyle(color: kfontColorDark),
                    //                 ),
                    //                 Icon(Icons.arrow_drop_down)
                    //               ],
                    //             ),
                    //           ))),
                    // ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    vehicleLoansEntityData.isNotEmpty
                        ? widget.isFromLink ?? false
                            ? Container()
                            : VehicleLoanList(
                                vehicleLoans: widget.assetData,
                                vehicleLoansEntity: vehicleLoansEntityData,
                                onDeleted: () {
                                  setState(() {
                                    vehicleLoansEntityData.clear();
                                  });
                                },
                              )
                        : Container(),
                    vehicleLoansEntityData.isEmpty
                        ? widget.hideShowMore ?? false
                            ? Container()
                            : AddNewButton(
                                text: translate!.addVehicleLoan,
                                onTap: () async {
                                  late VehicleLoansEntity data;
                                  if (await isConnectedToInternetData()) {
                                    if (RootApplicationAccess.liabilitiesEntity
                                            ?.vehicleLoans.isEmpty ??
                                        false) {
                                      data = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddVehicleLoanPage(
                                                    hideShowMore: true,
                                                  )
                                              // AddBankAccountPage()
                                              ));
                                    } else {
                                      data = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  VehicleLoanPage()
                                              // AddBankAccountPage()
                                              ));
                                    }

                                    if (data != null) {
                                      setState(() {
                                        vehicleLoansEntityData.clear();
                                        vehicleLoansEntityData.add(data);
                                        // log(vehicleLoansEntityData);
                                      });
                                    }
                                  } else {
                                    showSnackBar(
                                        context: context,
                                        title:
                                            "You are disconnected from the internet.");
                                  }
                                },
                              )
                        : Container()
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavSingleButtonContainer(
                child: WedgeSaveButton(
                    onPressed: _isAddingOnprogress
                        ? null
                        : () {
                            if (_country?.isEmpty ?? false) {
                              showSnackBar(
                                  context: context,
                                  title: "Please select country");
                            } else {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isAddingOnprogress = true;
                                });
                                if (widget.assetData == null) {
                                  context.read<AddVehicleCubit>().addAsset(
                                      _assetName.text.trim(),
                                      _country,
                                      _valueEntity!.amount.toString(),
                                      _valueEntity!.currency.toString(),
                                      vehicleLoansEntityData.isNotEmpty,
                                      vehicleLoansEntityData,
                                      context);
                                } else {
                                  context.read<AddVehicleCubit>().updateAsset(
                                      widget.assetData?.id,
                                      _assetName.text.trim(),
                                      _country,
                                      _valueEntity!.amount.toString(),
                                      _valueEntity!.currency.toString(),
                                      vehicleLoansEntityData.isNotEmpty,
                                      vehicleLoansEntityData,
                                      context);
                                }
                              }
                            }

                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                    title: widget.assetData == null
                        ? translate!.save
                        : translate!.update,
                    isLoaing: state is AddVehicleLoading)));
      },
    );
  }
}

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
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/core/widgets/inputFields/currency_text_feild.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';
import 'package:wedge/features/assets/properties/add_properties/presentation/bloc/cubit/add_property_cubit.dart';
import 'package:wedge/features/assets/properties/add_properties/presentation/pages/mortgages_taken_list.dart';
import 'package:wedge/features/assets/properties/add_properties/presentation/widgets/mortgages_widget.dart';
import 'package:wedge/features/assets/properties/properties_main/presentation/pages/properties_main_page.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/presentation/pages/add_mortgages_page.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/presentation/cubit/mortage_main_cubit.dart';

class AddPropertyPage extends StatefulWidget {
  bool? hideAddMore = false;
  final PropertyEntity? data;
  bool? isFromLink = false;

  AddPropertyPage({this.data, this.hideAddMore, this.isFromLink});

  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  bool _generateRentalIncome = false;
  final List<dynamic> _mortgages = [];
  final bool _isMortgage = false;
  bool _isAddingOnprogress = false;
  AppLocalizations? translate;

  @override
  void initState() {
    super.initState();

    editData();
  }

  editData() {
    if (widget.data != null) {
      _country = widget.data!.country;
      _nameContr.text = widget.data!.name;
      _purchasedValue = widget.data!.purchasedValue;
      _currentValue = widget.data!.currentValue;
      _generateRentalIncome = widget.data!.hasRentalIncome;
      _monthlyIncomeValue = widget.data!.rentalIncome.monthlyRentalIncome;
      getMortgageData();
    }
  }

  getMortgageData() {
    if (RootApplicationAccess.liabilitiesEntity != null) {
      for (var element in RootApplicationAccess.liabilitiesEntity!.mortgages) {
        for (var e in widget.data!.mortgages) {
          if (e.id == element.id) {
            _mortgages.add(element);
          }
        }
      }
    }
  }

  editMortgages(int index) async {
    var result = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => AddMortgagesPage(
                  mortgagesData: _mortgages[index],
                  isFromLinked: true,
                  mortgages: const [],
                )));
    if (result != null) {
      setState(() {
        _mortgages[index] = result;
      });
      context.read<MortageMainCubit>().getMortgages(context);
    }
  }

  unLinkMortages(int index) {
    if (widget.data != null && widget.data!.mortgages.isNotEmpty) {
      //unlink API
      locator.get<WedgeDialog>().confirm(
          context,
          WedgeConfirmDialog(
              title: translate!.unlinkTheMortgage,
              subtitle: translate!.unlinkMortgageMessage,
              acceptedPress: () {
                showSnackBar(context: context, title: translate!.loading);

                BlocProvider.of<MortageMainCubit>(context).unlinkMortages(
                    UnlinkParams(
                        loanId: _mortgages[index].id,
                        vehicleId: widget.data!.id));
                Navigator.pop(context);
              },
              deniedPress: () {
                Navigator.pop(context);
              },
              acceptText: translate!.yesUnlinkAccount,
              deniedText: translate!.cancel));
    } else {
      // remove from list
      locator.get<WedgeDialog>().confirm(
          context,
          WedgeConfirmDialog(
              title: translate!.unlinkTheMortgage,
              subtitle: translate!.unlinkMortgageMessage,
              acceptedPress: () {
                setState(() {
                  _mortgages.remove(_mortgages[index]);
                });
                Navigator.pop(context);
              },
              deniedPress: () {
                Navigator.pop(context);
              },
              acceptText: translate!.yesUnlinkAccount,
              deniedText: translate!.cancel));
    }
  }

  // Creating text Controller
  final _formKey = GlobalKey<FormState>();
  TextFieldValidator validator = TextFieldValidator();
  String? _country;
  final TextEditingController _nameContr = TextEditingController();
  ValueEntity? _purchasedValue;
  ValueEntity? _currentValue;
  ValueEntity? _monthlyIncomeValue;
  GlobalKey<CurrencyTextFieldState> globalKey = GlobalKey();
  GlobalKey<CurrencyTextFieldState> globalKey2 = GlobalKey();
  GlobalKey<CurrencyTextFieldState> globalKey3 = GlobalKey();

  @override
  void dispose() {
    _nameContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    return BlocConsumer<AddPropertyCubit, AddPropertyState>(
      listener: (context, state) {
        if (state is AddPropertyInitial) {
          if (!state.status) {
            if (state.message.toString().isNotEmpty) {
              showSnackBar(context: context, title: state.message.toString());
            }
          }
          if (state.status) {
            _isAddingOnprogress = false;

            if (getIsUserInOnBoardingState()) {
              final manualBankSuccessModel = ManualBankSuccessModel(
                bankName: _nameContr.text.trim(),
                location: _country ?? "GBR",
                currentAmount: _currentValue!.amount.toString(),
                currency: _currentValue!.currency.toString(),
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
                  title: widget.data == null
                      ? translate!.yourPropertyAddedMessage
                      : translate!.yourPropertyUpdatedMessage,

                  // "In some cases it may take a while to establish a secure connection to the banking institution. So,
                  // if you have added your bank and don't see the information in the home screen,
                  // don't worry. We'll be working fast to fetch the details and show you the comprehensive financial data as soon as possible.",

                  info: "",
                  onClicked: () {
                    Navigator.pop(context);
                    if (RootApplicationAccess.assetsEntity?.properties.length ==
                            1 &&
                        widget.data == null) {
                      if (widget.hideAddMore ?? false) {
                        Navigator.pop(context, state.data);
                      } else {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    const PropertiesMainPage()));
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
        return Scaffold(
            backgroundColor: appThemeColors!.bg,
            appBar: wedgeAppBar(
                context: context,
                title: widget.data == null
                    ? "${translate!.add} ${translate!.properties}"
                    : translate!.editProperty),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Padding(
                padding: const EdgeInsets.all(kpadding),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      CustomFormTextField(
                        hintText: NAME,
                        inputType: TextInputType.text,
                        noRestriction: true,
                        textEditingController: _nameContr,
                        validator: (value) =>
                            validator.validateName(value?.trim(), NAME),
                      ),
                      CountrySelector(
                        updateCountry: _country,
                        onChange: (value) {
                          _country = value;
                          globalKey.currentState?.changeCurrency(value);
                          globalKey2.currentState?.changeCurrency(value);
                          globalKey3.currentState?.changeCurrency(value);
                        },
                      ),
                      CurrencyTextField(
                        key: globalKey,
                        hintText: translate!.purchaseValue,
                        errorMsg:
                            "${translate!.purchaseValue} ${translate!.isRequired}",
                        currencyModel: _purchasedValue,
                        onChange: (value) {
                          _purchasedValue = value;
                        },
                      ),
                      CurrencyTextField(
                        key: globalKey2,
                        hintText: translate!.currentValue,
                        errorMsg:
                            "${translate!.currentValue} ${translate!.isRequired}",
                        currencyModel: _currentValue,
                        onChange: (value) {
                          _currentValue = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.8, 0.0, 0.8, 0.8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * .7,
                              child: Text(
                                translate!.doesPropertyGenerateIncome,
                                overflow: TextOverflow.visible,
                                style: SubtitleHelper.h11
                                    .copyWith(color: appThemeColors!.textDark),
                              ),
                            ),
                            CupertinoSwitch(
                              activeColor: kgreen,
                              value: _generateRentalIncome,
                              onChanged: (v) {
                                setState(() {
                                  _generateRentalIncome = v;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: ktextBoxGap,
                      ),
                      _generateRentalIncome
                          ? AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),
                              opacity: _generateRentalIncome ? 1.0 : 0.0,
                              child: CurrencyTextField(
                                key: globalKey3,
                                hintText: translate!.monthlyRentalIncome,
                                errorMsg:
                                    "${translate!.monthlyRentalIncome} ${translate!.isRequired}",
                                currencyModel: _monthlyIncomeValue,
                                onChange: (value) {
                                  _monthlyIncomeValue = value;
                                },
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      _mortgages.isNotEmpty
                          ? widget.isFromLink ?? false
                              ? Container()
                              : BlocConsumer<MortageMainCubit,
                                  MortageMainState>(
                                  listener: (context, state) {
                                    if (state is MortageMainUnlinked) {
                                      setState(() {
                                        _mortgages.removeWhere((element) =>
                                            element.id == state.id);
                                      });
                                    } else if (state is MortageMainError) {
                                      if (state.id != null) {
                                        setState(() {
                                          _mortgages.removeWhere((element) =>
                                              element.id == state.id);
                                        });
                                      }
                                    }
                                  },
                                  builder: (context, state) {
                                    return MortgagesWidget(
                                      mortgages: _mortgages,
                                      onDeletePressed: (index) {
                                        unLinkMortages(index);
                                      },
                                      onEditPressed: (index) {
                                        editMortgages(index);
                                      },
                                    );
                                  },
                                )
                          : Container(),
                      widget.hideAddMore ?? false
                          ? Container()
                          : widget.isFromLink ?? false
                              ? Container()
                              : AddNewButton(
                                  text:
                                      "${translate!.add} ${translate!.mortgage}",
                                  onTap: () async {
                                    List<MortgagesEntity> data;
                                    late MortgagesEntity mortgagesData;
                                    if (await isConnectedToInternetData()) {
                                      if (RootApplicationAccess
                                              .liabilitiesEntity
                                              ?.mortgages
                                              .isEmpty ??
                                          false) {
                                        mortgagesData = await Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        AddMortgagesPage(
                                                          mortgages: const [],
                                                          hideAddMore: true,
                                                        )
                                                // AddBankAccountPage()
                                                ));
                                        if (mortgagesData != null) {
                                          setState(() {
                                            _mortgages.addAll([mortgagesData]);
                                          });
                                        }
                                      } else {
                                        data = await Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        MortgagesListPage(
                                                          mortgages: _mortgages,
                                                        )
                                                // AddBankAccountPage()
                                                ));

                                        if (data != null) {
                                          setState(() {
                                            _mortgages.addAll(data);
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
              ),
            ),
            bottomNavigationBar: BottomNavSingleButtonContainer(
              child: BlocBuilder<AddPropertyCubit, AddPropertyState>(
                builder: (context, state) {
                  return WedgeSaveButton(
                      onPressed: _isAddingOnprogress
                          ? null
                          : () {
                              if (_country?.isEmpty ?? false) {
                                showSnackBar(
                                    context: context,
                                    title: "Please select country");
                              } else {
                                if (_formKey.currentState!.validate()) {
                                  List<Map<String, dynamic>> mortageData = [];
                                  if (_mortgages.isNotEmpty) {
                                    for (var element in _mortgages) {
                                      mortageData.add({"id": element.id});
                                    }
                                  }
                                  setState(() {
                                    _isAddingOnprogress = true;
                                  });
                                  if (widget.data == null) {
                                    context.read<AddPropertyCubit>().addData(
                                        _nameContr.text.trim(),
                                        _country ?? "GBR",
                                        _purchasedValue!.amount.toString(),
                                        _currentValue!.amount.toString(),
                                        _generateRentalIncome,
                                        "${_monthlyIncomeValue?.amount ?? 0}",
                                        mortageData.isNotEmpty,
                                        _currentValue!.currency.toString(),
                                        _purchasedValue!.currency.toString(),
                                        _monthlyIncomeValue?.currency ?? "",
                                        mortageData);
                                  } else {
                                    context.read<AddPropertyCubit>().updateData(
                                        widget.data?.id,
                                        _nameContr.text.trim(),
                                        _country ?? widget.data!.country,
                                        _purchasedValue!.amount.toString(),
                                        _currentValue!.amount.toString(),
                                        _generateRentalIncome,
                                        _monthlyIncomeValue!.amount.toString(),
                                        mortageData.isNotEmpty,
                                        _currentValue!.currency.toString(),
                                        _purchasedValue!.currency.toString(),
                                        _monthlyIncomeValue!.currency
                                            .toString(),
                                        mortageData);
                                  }
                                }
                              }
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                      title: widget.data == null
                          ? translate!.save
                          : translate!.update,
                      isLoaing: state is AddPropertyLoading);
                },
              ),
            ));
      },
    );
  }
}

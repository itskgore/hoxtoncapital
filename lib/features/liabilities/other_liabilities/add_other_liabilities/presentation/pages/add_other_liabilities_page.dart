import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
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
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/domain/params/add_update_other_liabilities_params.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/presentation/cubit/add_other_liabilities_cubit.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/presentation/pages/other_liabilities_main_page.dart';

class AddOtherLiabilitiesPage extends StatefulWidget {
  AddOtherLiabilitiesPage({Key? key, this.otherLiabilitiesEntity})
      : super(key: key);
  OtherLiabilitiesEntity? otherLiabilitiesEntity;

  @override
  _AddOtherLiabilitiesPageState createState() =>
      _AddOtherLiabilitiesPageState();
}

class _AddOtherLiabilitiesPageState extends State<AddOtherLiabilitiesPage> {
  @override
  void initState() {
    super.initState();
    editData();
  }

  editData() {
    if (widget.otherLiabilitiesEntity != null) {
      _name.text = widget.otherLiabilitiesEntity!.name;
      _country = widget.otherLiabilitiesEntity!.country;
      _monthlyPayment = widget.otherLiabilitiesEntity!.monthlyPayment;
      _debtValue = widget.otherLiabilitiesEntity!.outstandingAmount;
    }
  }

  // Controllers
  final _otherLiabilitiesFormKey = GlobalKey<FormState>();
  String? _country;
  TextFieldValidator validator = TextFieldValidator();
  final TextEditingController _name = TextEditingController();
  ValueEntity? _debtValue;
  ValueEntity? _monthlyPayment;
  GlobalKey<CurrencyTextFieldState> globalKey = GlobalKey();
  GlobalKey<CurrencyTextFieldState> globalKey2 = GlobalKey();

  submitData() {
    if (_country?.isEmpty ?? false) {
      showSnackBar(context: context, title: "Please select country");
    } else {
      if (_otherLiabilitiesFormKey.currentState!.validate()) {
        if (widget.otherLiabilitiesEntity != null) {
          // edit data
          context.read<AddOtherLiabilitiesCubit>().updateOtherLiabilities(
              AddUpdateOtherLiabilitiesParams(
                  id: widget.otherLiabilitiesEntity!.id,
                  name: _name.text,
                  country: _country ?? widget.otherLiabilitiesEntity!.country,
                  debtValue: _debtValue!,
                  monthlyPayment: _monthlyPayment ??
                      ValueEntity(currency: "GBP", amount: 0.0)));
        } else {
          // add new data
          context.read<AddOtherLiabilitiesCubit>().addOtherLiabilities(
              AddUpdateOtherLiabilitiesParams(
                  name: _name.text,
                  country: _country ?? "GBR",
                  debtValue: _debtValue!,
                  monthlyPayment: _monthlyPayment ??
                      ValueEntity(currency: "GBP", amount: 0.0)));
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
          context: context,
          title: widget.otherLiabilitiesEntity == null
              ? "${translate!.add} ${translate.customLiabilities}"
              : "${translate!.edit} ${translate.customLiabilities}",
        ),
        body: BlocConsumer<AddOtherLiabilitiesCubit, AddOtherLiabilitiesState>(
          listener: (context, state) {
            if (state is AddOtherLiabilitiesLoaded) {
              if (getIsUserInOnBoardingState()) {
                final manualBankSuccessModel = ManualBankSuccessModel(
                  bankName: _name.text,
                  location: _country ?? "GBR",
                  currentAmount: _debtValue!.toString(),
                  currency: _monthlyPayment!.currency.toString(),
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
                    title: widget.otherLiabilitiesEntity == null
                        ? translate.yourLiabilityAddedSuccussfully
                        : translate.yourLiabilityUpdatedSuccessfully,
                    info: "",
                    onClicked: () {
                      Navigator.pop(context);
                      if (RootApplicationAccess
                                  .liabilitiesEntity?.otherLiabilities.length ==
                              1 &&
                          widget.otherLiabilitiesEntity == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OtherLiabilitiesMainPage()));
                      } else {
                        Navigator.pop(context, state.otherLiabilitiesEntity);
                      }
                    });
              }
            } else if (state is AddOtherLiabilitiesError) {
              showSnackBar(context: context, title: state.errorMsg);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _otherLiabilitiesFormKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    CustomFormTextField(
                      hintText: NAME,
                      inputType: TextInputType.text,
                      noRestriction: true,
                      textEditingController: _name,
                      validator: (value) =>
                          validator.validateName(value?.trim(), NAME),
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
                      hintText: translate.outStanding,
                      errorMsg:
                          "${translate.outStanding} ${translate.isRequired}",
                      currencyModel: _debtValue,
                      onChange: (value) {
                        _debtValue = value;
                      },
                    ),
                    CurrencyTextField(
                      key: globalKey2,
                      isOptional: true,
                      hintText: translate.monthlyPayment,
                      errorMsg:
                          "${translate.monthlyPayement} ${translate.isRequired}",
                      currencyModel: _monthlyPayment,
                      onChange: (value) {
                        _monthlyPayment = value;
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
          child:
              BlocBuilder<AddOtherLiabilitiesCubit, AddOtherLiabilitiesState>(
            builder: (context, state) {
              return WedgeSaveButton(
                  onPressed: state is AddOtherLiabilitiesLoading
                      ? null
                      : () {
                          submitData();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                  title: widget.otherLiabilitiesEntity == null
                      ? translate.save
                      : translate.update,
                  isLoaing: state is AddOtherLiabilitiesLoading);
            },
          ),
        ));
  }
}

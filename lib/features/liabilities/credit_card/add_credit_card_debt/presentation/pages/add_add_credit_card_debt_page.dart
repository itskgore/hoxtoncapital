import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';
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
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/params/credit_cards_params.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/presentation/cubit/add_credit_card_cubit.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/presentation/pages/credit_card_debt_main_page.dart';

class AddCreditCardDebtPage extends StatefulWidget {
  AddCreditCardDebtPage({Key? key, this.data}) : super(key: key);
  CreditCardsEntity? data;

  @override
  _AddCreditCardDebtPageState createState() => _AddCreditCardDebtPageState();
}

class _AddCreditCardDebtPageState extends State<AddCreditCardDebtPage> {
  // Country _selectedDialogCurrency =
  //     CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
  // Country _selectedDialogCountry =
  //     CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);

  final _creditLoanFormKey = GlobalKey<FormState>();
  String? _country;
  TextFieldValidator validator = TextFieldValidator();
  final TextEditingController _name = TextEditingController();
  ValueEntity? _outStandingAmount;
  GlobalKey<CurrencyTextFieldState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _name.text = widget.data!.name;
      _outStandingAmount = widget.data!.outstandingAmount;
      _country = widget.data!.country;
    } else {
      _country = CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE)
          .name!
          .toUpperCase();
    }
  }

  Future<void> submitData() async {
    if (_country?.isEmpty ?? false) {
      showSnackBar(context: context, title: "Please select country");
    } else {
      if (_creditLoanFormKey.currentState!.validate()) {
        if (widget.data != null) {
          // udpate data
          BlocProvider.of<AddCreditCardCubit>(context).updateCreditCard(
              AddUpdateCreditCardsParams(
                  name: _name.text,
                  id: widget.data!.id,
                  country: _country!,
                  outstandingAmount: _outStandingAmount!));
        } else {
          // add data
          BlocProvider.of<AddCreditCardCubit>(context).addCreditCard(
              AddUpdateCreditCardsParams(
                  name: _name.text,
                  country: _country!,
                  outstandingAmount: _outStandingAmount!));
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
          title: widget.data == null
              ? "${translate!.add} ${translate.creditCardDebt}"
              : "${translate!.edit} ${translate.creditCardDebt}",
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _creditLoanFormKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomFormTextField(
                  hintText: translate.providerName,
                  inputType: TextInputType.text,
                  noRestriction: true,
                  textEditingController: _name,
                  validator: (value) => validator.validateName(
                      value?.trim(), translate.providerName),
                ),
                CountrySelector(
                  updateCountry: _country,
                  onChange: (value) {
                    _country = value;
                    globalKey.currentState?.changeCurrency(value);
                  },
                ),
                CurrencyTextField(
                  key: globalKey,
                  hintText: translate.currentOutstanding,
                  errorMsg:
                      "${translate.currentOutstanding} ${translate.isRequired}",
                  currencyModel: _outStandingAmount,
                  onChange: (value) {
                    _outStandingAmount = value;
                  },
                ),
                const SizedBox(
                  height: ktextBoxGap,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
            child: BlocConsumer<AddCreditCardCubit, AddCreditCardState>(
          listener: (context, state) {
            if (state is AddCreditCardError) {
              showSnackBar(context: context, title: state.errorMsg);
            }
            if (state is AddCreditCardLoaded) {
              if (getIsUserInOnBoardingState()) {
                final manualBankSuccessModel = ManualBankSuccessModel(
                  bankName: _name.text,
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
                    title: widget.data == null
                        ? translate.yourCreditcardDebtAddedSuccessfully
                        : translate.yourCreditCardDebtUpdatedSuccessfully,
                    info: "",
                    onClicked: () {
                      Navigator.pop(context);
                      if (RootApplicationAccess
                                  .liabilitiesEntity?.creditCards.length ==
                              1 &&
                          widget.data == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CreditCardDebtMainPage()));
                      } else {
                        Navigator.pop(context, state.cardsEntity);
                      }
                    });
              }
            }
          },
          builder: (context, state) {
            return WedgeSaveButton(
                onPressed: state is AddCreditCardLoading
                    ? null
                    : () {
                        submitData();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                title: widget.data == null ? translate.save : translate.update,
                isLoaing: state is AddCreditCardLoading);
          },
        )));
  }
}

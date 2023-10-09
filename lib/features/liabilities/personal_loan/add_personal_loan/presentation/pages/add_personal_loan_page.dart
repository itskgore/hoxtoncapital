import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/core/widgets/dialog/custom_date_picker.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/presentation/bloc/add_personal_loan_cubit.dart';

import '../../../../../../core/contants/string_contants.dart';
import '../../../../../../core/helpers/textfeild_validator.dart';
import '../../../../../../core/widgets/dialog/country_selector_widget.dart';
import '../../../../../../core/widgets/dialog/custom_dialog.dart';
import '../../../../../../core/widgets/inputFields/currency_text_feild.dart';
import '../../../../../../core/widgets/inputFields/custom_text_form_field.dart';
import '../../../../../../dependency_injection.dart';
import '../../../personal_loan_main/presentation/pages/personal_loan_main_page.dart';

class AddPersonalLoanPage extends StatefulWidget {
  PersonalLoanEntity? personalLoanEntity;

  AddPersonalLoanPage({Key? key, this.personalLoanEntity}) : super(key: key);

  @override
  _AddPersonalLoanPageState createState() => _AddPersonalLoanPageState();
}

class _AddPersonalLoanPageState extends State<AddPersonalLoanPage> {
  final _personalLoanFormKey = GlobalKey<FormState>();

  TextFieldValidator validator = TextFieldValidator();
  AppLocalizations? translate;

  final TextEditingController _financeProviderController =
      TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _termRemainingController =
      TextEditingController();
  GlobalKey<CurrencyTextFieldState> globalKey = GlobalKey();
  GlobalKey<CurrencyTextFieldState> globalKey2 = GlobalKey();
  GlobalKey<CurrencyTextFieldState> globalKey3 = GlobalKey();

  ValueEntity? _monthlyPayment;
  ValueEntity? _outStandingAmount;
  String? _country;
  bool isLoading = false;

  @override
  void initState() {
    if (widget.personalLoanEntity != null) {
      _financeProviderController.text = widget.personalLoanEntity!.provider;
      _interestController.text =
          widget.personalLoanEntity!.interestRate.toString();
      _termRemainingController.text =
          widget.personalLoanEntity!.maturityDate.toString();
      _monthlyPayment = ValueEntity(
          amount: widget.personalLoanEntity!.monthlyPayment.amount,
          currency: widget.personalLoanEntity!.monthlyPayment.currency);
      _outStandingAmount = ValueEntity(
          amount: widget.personalLoanEntity!.outstandingAmount.amount,
          currency: widget.personalLoanEntity!.outstandingAmount.currency);
      _country = widget.personalLoanEntity!.country;
    }
    super.initState();
  }

  Future<void> submitData() async {
    if (_country?.isEmpty ?? false) {
      showSnackBar(context: context, title: "Please select country");
    } else {
      if (_personalLoanFormKey.currentState!.validate() &&
          double.parse(_interestController.text) <= 100.00) {
        setState(() {
          isLoading = true;
        });
        if (widget.personalLoanEntity != null) {
          // update
          context.read<AddPersonalLoanCubit>().updatePersonalLoan(
                provider: _financeProviderController.text,
                country: _country ?? "GBR",
                interestRate: _interestController.text,
                termRemaining: _termRemainingController.text,
                monthlyPayment: _monthlyPayment!,
                outstandingAmount: _outStandingAmount!,
                id: widget.personalLoanEntity!.id.toString(),
              );
        } else {
          // add new
          context.read<AddPersonalLoanCubit>().addPersonalLoan(
                provider: _financeProviderController.text,
                country: _country ?? "GBR",
                interestRate: _interestController.text,
                termRemaining: _termRemainingController.text,
                monthlyPayment: _monthlyPayment!,
                outstandingAmount: _outStandingAmount!,
              );
        }
      } else {
        if (double.parse(_interestController.text) >= 100.00) {
          showSnackBar(
              context: context,
              title:
                  translateStrings(context)!.interestRateShouldbeLessThan100);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: widget.personalLoanEntity == null
                ? "Add Personal Loan"
                : "Edit Personal Loan"),
        //  WedgeAppBar(
        //     heading: widget.personalLoanEntity == null
        //         ? "Add Personal Loan"
        //         : "Edit Personal Loan"),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _personalLoanFormKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                CustomFormTextField(
                  hintText: "Finance Provider",
                  inputType: TextInputType.text,
                  noRestriction: true,
                  textEditingController: _financeProviderController,
                  validator: (value) =>
                      validator.validateName(value?.trim(), "Finance provider"),
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
                  hintText: "Monthly payment",
                  errorMsg: "Monthy payment is required",
                  currencyModel: _monthlyPayment,
                  onChange: (value) {
                    _monthlyPayment = value;
                  },
                ),
                CustomFormTextField(
                  key: globalKey2,
                  isDemicalAllowed: true,
                  allowNum: true,
                  inputType: TextInputType.numberWithOptions(decimal: true),
                  hintText: "Interest rate",
                  textEditingController: _interestController,
                  validator: (value) =>
                      validator.validateAmount(value?.trim(), "Interest rate"),
                ),
                DatePickerTextField(
                    hintText: "Maturity date",
                    errorMsg: "Maturity date is required",
                    createAt: widget.personalLoanEntity != null
                        ? widget.personalLoanEntity!.createdAt
                        : DateTime.now().toIso8601String(),
                    date: _termRemainingController),
                // CustomFormTextField(
                //   hintText: "Term remaining",
                //   textEditingController: _termRemainingController,
                //   isDemicalAllowed: false,
                //   validator: (value) => validator.validateAmount(value?.trim()),
                // ),
                CurrencyTextField(
                  key: globalKey3,
                  hintText: "Outstanding amount",
                  errorMsg: "Outstanding amount is required",
                  currencyModel: _outStandingAmount,
                  onChange: (value) {
                    _outStandingAmount = value;
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar:
            BlocConsumer<AddPersonalLoanCubit, AddPersonalLoanState>(
          listener: (context, state) {
            if (state is AddPersonalLoanSuccess) {
              setState(() {
                isLoading = false;
              });
              if (getIsUserInOnBoardingState()) {
                final manualBankSuccessModel = ManualBankSuccessModel(
                  bankName: _financeProviderController.text,
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
                    title: widget.personalLoanEntity == null
                        ? "Your personal loan details have been added successfully."
                        : "Your personal loan details have been updated successfully.",
                    info: "",
                    onClicked: () {
                      Navigator.pop(context);
                      if (RootApplicationAccess
                                  .liabilitiesEntity?.personalLoans.length ==
                              1 &&
                          widget.personalLoanEntity == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PersonalLoanMainPage()));
                      } else {
                        Navigator.pop(context, state.data);
                      }
                    });
              }
            } else if (state is AddPersonalLoanError) {
              setState(() {
                isLoading = false;
              });
              showSnackBar(context: context, title: state.errorMessage);
            }
          },
          builder: (context, state) => BottomNavSingleButtonContainer(
              child: WedgeSaveButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          submitData();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                  title: widget.personalLoanEntity == null ? SAVE : "Update",
                  isLoaing: isLoading)),
        ),
      );

  @override
  void dispose() {
    _financeProviderController.dispose();
    _interestController.dispose();
    _termRemainingController.dispose();
    super.dispose();
  }
}

import 'dart:async';

import 'package:country_currency_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/countries.dart';
import 'package:wedge/dependency_injection.dart';

import '../../../../../core/contants/string_contants.dart';
import '../../../../../core/helpers/date_picker_helper.dart';
import '../../../../../core/helpers/firebase_analytics.dart';
import '../../../../../core/helpers/textfeild_validator.dart';
import '../../../../../core/utils/wedge_currency_picker.dart';
import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../core/widgets/buttons/wedge_button.dart';
import '../../../../../core/widgets/inputFields/custom_text_field.dart';
import '../../../../account/my_account/presentation/cubit/user_account_cubit.dart';
import '../../../../account/my_account/presentation/cubit/user_preferences_cubit.dart';
import '../cubit/personal_details_cubit.dart';
import '../cubit/personal_details_state.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  TextEditingController nationalityController = TextEditingController();
  TextEditingController defaultCurrencyController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextFieldValidator validator = TextFieldValidator();

  String? dob;
  final _formKey = GlobalKey<FormState>();
  ValueNotifier isButtonEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    context.read<UserAccountCubit>().getUserDetials();
    context.read<UserPreferencesCubit>().getUserPreferenceDetails();
    BlocProvider.of<PersonalDetailsCubit>(context, listen: false)
        .emit(PersonalDetailsInitial());
    //mix Panel Event
    AppAnalytics().trackEvent(
      eventName: "hoxton-profile-info-mobile",
      parameters: {
        "email Id": locator<SharedPreferences>()
                .getString(RootApplicationAccess.userEmailIDPreferences) ??
            locator<SharedPreferences>()
                .getString(RootApplicationAccess.emailUserPreferences) ??
            '',
        'firstName': getUserNameFromAccessToken()
      },
    );
    super.initState();
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      locator<SharedPreferences>().setString(
        RootApplicationAccess.countryOfResident,
        CountriesWithCodes().countriesWithCode.firstWhere((element) =>
            element['country'].toLowerCase() ==
            countryController.text.toLowerCase())['alpha3'],
      );
      context.read<PersonalDetailsCubit>().updatePersonalDetails({
        "nationality": CountriesWithCodes().countriesWithCode.firstWhere(
            (element) =>
                element['country'].toLowerCase() ==
                nationalityController.text.toLowerCase())['alpha3'],
        "countryOfResident": CountriesWithCodes().countriesWithCode.firstWhere(
            (element) =>
                element['country'].toLowerCase() ==
                countryController.text.toLowerCase())['alpha3'],
        "baseCurrency": defaultCurrencyController.text,
        "dateOfBirth": dobController.text,
        "retirementAge": 0,
        "savingsAmount": 0,
        "savingsAmountCurrency": defaultCurrencyController.text,
      });
    }
  }

  void _validateForm() {
    isButtonEnabled.value = nationalityController.text.isNotEmpty &&
        defaultCurrencyController.text.isNotEmpty &&
        countryController.text.isNotEmpty &&
        dobController.text.isNotEmpty;
    isButtonEnabled.notifyListeners();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await DatePickerHelper.showDatePickerData(
      context: context,
    );

    if (picked != null) {
      setState(() {
        dobController.text = dateFormatter15.format(picked);
      });
    }
    _validateForm();
  }

  @override
  void dispose() {
    nationalityController.dispose();
    defaultCurrencyController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  customBanner(),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    title: translate!.dateOfBirth,
                    hint: "DD/MM/YYYY",
                    isRequired: true,
                    onTab: () {
                      _selectDate(context);
                    },
                    controller: dobController,
                    keyboardType: TextInputType.none,
                    validator: (_) {
                      final value = _ ?? "";
                      return validator.validateDate(value.trim());
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextField(
                    hint: translate!.selectNationality,
                    title: translate!.nationality,
                    isRequired: true,
                    showSuffixIcon: true,
                    controller: nationalityController,
                    keyboardType: TextInputType.none,
                    onTab: () {
                      WedgeCurrencyPicker(
                          context: context,
                          placeholder: translate!.searchByNationality,
                          popTitle: translate!.selectNationality,
                          showCounterCode: false,
                          countryPicked: (Country country) {
                            setState(() {
                              nationalityController.text =
                                  country.currencyName!;
                            });
                            _validateForm();
                          });
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextField(
                    hint: translate!.selectCountry,
                    title: translate!.countryOfResidence,
                    keyboardType: TextInputType.none,
                    isRequired: true,
                    showSuffixIcon: true,
                    controller: countryController,
                    onTab: () {
                      WedgeCurrencyPicker(
                          context: context,
                          placeholder: translate!.searchByCountryOfResidence,
                          popTitle: translate!.selectCountryOfResidence,
                          showCounterCode: false,
                          countryPicked: (Country country) {
                            setState(() {
                              countryController.text = country.currencyName!;
                              defaultCurrencyController.text =
                                  country.currencyCode!;
                            });
                            _validateForm();
                          });
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextField(
                    title: translate!.defaultCurrency,
                    hint: translate!.selectCurrency,
                    keyboardType: TextInputType.none,
                    isRequired: true,
                    showSuffixIcon: true,
                    controller: defaultCurrencyController,
                    onTab: () {
                      WedgeCurrencyPicker(
                          context: context,
                          countryPicked: (Country country) {
                            setState(() {
                              defaultCurrencyController.text =
                                  country.currencyCode!;
                            });
                            _validateForm();
                          });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Spacer(),
                  BlocBuilder<PersonalDetailsCubit, PersonalDetailsState>(
                    builder: (context, state) {
                      return ValueListenableBuilder(
                          valueListenable: isButtonEnabled,
                          builder: (context, isButtonEnabledValue, child) {
                            return SizedBox(
                              height: 45,
                              width: size.width,
                              child: WedgeSaveButton(
                                onPressed: () {
                                  submitForm();
                                },
                                textStyle: TitleHelper.h9
                                    .copyWith(color: Colors.white),
                                title: "Submit",
                                isEnable: isButtonEnabledValue,
                                isLoaing: state is PersonalDetailsLoading,
                                isLoaded: state is PersonalDetailsLoaded,
                              ),
                            );
                          });
                    },
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customBanner() {
    var translate = translateStrings(context);
    return Column(children: [
      SvgPicture.asset(
        "assets/images/high_five.svg",
        height: size.height * .2,
        // width: 25,
        // height: 25,
        // scale: 2
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${translate!.welcome} ${getUserNameFromAccessToken()}!",
                style: TitleHelper.h5),
            Text(
                "Congratulations! You have signed up successfully. Please help us personalise the app for you!",
                style: SubtitleHelper.h11.copyWith(color: Colors.black))
          ],
        ),
      )
    ]);
  }
}

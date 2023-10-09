import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/beneficiary_member_entity.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/wedge_app_bar.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/presentation/cubit/beneficiary_add_cubit.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/presentation/widgets/beneficiary_contact_days.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/presentation/widgets/beneficiary_phone_number_picker.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/presentation/widgets/beneficiary_text_field.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/presentation/cubit/beneficiary_main_cubit.dart';
import 'package:wedge/features/beneficiary/trusted_add/presentation/pages/add_trusted_member_screen.dart';

class AddBeneficiaryScreen extends StatefulWidget {
  BeneficiaryMembersEntity? beneficiaryMembersEntity;
  TrustedMembersEntity? trustedMembersEntity;

  AddBeneficiaryScreen(
      {Key? key, this.beneficiaryMembersEntity, this.trustedMembersEntity})
      : super(key: key);

  @override
  _AddBeneficiaryScreenState createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  AppLocalizations? translate;
  final _formKey = GlobalKey<FormState>();

  TextFieldValidator validator = TextFieldValidator();

  final TextEditingController _beneficiaryName = TextEditingController();
  final TextEditingController _beneficiaryEmail = TextEditingController();
  final TextEditingController _beneficiaryPhone = TextEditingController();
  String selectedContactDays = "20";
  String countryCode = "";
  List<Map<String, dynamic>> contactDays = [
    {
      "isSelected": true,
      "text": "20",
    },
    {
      "isSelected": false,
      "text": "30",
    },
    {
      "isSelected": false,
      "text": "45",
    },
    {
      "isSelected": false,
      "text": "60",
    },
  ];

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      if (countryCode.isEmpty) {
        showSnackBar(
            context: context, title: "${translate!.selectPhoneCountryCode}");
      } else {
        if (widget.beneficiaryMembersEntity != null &&
            !widget.beneficiaryMembersEntity!.isEmpty) {
          context.read<BeneficiaryAddCubit>().editBeneficiaryMember({
            "id": "${widget.beneficiaryMembersEntity!.id}",
            "name": "${_beneficiaryName.text}",
            "email": "${_beneficiaryEmail.text}",
            "countryCode": "${countryCode}",
            "contactNumber": "${_beneficiaryPhone.text}",
            "inactivityThresholdDays": int.parse(selectedContactDays)
          });
        } else {
          context.read<BeneficiaryAddCubit>().addBeneficiaryMember({
            "name": "${_beneficiaryName.text}",
            "email": "${_beneficiaryEmail.text}",
            "countryCode": "${countryCode}",
            "contactNumber": "${_beneficiaryPhone.text}",
            "inactivityThresholdDays": int.parse(selectedContactDays)
          });
        }
      }
    } else {
      return null;
    }
  }

  @override
  void initState() {
    if (widget.beneficiaryMembersEntity != null &&
        !widget.beneficiaryMembersEntity!.isEmpty) {
      _beneficiaryEmail.text = widget.beneficiaryMembersEntity!.email;
      _beneficiaryName.text = widget.beneficiaryMembersEntity!.name;
      _beneficiaryPhone.text = widget.beneficiaryMembersEntity!.contactNumber;
      selectedContactDays =
          widget.beneficiaryMembersEntity!.inactivityThresholdDays.toString();
      countryCode = widget.beneficiaryMembersEntity!.countryCode;
      contactDays.forEach((element) {
        if (element['text'] == selectedContactDays) {
          element['isSelected'] = true;
        } else {
          element['isSelected'] = false;
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _beneficiaryEmail.dispose();
    _beneficiaryName.dispose();
    _beneficiaryPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    var underlineInputBorder = UnderlineInputBorder(
        borderSide: BorderSide(
            width: 0.5, color: lighten(appThemeColors!.disableText!, .2)));
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: WedgeAppBar(
        heading: "${translate!.addBeneficiary}",
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "${translate!.addBeneficiaryDescrip}",
                style: SubtitleHelper.h10
                    .copyWith(height: 1.8, color: appThemeColors!.disableText),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BeneficiaryTextField(
                          title: translate!.wantToAdd,
                          placeholder: translate!.beneficiaryName,
                          validator: (_) {
                            final value = _ ?? "";
                            if (value.trimLeft().trimRight().isEmpty) {
                              return "${translate!.provideBeneficiaryName}";
                            } else {
                              return null;
                            }
                          },
                          controller: _beneficiaryName),
                      BeneficiaryTextField(
                          title: translate!.hisHerEmailId,
                          placeholder: translate!.beneficiaryEmail,
                          validator: (_) {
                            final value = _ ?? "";
                            return validator.validateEmail(value.trim());
                          },
                          controller: _beneficiaryEmail),
                      PhoneNumberPicker(
                          title: translate!.hisHerPhoneNumber,
                          placeHolder: translate!.phoneNumber,
                          countryCode: countryCode,
                          onCountryChange: (_) {
                            countryCode = _.phoneCode ?? "";
                          },
                          validator: (_) {
                            final value = _ ?? "";
                            if (value.trimLeft().trimRight().isEmpty) {
                              return "${translate!.provideBeneficiaryPhone}";
                            } else if (value.length >= 15 ||
                                value.length <= 2) {
                              return "${translate!.phoneNumValidation}";
                            } else {
                              return null;
                            }
                          },
                          searchPlaceholder: "${translate!.searchCountryCode}",
                          controller: _beneficiaryPhone),
                      BeneficiaryContactDays(
                        contactDays: contactDays,
                        description: translate!.daysInactivity,
                        onChange: (_) {
                          contactDays = _;
                          contactDays.forEach((element) {
                            if (element['isSelected']) {
                              selectedContactDays = element['text'];
                            }
                          });
                        },
                        title: translate!.contactAfter,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BlocConsumer<BeneficiaryAddCubit, BeneficiaryAddState>(
                listener: (context, state) {
                  if (state is BeneficiaryAddLoaded) {
                    context.read<BeneficiaryMainCubit>().getBeneficiary();
                    if (widget.beneficiaryMembersEntity!.isEmpty) {
                      if (widget.trustedMembersEntity!.isEmpty) {
                        locator.get<WedgeDialog>().success(
                            context: context,
                            title: "",
                            info: "${translate!.successAddedBeneficiary}",
                            onClicked: () async {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          AddTrustedMemberScreen(
                                            trustedMembersEntity:
                                                widget.trustedMembersEntity,
                                          )));
                            });
                      } else {
                        locator.get<WedgeDialog>().success(
                            context: context,
                            title: "",
                            info: "${translate!.successAddedBeneficiary}",
                            onClicked: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                      }
                    } else {
                      locator.get<WedgeDialog>().success(
                          context: context,
                          title: "",
                          info: "${translate!.successUpdatedBeneficiary}",
                          onClicked: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                    }
                  }
                },
                builder: (context, state) {
                  return Container(
                    width: double.infinity,
                    height: 55,
                    margin: EdgeInsets.only(bottom: 20),
                    child: WedgeSaveButton(
                        onPressed: state is BeneficiaryAddLoading
                            ? null
                            : () {
                                submit();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                        title: widget.beneficiaryMembersEntity!.isEmpty
                            ? !widget.trustedMembersEntity!.isEmpty
                                ? "${translate!.saveNExit}"
                                : translate!.saveNext
                            : translate!.update,
                        isLoaing: state is BeneficiaryAddLoading),
                  );
                },
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

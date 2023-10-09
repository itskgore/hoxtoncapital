import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/wedge_app_bar.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/presentation/widgets/beneficiary_phone_number_picker.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/presentation/widgets/beneficiary_text_field.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/presentation/cubit/trusted_main_cubit.dart';
import 'package:wedge/features/beneficiary/trusted_add/presentation/cubit/trusted_add_cubit.dart';

class AddTrustedMemberScreen extends StatefulWidget {
  TrustedMembersEntity? trustedMembersEntity;

  AddTrustedMemberScreen({Key? key, this.trustedMembersEntity})
      : super(key: key);

  @override
  _AddTrustedMemberScreenState createState() => _AddTrustedMemberScreenState();
}

class _AddTrustedMemberScreenState extends State<AddTrustedMemberScreen> {
  AppLocalizations? translate;
  final _formKey = GlobalKey<FormState>();

  TextFieldValidator validator = TextFieldValidator();

  final TextEditingController _trustedName = TextEditingController();
  final TextEditingController _trustedEmail = TextEditingController();
  final TextEditingController _trustedPhone = TextEditingController();
  String countryCode = "";

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      if (countryCode.isEmpty) {
        showSnackBar(
            context: context, title: "${translate!.selectPhoneCountryCode}");
      } else {
        if (widget.trustedMembersEntity != null &&
            !widget.trustedMembersEntity!.isEmpty) {
          // Edit
          context.read<TrustedAddCubit>().editTrustedMember({
            "id": "${widget.trustedMembersEntity!.id}",
            "name": "${_trustedName.text}",
            "countryCode": "${countryCode}",
            "email": "${_trustedEmail.text}",
            "contactNumber": "${_trustedPhone.text}",
          });
        } else {
          // Add
          context.read<TrustedAddCubit>().addTrustedMember({
            "name": "${_trustedName.text}",
            "email": "${_trustedEmail.text}",
            "countryCode": "${countryCode}",
            "contactNumber": "${_trustedPhone.text}",
          });
        }

        // Navigator.push(context,
        //     CupertinoPageRoute(builder: (context) => AddTrustedMemberScreen()));
      }
    } else {
      return null;
    }
  }

  @override
  void initState() {
    if (widget.trustedMembersEntity != null &&
        !widget.trustedMembersEntity!.isEmpty) {
      _trustedName.text = widget.trustedMembersEntity!.name;
      _trustedEmail.text = widget.trustedMembersEntity!.email;
      _trustedPhone.text = widget.trustedMembersEntity!.contactNumber;
      countryCode = widget.trustedMembersEntity!.countryCode;
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _trustedEmail.dispose();
    _trustedName.dispose();
    _trustedPhone.dispose();
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
        heading: "${translate!.addTrustedMember}",
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "${translate!.addTrustedMemberDescrip}",
                style: SubtitleHelper.h10
                    .copyWith(height: 1.7, color: appThemeColors!.disableText),
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BeneficiaryTextField(
                          title: translate!.completelyTrust,
                          placeholder: translate!.trustedFriendsName,
                          validator: (_) {
                            final value = _ ?? "";
                            if (value.trimLeft().trimRight().isEmpty) {
                              return "${translate!.provideFriendName}";
                            } else {
                              return null;
                            }
                          },
                          controller: _trustedName),
                      BeneficiaryTextField(
                          title: translate!.hisHerEmail,
                          placeholder: translate!.trustedMemberEmail,
                          validator: (_) {
                            final value = _ ?? "";
                            return validator.validateEmail(value.trim());
                          },
                          controller: _trustedEmail),
                      PhoneNumberPicker(
                          title: "${translate!.phoneNumberIs}",
                          placeHolder: "${translate!.phoneNumber}",
                          countryCode: countryCode,
                          onCountryChange: (_) {
                            countryCode = _.phoneCode ?? "";
                          },
                          validator: (_) {
                            final value = _ ?? "";
                            if (value.trimLeft().trimRight().isEmpty) {
                              return "${translate!.provideFriendPhoneNum}";
                            } else if (value.length >= 15 ||
                                value.length <= 2) {
                              return "${translate!.phoneNumValidation}";
                            } else {
                              return null;
                            }
                          },
                          searchPlaceholder: "${translate!.searchCountryCode}",
                          controller: _trustedPhone),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocConsumer<TrustedAddCubit, TrustedAddState>(
                listener: (context, state) {
                  if (state is TrustedAddLoaded) {
                    context.read<TrustedMainCubit>().getTrustedDetails();
                    if (widget.trustedMembersEntity!.isEmpty) {
                      locator.get<WedgeDialog>().success(
                          context: context,
                          title: "",
                          info: "${translate!.successAddedTrusted}",
                          onClicked: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                    } else {
                      locator.get<WedgeDialog>().success(
                          context: context,
                          title: "",
                          info: "${translate!.successUpdatedTrustedMember}",
                          onClicked: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                    }
                  }
                },
                builder: (context, state) {
                  return Container(
                    color: appThemeColors!.bg,
                    width: double.infinity,
                    height: 55,
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: WedgeSaveButton(
                        onPressed: state is TrustedAddLoading
                            ? null
                            : () {
                                submit();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                        title: widget.trustedMembersEntity!.isEmpty
                            ? translate!.done
                            : translate!.update,
                        isLoaing: state is TrustedAddLoading),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

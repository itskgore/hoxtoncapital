import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/user_account_data_entity.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/core/widgets/dialog/country_selector_widget.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/dependency_injection.dart';

import '../../domain/usecase/params/edit_user_account_params.dart';
import '../cubit/get_tenant_cubit.dart';
import '../cubit/user_account_cubit.dart';
import '../widgets/image_picker_dialog.dart';

class UserAccountEdit extends StatefulWidget {
  UserAccountDataEntity userAccountDataEntity;

  UserAccountEdit({Key? key, required this.userAccountDataEntity})
      : super(key: key);

  @override
  State<UserAccountEdit> createState() => _UserAccountEditState();
}

class _UserAccountEditState extends State<UserAccountEdit> {
  final _formKey = GlobalKey<FormState>();

  TextFieldValidator validator = TextFieldValidator();

  final TextEditingController _firstNameContr = TextEditingController();
  final TextEditingController _lastNameContr = TextEditingController();

  final TextEditingController _emailContr = TextEditingController();

  final TextEditingController _phoneContr = TextEditingController();

  String? _country;

  @override
  void initState() {
    super.initState();
    populateFields();
  }

  populateFields() {
    _firstNameContr.text = widget.userAccountDataEntity.firstName;
    _lastNameContr.text = widget.userAccountDataEntity.lastName;
    _country = widget.userAccountDataEntity.country;
    _emailContr.text = widget.userAccountDataEntity.email;
    _phoneContr.text = widget.userAccountDataEntity.mobileNumber;
    base64Image = widget.userAccountDataEntity.profilePic;
    String image = "";
    if (base64Image.contains("data:image/png;base64,")) {
      image = base64Image.replaceAll("data:image/png;base64,", "");
    } else if (base64Image.contains("data:image/jpeg;base64,")) {
      image = base64Image.replaceAll("data:image/jpeg;base64,", "");
    } else if (base64Image.contains("data:image/jpg;base64,")) {
      image = base64Image.replaceAll("data:image/jpg;base64,", "");
    }
    bytes = base64Decode(image);
    if (_country!.isEmpty) {
      _country = "GBR";
    }
  }

  submitData(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // print("asdadsdsa");
      BlocProvider.of<UserAccountCubit>(context).eidtUserAccountData(
          EditUserAccountParams(
              country: _country ?? "",
              firstName: _firstNameContr.text.trimLeft().toString(),
              lastName: _lastNameContr.text.trimLeft().toString(),
              profilePic: base64Image));
    }
  }

  showImageSelectionPopUp(BuildContext context) {
    return showDialog(
        context: context,
        barrierColor: appThemeColors!.primary,
        builder: (BuildContext context) {
          return ImagePickerDialog(
            onTap: (_) {
              imagePicker(_);
            },
          );
        });
  }

  String base64Image = "";
  late Uint8List bytes;

  imagePicker(bool isGallery) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image;
      if (isGallery) {
        image = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 10,
            maxHeight: 500,
            maxWidth: 500);
      } else {
        image = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 10,
            maxHeight: 500,
            maxWidth: 500);
      }
      setState(() {
        bytes = File(image!.path).readAsBytesSync();
        base64Image = "data:image/png;base64,${base64Encode(bytes)}";
        if (Platform.isAndroid) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      if (e.toString().toLowerCase() ==
          "PlatformException(photo_access_denied, The user did not allow photo access., null, null)"
              .toLowerCase()) {
        requestAccess(context);
      }
    }
  }

  @override
  void dispose() {
    _emailContr.dispose();
    _firstNameContr.dispose();
    _firstNameContr.dispose();
    _phoneContr.dispose();
    _phoneContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar:
          wedgeAppBar(context: context, title: translate!.editProfileDetials),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: base64Image.isNotEmpty
                        ? MemoryImage(
                            bytes,
                          )
                        : const AssetImage(
                            "assets/images/hoxton_app_logo.png",
                          ) as ImageProvider,
                    radius: 50,
                  ),
                  // Spacer(),
                  const SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Platform.isIOS
                          ? imagePicker(
                              true,
                            )
                          : showImageSelectionPopUp(context);
                    },
                    child: Row(
                      children: [
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: kDividerColor),
                                color: Colors.white,
                                shape: BoxShape.circle),
                            child: const Padding(
                              padding: EdgeInsets.all(3),
                              child: Icon(
                                Icons.camera_alt,
                                size: 25,
                                color: Colors.grey,
                              ),
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          translate.changePicture,
                          style: SubtitleHelper.h10
                              .copyWith(color: appThemeColors!.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomFormTextField(
                        hintText: translate.firstName,
                        inputType: TextInputType.text,
                        textEditingController: _firstNameContr,
                        validator: (value) => validator.validateName(
                            value?.trim(), translate.firstName),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormTextField(
                        hintText: translate.lastName,
                        inputType: TextInputType.text,
                        textEditingController: _lastNameContr,
                        validator: (value) => validator.validateName(
                            value?.trim(), translate.lastName),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CountrySelector(
                        updateCountry: _country,
                        onChange: (value) {
                          _country = value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
              CustomFormTextField(
                enabled: false,
                hintText: translate.email,
                inputType: TextInputType.emailAddress,
                textEditingController: _emailContr,
                validator: (value) => validator.validateEmail(value?.trim()),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<GetTenantCubit, GetTenantState>(
                bloc: context.read<GetTenantCubit>().getTanent(),
                builder: (context, state) {
                  if (state is GetTenantLoading) {
                    return buildCircularProgressIndicator();
                  } else if (state is GetTenantLoaded) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue, width: 1)),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error,
                            size: 30,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                                translate.emailChangeInfo.replaceAll(
                                    "clientportal-support@hoxtoncapital.com",
                                    state.tenantEntity.contact?.email ?? ""),
                                maxLines: 3,
                                style: SubtitleHelper.h11),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(
                height: 35,
              ),
              BlocConsumer<UserAccountCubit, UserAccountState>(
                listener: (context, state) {
                  if (state is UserAccountLoaded) {
                    if (state.isUpdated) {
                      locator.get<WedgeDialog>().success(
                          context: context,
                          title: translate.profileUpdatedSuccessfully,
                          info: "",
                          onClicked: () {
                            Navigator.pop(context);
                            Navigator.pop(context, state.userAccountDataEntity);
                          });
                    }
                  } else if (state is UserAccountError) {
                    showSnackBar(context: context, title: state.errorMsg);
                  }
                },
                builder: (context, state) {
                  return Container(
                      width: double.infinity,
                      height: 50,
                      child: WedgeSaveButton(
                          onPressed: state is UserAccountLoading
                              ? null
                              : () {
                                  submitData(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                          title: translate.update,
                          isLoaing: state is UserAccountLoading));
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget getPopUpButtons(
      {required IconData icon,
      required String title,
      required Function() onTap}) {
    return Container(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 3,
              primary: Colors.black,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: const TextStyle(fontSize: kfontMedium),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_right)
                ],
              ),
            )));
  }
}

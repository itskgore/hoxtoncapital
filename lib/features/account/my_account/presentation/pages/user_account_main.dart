import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:country_currency_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/user_account_data_entity.dart';
import 'package:wedge/core/entities/user_preferences_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_currency_picker.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/account/my_account/presentation/cubit/enable_biometric_switch_cubit.dart';
import 'package:wedge/features/account/my_account/presentation/pages/user_account_edit.dart';
import 'package:wedge/features/auth/terms_and_condition/presentation/pages/terms_and_condi_page.dart';
import 'package:wedge/features/change_passcode/presentation/pages/change_passcode_page.dart';
import 'package:wedge/features/change_password/presentation/pages/change_password_page.dart';

import '../../domain/usecase/params/edit_user_account_params.dart';
import '../cubit/user_account_cubit.dart';
import '../cubit/user_preferences_cubit.dart';
import '../widgets/image_picker_dialog.dart';

class UserAccountMain extends StatelessWidget {
  UserAccountMain({Key? key}) : super(key: key);

  showImageSelectionPopUp(BuildContext context) {
    return showDialog(
        context: context,
        barrierColor: appThemeColors!.primary,
        builder: (BuildContext context) {
          return ImagePickerDialog(
            onTap: (_) {
              imagePicker(_, context);
            },
          );
        });
  }

  String base64Image = "";
  late Uint8List bytes;

  imagePicker(bool isGallery, BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image;
      if (isGallery) {
        image = await picker.pickImage(
          source: ImageSource.gallery,
        );
      } else {
        image = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 10,
            maxHeight: 500,
            maxWidth: 500);
      }

      final validateSize = File(image!.path).readAsBytesSync().lengthInBytes;
      final kb = validateSize / 1024;

      final mb = (kb / 1000);
      // final mb = validateSize / 125000;
      // print(mb);
      // if (mb < 5) {
      bytes = File(image.path).readAsBytesSync();
      base64Image = "data:image/png;base64,${base64Encode(bytes)}";
      if (Platform.isIOS) {
      } else {
        Navigator.pop(context);
      }
      submitData(context);
    } catch (e) {
      if (e.toString().toLowerCase() ==
          "PlatformException(photo_access_denied, The user did not allow photo access., null, null)"
              .toLowerCase()) {
        requestAccess(context);
      }
    }
  }

  // clear
  // DTR

  submitData(BuildContext context) {
    BlocProvider.of<UserAccountCubit>(context).eidtUserAccountData(
        EditUserAccountParams(
            country: _userAccountDataEntity.country,
            firstName: _userAccountDataEntity.firstName,
            lastName: _userAccountDataEntity.lastName,
            profilePic: base64Image));
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  late UserAccountDataEntity _userAccountDataEntity;

  // final ValueNotifier<bool?> hasDeviceHasBiometric = ValueNotifier<bool?>(null);
  // getHasDeviceHasBiometric() async {
  //   hasDeviceHasBiometric.value =
  //       await BioMetricsAuth().checkIfDeviceHasBiometrics();
  //   hasDeviceHasBiometric.notifyListeners();
  // }

  @override
  Widget build(BuildContext context) {
    // getHasDeviceHasBiometric();
    var translate = translateStrings(context);
    return SafeArea(
        child: Scaffold(
      appBar: appTheme.clientName!.toLowerCase() != "wedge"
          ? null
          : wedgeAppBar(
              context: context,
              title: translate!.account_label,
              actions: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => UserAccountEdit(
                                  userAccountDataEntity: RootApplicationAccess
                                      .userAccountDataEntity!,
                                ))).then((value) {
                      context.read<UserAccountCubit>().getUserDetials();
                    });
                  },
                  icon: Image.asset(
                    "${appIcons.myAccountPaths!.editIcon}",
                    width: 25,
                  ))),
      body: BlocConsumer<UserAccountCubit, UserAccountState>(
        bloc: context.read<UserAccountCubit>().getUserDetials(),
        listener: (context, state) {
          if (state is UserAccountLoaded) {
            if (state.isUpdated) {
              context.read<UserAccountCubit>().getUserDetials();
            } else if (state.errorMsg != null) {
              showSnackBar(context: context, title: state.errorMsg ?? "");
            }
          } else if (state is UserAccountError) {
            showSnackBar(context: context, title: state.errorMsg);
          }
        },
        builder: (context, state) {
          if (state is UserAccountLoading) {
            return Center(
              child: buildCircularProgressIndicator(width: 100),
            );
          } else if (state is UserAccountLoaded) {
            _userAccountDataEntity = state.userAccountDataEntity;
            String image = "";
            if (state.userAccountDataEntity.profilePic
                .contains("data:image/png;base64,")) {
              image = state.userAccountDataEntity.profilePic
                  .replaceAll("data:image/png;base64,", "");
            } else if (state.userAccountDataEntity.profilePic
                .contains("data:image/jpeg;base64,")) {
              image = state.userAccountDataEntity.profilePic
                  .replaceAll("data:image/jpeg;base64,", "");
            } else if (state.userAccountDataEntity.profilePic
                .contains("data:image/jpg;base64,")) {
              image = state.userAccountDataEntity.profilePic
                  .replaceAll("data:image/jpg;base64,", "");
            }
            Uint8List utils = base64Decode(image);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    appTheme.clientName!.toLowerCase() != "wedge"
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => UserAccountEdit(
                                                userAccountDataEntity:
                                                    RootApplicationAccess
                                                        .userAccountDataEntity!,
                                              ))).then((value) {
                                    context
                                        .read<UserAccountCubit>()
                                        .getUserDetials();
                                  });
                                },
                                icon: Image.asset(
                                  "${appIcons.myAccountPaths!.editIcon}",
                                  width: 25,
                                )),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // showImageSelectionPopUp(context);
                              Platform.isIOS
                                  ? imagePicker(true, context)
                                  : showImageSelectionPopUp(context);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: utils.isEmpty
                                          ? const AssetImage(
                                              "assets/images/hoxton_app_logo.png")
                                          : MemoryImage(utils) as ImageProvider,
                                    ),
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: Colors.white, width: 5),
                                    // color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 4,
                                        blurRadius: 9,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: -15,
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: const Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Text(
                              "${state.userAccountDataEntity.firstName} ${state.userAccountDataEntity.lastName}",
                              style: TitleHelper.h10),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            state.userAccountDataEntity.country,
                            style: SubtitleHelper.h11,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Divider(
                            color: Color(0xfffE0E0E0),
                            height: 1,
                          ),
                          buildUserDetailItem(
                            icon: Icons.mail,
                            label: translate!.email,
                            title: state.userAccountDataEntity.email,
                          ),
                          buildUserDetailItem(
                              icon: Icons.paid,
                              label: translate.defaultCurrency,
                              title: state.userAccountDataEntity.country,
                              titleChild: CurrencySelector()),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ChangePasswordPage(
                                            userMail: state
                                                .userAccountDataEntity.email,
                                          )));
                            },
                            child: buildUserDetailItem(
                                icon: Icons.lock,
                                label: "Change password",
                                title: state.userAccountDataEntity.country,
                                titleChild: const Icon(Icons.chevron_right)),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            CreatePasscodePage(
                                              userMail: state
                                                  .userAccountDataEntity.email,
                                            )));
                              },
                              child: buildUserDetailItem(
                                  icon: Icons.security,
                                  label: "Create / Change Passcode",
                                  title: "Create / Change Passcode",
                                  titleChild: const Icon(Icons.chevron_right))),
                          buildUserDetailItem(
                            icon: Icons.biotech,
                            label: "Biometrics Login",
                            title: "Biometrics Login",
                            leadingImg: "assets/images/bio_metric.svg",
                            titleChild: const EnableBioMetricSwitch(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text:
                                      'Hoxton Capital respects your privacy. For information about what information we collect and how we use it, visit our ',
                                  style:
                                      SubtitleHelper.h10.copyWith(height: 1.7)),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TitleHelper.h10.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: appThemeColors!.outline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                TermsConditionPage(
                                                  hideAcceptButton: true,
                                                  displayUrl:
                                                      appTheme.privacyPolicy!,
                                                )));
                                  },
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'To view the portal ',
                                      style: SubtitleHelper.h10
                                          .copyWith(height: 1.7)),
                                  TextSpan(
                                    text: 'Terms and Condition',
                                    style: TitleHelper.h10.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: appThemeColors!.outline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    TermsConditionPage(
                                                      hideAcceptButton: true,
                                                      displayUrl: appTheme
                                                          .termsCondition!,
                                                    )));
                                      },
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                          // buildUserDetailItem(
                          //   icon: Icons.lock,
                          //   label: "Reset Passcode",
                          //   title: "Rest",
                          // ),
                          // buildUserDetailItem(
                          //   icon: Icons.lock,
                          //   label: "User auth",
                          //   title: state.userAccountDataEntity.country,
                          //   titleChild: Container(
                          //     width: 150,
                          //     // height: 100,
                          //     child: WedgeCustomDropDown(
                          //         decoration: InputDecoration(
                          //           contentPadding: EdgeInsets.zero,
                          //           enabledBorder: ktextFeildOutlineInputBorder,
                          //           focusedBorder: ktextFeildOutlineInputBorder,
                          //           border: ktextFeildOutlineInputBorder,
                          //         ),
                          //         items: ["None", "Bio metrics", "Passcode"],
                          //         value: "Passcode",
                          //         onChanged: (i) {}),
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    ));
  }

  Container buildUserDetailItem(
      {required IconData icon,
      required String label,
      required String title,
      Widget? titleChild,
      String? leadingImg}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color(0xfffE0E0E0), width: 0.4))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            leadingImg == null
                ? Icon(
                    icon,
                    color: appThemeColors!.primary,
                  )
                : SvgPicture.asset(
                    leadingImg,
                    width: 28,
                  ),
            const SizedBox(
              width: 15,
            ),
            Text(
              label,
              style: SubtitleHelper.h11,
            ),
            const Spacer(),
            titleChild ??
                Container(
                  width: size.width * .55,
                  child: Text("  $title",
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      style: SubtitleHelper.h11),
                )
          ],
        ),
      ),
    );
  }
}

class CurrencySelector extends StatefulWidget {
  CurrencySelector({Key? key}) : super(key: key);

  @override
  _CurrencySelectorState createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  editUserPreferences(String countryName, UserPreferencesEntity data) {
    context.read<UserPreferencesCubit>().editUserPreferenceDetails({
      "resourceId": "general",
      "resourceType": "general",
      "id": data.id,
      "preference": {"currency": countryName}
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<UserPreferencesCubit>().getUserPreferenceDetails();
    getAuth();
  }

  getAuth() {
    if (locator<SharedPreferences>()
        .containsKey(RootApplicationAccess.authBioSelectedPreferences)) {
      if (locator<SharedPreferences>()
          .containsKey(RootApplicationAccess.authBioSelectedPreferences)) {
        selectedAuth = "Bio metrics";
      } else {
        selectedAuth = "Passcodee";
      }
    } else {
      selectedAuth = "None";
    }
  }

  String selectedAuth = "Passcode";

  confirmCurrencyChange(
      {required String currencyCode,
      required BuildContext context,
      required UserPreferencesEntity userEntity}) {
    locator.get<WedgeDialog>().confirm(
        context,
        WedgeConfirmDialog(
            title: "Change currency",
            subtitle: "Do you want to change the base currency",
            acceptedPress: () {
              Navigator.pop(context);
              showSnackBar(
                  context: context, title: translateStrings(context)!.loading);
              editUserPreferences(currencyCode, userEntity);
            },
            deniedPress: () {
              Navigator.pop(context);
            },
            acceptText: translateStrings(context)!.yes,
            deniedText: translateStrings(context)!.noiWillKeepIt));
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return BlocConsumer<UserPreferencesCubit, UserPreferencesState>(
      listener: (context, state) {
        if (state is UserPreferencesLoaded) {
          if (state.isPreferencesUpdated) {
            showSnackBar(context: context, title: translate!.currencyUpdated);
          }
        }
      },
      builder: (context, state) {
        if (state is UserPreferencesLoading) {
          return buildCircularProgressIndicator();
        } else if (state is UserPreferencesError) {
          return const Text("");
        } else if (state is UserPreferencesLoaded) {
          return GestureDetector(
              onTap: () async {
                WedgeCurrencyPicker(
                    context: context,
                    countryPicked: (Country country) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        confirmCurrencyChange(
                            context: context,
                            currencyCode: country.currencyCode!,
                            userEntity: state.userPreferencesEntity);
                      });
                    });
              },
              child: SizedBox(
                width: 60,
                child: Row(
                  children: [
                    Text(
                      state.userPreferencesEntity.preference.currency ?? "",
                      style: SubtitleHelper.h11,
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.black)
                  ],
                ),
              ));
        } else {
          return Container();
        }
      },
    );
  }
}

class EnableBioMetricSwitch extends StatefulWidget {
  const EnableBioMetricSwitch({
    Key? key,
  }) : super(key: key);

  @override
  State<EnableBioMetricSwitch> createState() => _EnableBioMetricSwitchState();
}

class _EnableBioMetricSwitchState extends State<EnableBioMetricSwitch> {
  @override
  void initState() {
    context
        .read<EnableBiometricSwitchCubit>()
        .checkIfEnabled(); // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnableBiometricSwitchCubit, EnableBiometricSwitchState>(
      builder: (context, state) {
        if (state is EnableBiometricSwitchLoading) {
          return const SizedBox.shrink();
        } else {
          return CupertinoSwitch(
            activeColor: kgreen,
            value: state is EnableBiometricSwitchIsSelected,
            onChanged: (v) {
              context
                  .read<EnableBiometricSwitchCubit>()
                  .enableBioMetrics(selection: v);
            },
          );
        }
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/footer_single_button.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/wedge_app_bar.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/presentation/pages/add_beneficiary_screen.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/presentation/cubit/beneficiary_main_cubit.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/presentation/cubit/trusted_main_cubit.dart';
import 'package:wedge/features/beneficiary/trusted_add/presentation/pages/add_trusted_member_screen.dart';

import '../../../../../core/widgets/dialog/wedge_comfirm_dialog.dart';

class BeneficiaryMainScreen extends StatefulWidget {
  BeneficiaryMainScreen({Key? key}) : super(key: key);

  @override
  State<BeneficiaryMainScreen> createState() => _BeneficiaryMainScreenState();
}

class _BeneficiaryMainScreenState extends State<BeneficiaryMainScreen> {
  AppLocalizations? translate;
  bool isPrivacyModeOn = false;
  bool value = false;

  @override
  void initState() {
    if (locator<SharedPreferences>()
        .containsKey(RootApplicationAccess.privacyModePreferences)) {
      isPrivacyModeOn = locator<SharedPreferences>()
              .getBool(RootApplicationAccess.privacyModePreferences) ??
          false;
    }
    getBeneficiaryMembers();
    getTrsutedMembers();
    super.initState();
  }

  changePrivacyMode(bool value) {
    locator<SharedPreferences>()
        .setBool(RootApplicationAccess.privacyModePreferences, value);
    setState(() {
      isPrivacyModeOn = value;
    });
  }

  getBeneficiaryMembers() {
    context.read<BeneficiaryMainCubit>().getBeneficiary();
  }

  getTrsutedMembers() {
    context.read<TrustedMainCubit>().getTrustedDetails();
  }

  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: WedgeAppBar(
        heading: translate!.beneficiary,
      ),
      bottomNavigationBar: FooterButton(
        text: translate!.backToHome,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      translate!.beneficiary,
                      style: TitleHelper.h9,
                    ),
                    const Spacer(),
                    Text(
                      "${translate!.privacyMode}  ${isPrivacyModeOn ? translate!.on : translate!.off}",
                      style: SubtitleHelper.h11,
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: darken(appThemeColors!.textLight!,
                            .5), // **INACTIVE STATE COLOR**
                        activeColor: lighten(appThemeColors!.primary!,
                            0.2), // **ACTIVE STATE COLOR**
                        value: isPrivacyModeOn,
                        onChanged: (bool value) {
                          changePrivacyMode(value);
                        },
                      ),
                    )
                  ],
                ),
                BlocConsumer<BeneficiaryMainCubit, BeneficiaryMainState>(
                  listener: (context, state) {
                    if (state is BeneficiaryMainLoaded) {
                      if (state.isDeleted) {
                        showSnackBar(
                            context: context,
                            title: translate!
                                .detailsDeleted(translate!.beneficiary));
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is BeneficiaryMainLoading) {
                      return Center(
                        child: buildCircularProgressIndicator(width: 20),
                      );
                    } else if (state is BeneficiaryMainLoaded) {
                      return state.beneficiaryMembersEntity.isEmpty
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                addMoreButton(
                                    onTap: () {
                                      // print(context
                                      //     .read<TrustedMainCubit>()
                                      //     .trustedMembersEntity
                                      //     .name);
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddBeneficiaryScreen(
                                                    beneficiaryMembersEntity: state
                                                        .beneficiaryMembersEntity,
                                                    trustedMembersEntity: context
                                                        .read<
                                                            TrustedMainCubit>()
                                                        .trustedMembersEntity,
                                                  ))).then((value) {
                                        // getBeneficiaryMembers();
                                      });
                                    },
                                    title: translate!.beneficiary)
                              ],
                            )
                          : getUserDetials(
                              context: context,
                              userName: isPrivacyModeOn
                                  ? "XXXXXXXXXXX"
                                  : state.beneficiaryMembersEntity.name,
                              mailId: isPrivacyModeOn
                                  ? "XXXXXXXXX@XXXXX.com"
                                  : state.beneficiaryMembersEntity.email,
                              mobileNumber: isPrivacyModeOn
                                  ? "+XXX XXXXXXXXXXX"
                                  : "${state.beneficiaryMembersEntity.countryCode} ${state.beneficiaryMembersEntity.contactNumber}",
                              description: translate!.beneficiaryMemberContactTime(
                                  "${state.beneficiaryMembersEntity.inactivityThresholdDays}",
                                  isPrivacyModeOn
                                      ? "XXXXXXX"
                                      : state.beneficiaryMembersEntity.name),
                              onPress: isDeleting
                                  ? (_) {}
                                  : (_) {
                                      if (_ == 1) {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        AddBeneficiaryScreen(
                                                          beneficiaryMembersEntity:
                                                              state
                                                                  .beneficiaryMembersEntity,
                                                        ))).then((value) {
                                          // if (value != null) {
                                          // getBeneficiaryMembers();
                                          // }
                                        });
                                      } else {
                                        locator.get<WedgeDialog>().confirm(
                                            context,
                                            WedgeConfirmDialog(
                                              title: translate!.areYouSure,
                                              subtitle: translate!
                                                  .deletedConfirmMsg(
                                                      translate!.beneficiary),
                                              deniedPress: () {
                                                Navigator.pop(context);
                                              },
                                              deniedText: translate!
                                                  .noKeepBeneficiary(
                                                      translate!.beneficiary),
                                              acceptText:
                                                  translate!.yesRemoveNow,
                                              acceptedPress: () {
                                                setState(() {
                                                  isDeleting = true;
                                                });
                                                context
                                                    .read<
                                                        BeneficiaryMainCubit>()
                                                    .deleteBeneficiary(state
                                                        .beneficiaryMembersEntity
                                                        .id);
                                                Navigator.pop(context);
                                                setState(() {
                                                  isDeleting = false;
                                                });
                                              },
                                            ));
                                      }
                                    });
                    } else if (state is BeneficiaryMainError) {
                      return Center(
                        child: Text(
                          state.errorMsg,
                          style: SubtitleHelper.h10,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  translate!.trustedMember,
                  style: TitleHelper.h9,
                ),
                BlocConsumer<TrustedMainCubit, TrustedMainState>(
                  listener: (context, state) {
                    if (state is TrustedMainLoaded) {
                      if (state.isDeleted) {
                        showSnackBar(
                            context: context,
                            title: translate!.detailsDeleted(
                                translate!.trustedMember.toLowerCase()));
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is TrustedMainLoading) {
                      return Center(
                        child: buildCircularProgressIndicator(width: 20),
                      );
                    } else if (state is TrustedMainLoaded) {
                      return state.trustedMembersEntity.isEmpty
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                addMoreButton(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddTrustedMemberScreen(
                                                    trustedMembersEntity: context
                                                        .read<
                                                            TrustedMainCubit>()
                                                        .trustedMembersEntity,
                                                  ))).then((value) {
                                        // getTrsutedMembers();
                                      });
                                    },
                                    title: translate!.trustedMember)
                              ],
                            )
                          : getUserDetials(
                              context: context,
                              userName: isPrivacyModeOn
                                  ? "XXXXXXXXXXX"
                                  : state.trustedMembersEntity.name,
                              mailId: isPrivacyModeOn
                                  ? "XXXXXXXXX@XXXXX.com"
                                  : state.trustedMembersEntity.email,
                              mobileNumber: isPrivacyModeOn
                                  ? "+XXX XXXXXXXXXXX"
                                  : "${state.trustedMembersEntity.countryCode} ${state.trustedMembersEntity.contactNumber}",
                              description: translate!.trustedMemberContactTime(
                                  isPrivacyModeOn
                                      ? "XXXXXXX"
                                      : state.trustedMembersEntity.name),
                              onPress: isDeleting
                                  ? (_) {}
                                  : (_) {
                                      if (_ == 1) {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        AddTrustedMemberScreen(
                                                          trustedMembersEntity: context
                                                              .read<
                                                                  TrustedMainCubit>()
                                                              .trustedMembersEntity,
                                                        ))).then((value) {
                                          // getTrsutedMembers();
                                        });
                                      } else {
                                        locator.get<WedgeDialog>().confirm(
                                            context,
                                            WedgeConfirmDialog(
                                              title: translate!.areYouSure,
                                              subtitle: translate!
                                                  .deletedConfirmMsg(
                                                      translate!.trustedMember),
                                              deniedText: translate!
                                                  .noKeepBeneficiary(
                                                      translate!.trustedMember),
                                              deniedPress: () {
                                                Navigator.pop(context);
                                              },
                                              acceptText:
                                                  translate!.yesRemoveNow,
                                              acceptedPress: () {
                                                setState(() {
                                                  isDeleting = true;
                                                });
                                                context
                                                    .read<TrustedMainCubit>()
                                                    .deleteTrustedDetails(state
                                                        .trustedMembersEntity
                                                        .id);
                                                Navigator.pop(context);
                                                setState(() {
                                                  isDeleting = false;
                                                });
                                              },
                                            ));
                                      }
                                    });
                    } else if (state is TrustedMainError) {
                      return Center(
                        child: Text(
                          state.errorMsg,
                          style: SubtitleHelper.h10,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            )),
      ),
    );
  }

  Align popUpItem(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 15,
        ),
        child: Text(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(color: appThemeColors!.outline),
        ),
      ),
    );
  }

  Widget getUserDetials(
      {required BuildContext context,
      required String userName,
      required String mailId,
      required String mobileNumber,
      required String description,
      required Function(int index) onPress}) {
    return Container(
      child: Column(
        children: [
          Divider(
            height: 40,
            color: appThemeColors!.disableDark,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.person,
                size: 25,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TitleHelper.h10,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    mailId,
                    style: SubtitleHelper.h11,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    mobileNumber,
                    style: SubtitleHelper.h11,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerTheme: const DividerThemeData(
                      color: Color(0xfffD6D6D6),
                    ),
                    iconTheme: const IconThemeData(color: Colors.black),
                    textTheme: const TextTheme().apply(bodyColor: Colors.black),
                  ),
                  child: PopupMenuButton<int>(
                    padding: const EdgeInsets.only(left: 15),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    onSelected: (_) {
                      onPress(_);
                    },
                    icon: const Icon(Icons.more_vert),
                    color: Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        height: 36,
                        child: popUpItem(
                          translate!.edit,
                        ),
                        value: 1,
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        height: 36,
                        child: popUpItem(
                          translate!.delete,
                        ),
                        value: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            description,
            style: SubtitleHelper.h11.copyWith(height: 1.5),
          ),
          Divider(
            height: 50,
            color: appThemeColors!.disableDark,
          ),
        ],
      ),
    );
  }

  Container addMoreButton({required Function onTap, required String title}) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            translate!.noDataAvai,
            style: TextHelper.h5,
          ),
          GestureDetector(
            onTap: () {
              onTap();
            },
            child: Text(
              translate!.add + " " + title,
              style: TextHelper.h5.copyWith(color: appThemeColors!.outline),
            ),
          ),
        ],
      ),
    );
  }
}

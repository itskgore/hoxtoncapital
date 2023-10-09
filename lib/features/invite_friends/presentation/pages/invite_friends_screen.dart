// import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:custom_social_share/custom_social_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/contants/theme_contants.dart';
import '../../../../core/utils/wedge_app_bar.dart';
import '../../../../core/utils/wedge_circular_progress_indicator.dart';
import '../../../../core/utils/wedge_func_methods.dart';
import '../../../../core/utils/wedge_snackBar.dart';
import '../../../../dependency_injection.dart';
import '../cubit/invite_friends_cubit.dart';
import '../cubit/invite_friends_state.dart';
import '../widget/copy_link_button.dart';
import '../widget/widget_share_button.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({Key? key}) : super(key: key);

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  final ValueNotifier<String> username = ValueNotifier<String>("Loading...");
  String link =
      "https://play.google.com/store/apps/details?id=com.hoxtoncapital.hoxtoncapital";

  @override
  void initState() {
    // TODO: implement initState
    context.read<InviteFriendsCubit>().getInviteFriendsData();
    super.initState();
  }

  void launchWhatsapp({var translate, required String text}) async {
    var whatsappUrl = "whatsapp://send?text=${Uri.encodeFull(text)}";
    if (await canLaunchUrlString(whatsappUrl)) {
      await launchUrlString(whatsappUrl);
    } else {
      showSnackBar(
          context: context,
          title: "${translate.whatsapp} ${translate.notInstalled}");
    }
  }

  void launchFacebook({var translate, required String text}) async {
    var messengerUrl = "fb-messenger://";
    if (await canLaunchUrlString(messengerUrl)) {
      CustomSocialShare().to(ShareWith.facebookMessenger, text);
    } else {
      showSnackBar(
          context: context,
          title:
              "${translate.facebook} ${translate.messenger} ${translate.notInstalled}");
    }
  }

  void launchInstagram({var translate, required String text}) async {
    var instagramUrl = "instagram://user?username=instagram";
    if (await canLaunchUrlString(instagramUrl)) {
      await CustomSocialShare().to(ShareWith.instagram, text);
    } else {
      // Instagram app cannot be launched
      showSnackBar(
          context: context,
          title: "${translate.instagram} ${translate.notInstalled}");
    }
  }

  String inviteFriendsMsg({required String inviteLink}) {
    String link = inviteLink;

    String? userFullName = locator<SharedPreferences>()
        .getString(RootApplicationAccess.usernameFullNamePreferences);

    String inviteMessage =
        "${translate!.inviteFriendsMag}\n$link\n \n${translate!.love},\n$userFullName";

    return inviteMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
        context: context,
        title: translate!.inviteFriends,
      ),
      body: ValueListenableBuilder<String>(
          valueListenable: username,
          builder: (context, userNameValue, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * .04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      translate!.spreadTheLoveAndBuildWealthTogether,
                      style: SubtitleHelper.h11.copyWith(color: Colors.black54),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .01,
                  ),
                  BlocConsumer<InviteFriendsCubit, InviteFriendsState>(
                    listener: (context, state) {
                      if (state is InviteFriendsLoadedState) {
                        String url = state.inviteFriends.referralUrl!;
                        List<String> parts = url.split('/');
                        username.value = parts.last;
                        username.notifyListeners();
                      }
                    },
                    builder: (context, state) {
                      if (state is InviteFriendsLoadingState) {
                        return Center(
                            child: buildCircularProgressIndicator(width: 200));
                      } else if (state is InviteFriendsErrorState) {
                        showSnackBar(context: context, title: state.error);
                      } else if (state is InviteFriendsLoadedState) {
                        return Container(
                          height: size.height * .35,
                          width: size.width,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate!.startInviting,
                                  style: TitleHelper.h9.copyWith(
                                      color: appThemeColors!
                                          .loginColorTheme!.textTitleColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  translate!
                                      .youCanStartInvitingYourLovedOnesBySharingTheLink,
                                  style: SubtitleHelper.h11.copyWith(
                                      color: appThemeColors!
                                          .loginColorTheme!.textTitleColor),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CopyLinkButton(
                                          linkToCopy: inviteFriendsMsg(
                                              inviteLink: state.inviteFriends
                                                      .referralUrl ??
                                                  link),
                                          userName: userNameValue),
                                    ),
                                    SizedBox(width: size.width * .02),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        primary: appThemeColors!
                                            .loginColorTheme!.textTitleColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                      ),
                                      label: Text(translate!.share,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      icon: const Icon(Icons.share_outlined,
                                          size: 18, color: Colors.white),
                                      onPressed: () async {
                                        await Share.share(
                                            subject:
                                                "${appTheme.clientName} App",
                                            inviteFriendsMsg(
                                                inviteLink: state.inviteFriends
                                                        .referralUrl ??
                                                    link));
                                      },
                                    )
                                  ],
                                ),
                                FittedBox(
                                  child: Wrap(
                                    spacing: 8,
                                    children: [
                                      widgetShareButton(
                                        icon: FontAwesomeIcons.whatsapp,
                                        iconColor: Colors.green,
                                        label: translate!.whatsapp,
                                        onPressed: () {
                                          launchWhatsapp(
                                              translate: translate,
                                              text: inviteFriendsMsg(
                                                  inviteLink: state
                                                          .inviteFriends
                                                          .referralUrl ??
                                                      link));
                                        },
                                      ),
                                      widgetShareButton(
                                        icon: FontAwesomeIcons.instagram,
                                        iconColor: Colors.pinkAccent,
                                        label: translate!.instagram,
                                        onPressed: () {
                                          launchInstagram(
                                              translate: translate,
                                              text: inviteFriendsMsg(
                                                  inviteLink: state
                                                          .inviteFriends
                                                          .referralUrl ??
                                                      link));
                                        },
                                      ),
                                      widgetShareButton(
                                        icon: Icons.facebook_outlined,
                                        iconColor: Colors.blue,
                                        label: translate!.facebook,
                                        onPressed: () {
                                          launchFacebook(
                                              translate: translate,
                                              text: inviteFriendsMsg(
                                                  inviteLink: state
                                                          .inviteFriends
                                                          .referralUrl ??
                                                      link));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}

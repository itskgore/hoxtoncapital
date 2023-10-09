import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/bottom_button_widget.dart';
import 'package:wedge/features/auth/terms_and_condition/presentation/cubit/terms_and_conditions_cubit.dart';

class TermsConditionPage extends StatefulWidget {
  Widget? page;
  final String displayUrl;
  bool? hideAcceptButton;

  TermsConditionPage(
      {Key? key, this.page, this.hideAcceptButton, required this.displayUrl})
      : super(key: key);

  @override
  _TermsConditionPageState createState() => _TermsConditionPageState();
}

class _TermsConditionPageState extends State<TermsConditionPage> {
  TermsAndConditionsCubit getCubit() => context.read<TermsAndConditionsCubit>();

  navigateToHome() async {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (BuildContext context) => widget.page!),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    BlocProvider.of<TermsAndConditionsCubit>(context, listen: false)
        .emit(TermsAndConditionsInitial());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var style2 = Style(
        fontFamily: 'Roboto',
        fontSize: FontSize(17),
        lineHeight: LineHeight.em(1.6),
        whiteSpace: WhiteSpace.normal);
    return Scaffold(
      bottomSheet: widget.hideAcceptButton ?? false
          ? const SizedBox.shrink()
          : BlocConsumer<TermsAndConditionsCubit, TermsAndConditionsState>(
              listener: (context, state) {
                if (state is TermsAndConditionsError) {
                  showSnackBar(context: context, title: state.errorMsg);
                } else if (state is TermsAndConditionsLoaded) {
                  navigateToHome();
                }
              },
              builder: (context, state) {
                if (state is TermsAndConditionsLoading ||
                    state is TermsAndConditionsLoaded) {
                  return SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: buildCircularProgressIndicator(),
                  );
                } else {
                  return SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: WedgeButton(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 20, bottom: 25, right: 10),
                              buttonColor: appThemeColors!.disableDark,
                              textColor: appThemeColors!.textDark,
                              text: "Reject",
                              onPressed: () {
                                getCubit().rejectTermCondition();
                              }),
                        ),
                        Expanded(
                          flex: 2,
                          child: WedgeButton(
                              textColor: appThemeColors!.textLight,
                              buttonColor: appThemeColors!.primary,
                              padding: const EdgeInsets.only(
                                  left: 5, top: 20, bottom: 25, right: 20),
                              text: "Accept",
                              onPressed: () {
                                getCubit().acceptTermCondition();
                              }),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
      body: SafeArea(
        bottom: !Platform.isIOS,
        child: SingleChildScrollView(
          physics: const ScrollPhysics(parent: ClampingScrollPhysics()),
          child: Column(children: [
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/TCBG.png",
                    fit: BoxFit.cover,
                  ),
                ),
                widget.hideAcceptButton ?? false
                    ? Positioned(
                        top: 10,
                        left: 10,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black26,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.chevron_left,
                                size: 32,
                              )),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            Container(
              width: double.infinity,
              color: const Color(0xfffDF7659),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                // padding: EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Column(children: [
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Html(
                      data: widget.displayUrl,
                      style: {
                        "p": style2,
                        "div": style2,
                        "h2": style2.copyWith(fontSize: FontSize(20)),
                        "h6": style2,
                        "a": style2,
                        "li": style2,
                        "ol":
                            style2.copyWith(listStyleType: ListStyleType.none),
                        "ul":
                            style2.copyWith(listStyleType: ListStyleType.none),
                      },
                      onLinkTap: (url, attributes, element) {
                        launchUrl(Uri.parse(url ?? ""));
                      },
                      onCssParseError: (css, messages) {
                        log("css that error: $css");
                        log("error messages:");
                        for (var element in messages) {
                          log("$element");
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

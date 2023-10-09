import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_view_indicators/step_page_indicator.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/screens/tour/widgets/tour_container_widget.dart';

import '../../../features/auth/signup/presentaion/pages/signup_screen.dart';
import '../../utils/wedge_func_methods.dart';
import '../../widgets/buttons/app_button.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //controls the actions of pageview
  final _pageController = PageController(initialPage: 0);

  //get the page value to indicate the current page in pageindicator
  final _currentPageNotifier = ValueNotifier<int>(0);

  final Duration _autoScrollDuration = Duration(seconds: 4);

  // Create a Timer to handle auto-scrolling
  Timer? _timer;

  final int _numPages = 6;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Start the auto-scrolling
    startAutoScroll();
  }

  // Method to start the auto-scrolling
  void startAutoScroll() {
    _timer = Timer.periodic(_autoScrollDuration, (Timer timer) {
      // Calculate the next page index
      int nextPage = (_pageController.page?.toInt() ?? 0) + 1;

      // // Check if the next page index exceeds the total number of pages
      // if (nextPage >= _numPages) {
      //   nextPage = 0;
      // }

      // Animate to the next page
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(seconds: 1),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    // Dispose of the PageController and Timer to prevent memory leaks
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translate = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * .08,
                ),
                Image.asset(
                  appTheme.appImage!.appLogoDark!,
                  height: size.height * .09,
                ),
                SizedBox(
                  height: size.height * .6,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (value) {
                      _currentPageNotifier.value = value;
                      _currentPage = value;
                    },
                    children: <Widget>[
                      TourContainer(
                        personImage: "1",
                        tourText: translate!.onboardingMessage1,
                      ),
                      TourContainer(
                        personImage: "2",
                        tourText: translate.onboardingMessage2,
                      ),
                      TourContainer(
                        personImage: "3",
                        tourText: translate.onboardingMessage3,
                      ),
                      TourContainer(
                        personImage: "4",
                        tourText: translate.onboardingMessage4,
                      ),
                      TourContainer(
                        personImage: "5",
                        tourText: translate.onboardingMessage5,
                      ),
                      TourContainer(
                        personImage: "6",
                        tourText: translate.onboardingMessage6,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * .5,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: StepPageIndicator(
                              itemCount: _numPages,
                              currentPageNotifier: _currentPageNotifier,
                              selectedStep: pageIndicatorDots(
                                  indicatorColor: appThemeColors!.primary),
                              nextStep: pageIndicatorDots(),
                              previousStep: pageIndicatorDots(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              onTap: () {
                                RootApplicationAccess()
                                    .navigateToLogin(context);
                              },
                              label: "Log in",
                              verticalPadding: 12,
                              horizontalPadding: 50,
                              borderRadius: 8,
                              color: Colors.white,
                              style: SubtitleHelper.h11.copyWith(
                                  color: appThemeColors!.primary,
                                  fontWeight: FontWeight.w500),
                              border:
                                  Border.all(color: appThemeColors!.primary!),
                            ),
                            SizedBox(
                              width: size.height * .02,
                            ),
                            AppButton(
                              onTap: () {
                                cupertinoNavigator(
                                    context: context,
                                    screenName: const SignUpScreen(),
                                    type: NavigatorType.PUSHREPLACE);
                              },
                              label: "Sign up",
                              style: SubtitleHelper.h11.copyWith(
                                  color: appThemeColors!.textLight,
                                  fontWeight: FontWeight.w500),
                              verticalPadding: 13,
                              horizontalPadding: 50,
                              borderRadius: 8,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Page Indicator Dots UI
  Widget pageIndicatorDots({Color? indicatorColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.2),
      height: 2,
      width: 35,
      color: indicatorColor ?? Colors.black12,
    );
  }
}

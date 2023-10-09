import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';

import '../../../../../core/contants/theme_contants.dart';
import '../../../../../core/utils/wedge_app_bar.dart';
import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../core/widgets/buttons/wedge_button.dart';
import '../../../../all_accounts_types/presentation/pages/all_account_types.dart';
import '../Widget/custom_stepper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: wedgeAppBar(
          context: context, backgroundColor: Colors.white, title: ""),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(
            parent:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics())),
        child: Container(
          height: size.height * .88,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                appTheme.appImage!.appLogoDark!,
                height: size.height * .085,
              ),
              SizedBox(height: size.height * .03),
              customBanner(),
              SizedBox(height: size.height * .02),
              const CustomStepper(),
              SizedBox(height: size.height * .01),
              Image.asset(
                "assets/images/welcome_assets.png",
                height:
                    size.height < 600 ? size.height * .25 : size.height * .3,
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * .02),
                child: submitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //banner
  Widget customBanner() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hooray! You’re now onboarded", style: TitleHelper.h8),
            const SizedBox(height: 8),
            Text(
                "We’ll guide you through the steps to maximise the app’s capabilities ",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: SubtitleHelper.h11.copyWith(color: Colors.black))
          ],
        ),
      )
    ]);
  }

  //Submit Button
  Widget submitButton() {
    return SizedBox(
        height: 45,
        width: size.width,
        child: WedgeSaveButton(
            onPressed: () {
              // locator<SharedPreferences>()
              //     .setBool("isAssetLiabiltyAdded", false);
              cupertinoNavigator(
                  context: context,
                  screenName: AddBankAccountPage(
                    title: '',
                    subtitle: translate!.selectAnyAsset,
                    placeholder: translate!.searchBankInvestmentOrPension,
                    manualAddButtonTitle:
                        translate!.addAssetsLiabilitiesManually,
                    manualAddButtonAction: () async {
                      final data = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  const AllAccountTypes()));
                      if (data != null && mounted) {
                        setState(() {});
                      }
                    },
                    successPopUp: (_, {required String source}) {},
                    isAppBar: false,
                  ),
                  type: NavigatorType.PUSH);
            },
            textStyle: SubtitleHelper.h10.copyWith(color: Colors.white),
            title: translate!.getStarted,
            // getStarted
            isEnable: true,
            isLoaing: false));
  }
}

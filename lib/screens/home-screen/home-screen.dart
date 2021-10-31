import 'package:flutter/material.dart';
import 'package:hoxtoncapital/navigators/animated-navigators.dart';
import 'package:hoxtoncapital/screens/home-screen/components/top-users.dart';
import 'package:hoxtoncapital/screens/saved-cards/savedCards.dart';
import 'package:hoxtoncapital/utils/asset_helper.dart';
import 'package:hoxtoncapital/utils/constants.dart';
import 'package:hoxtoncapital/utils/text_helper.dart';
import 'package:hoxtoncapital/widgets/generic_text.dart';
import 'package:hoxtoncapital/widgets/title_more.dart';
import 'package:hoxtoncapital/widgets/transaction_data.dart';

import 'components/header.dart';
import 'components/line-chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SafeArea(
          top: false,
          bottom: !isIOS(),
          child: CustomScrollView(
            slivers: [
              SliverHeader(),
              SliverList(
                  delegate: SliverChildListDelegate([
                buildHeightBox(context, 0.04),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleMore(onMorePressed: () {}, title: "Performance Chart"),
                    buildHeightBox(context, 0.03),
                    SpLineChart(),
                    buildHeightBox(context, 0.06),
                    TopUsers(),
                    TitleMore(
                        onMorePressed: () {
                          Navigator.of(context)
                              .push(FadeNavigation(widget: SavedCards()));
                        },
                        title: "Recent Transactions"),
                    buildHeightBox(context, 0.02),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: List.generate(5, (index) {
                          return Container(
                            margin: EdgeInsets.only(top: index == 0 ? 0 : 20),
                            child: Row(
                              children: [
                                Image.asset(
                                  AssetHelper.userDefualt,
                                  width: 45,
                                ),
                                buildWidthBoxNormal(context, 15),
                                TransactionData(
                                  subTitle: "United Kingdom",
                                  title: "John Doe",
                                ),
                                Spacer(),
                                TransactionData(
                                  icon: index == 0
                                      ? AssetHelper.inProgress
                                      : AssetHelper.checkCircle,
                                  subTitle: "80,000 AED",
                                  title: "11 Aug 2021",
                                )
                                // buildWidthBoxNormal(context, 15),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    buildHeightBox(context, 0.06),
                    TitleMore(title: "Financial Goals"),
                    buildHeightBox(context, 0.03),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: List.generate(3, (index) {
                          var data = [
                            Color(0xff147AD6),
                            Color(0xffEC6666),
                            Color(0xff79D2DE),
                          ];
                          double value = double.parse("0.${(index + 3)}");
                          return Container(
                            margin: EdgeInsets.only(top: index == 0 ? 0 : 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GenericText(
                                  title: "XX of total XX",
                                  textStyle: TextHelper.h4
                                      .copyWith(color: theme.primaryColorDark),
                                ),
                                buildHeightBoxNormal(context, 15),
                                LinearProgressIndicator(
                                  value: value,
                                  color: data[index],
                                  backgroundColor: theme.primaryColorLight,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    buildHeightBox(context, 0.08),
                  ],
                )
              ])),
            ],
          ),
        ));
  }
}

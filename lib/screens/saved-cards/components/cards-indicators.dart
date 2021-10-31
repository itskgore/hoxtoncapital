import 'package:flutter/material.dart';
import 'package:hoxtoncapital/models/user_cards_data.dart';
import 'package:hoxtoncapital/providers/saved-cards-pro.dart';
import 'package:hoxtoncapital/utils/asset_helper.dart';
import 'package:hoxtoncapital/utils/constants.dart';
import 'package:hoxtoncapital/utils/text_helper.dart';
import 'package:hoxtoncapital/widgets/generic_text.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CardsIndicators extends StatefulWidget {
  const CardsIndicators({Key key}) : super(key: key);

  @override
  _CardsIndicatorsState createState() => _CardsIndicatorsState();
}

class _CardsIndicatorsState extends State<CardsIndicators> {
  Future<void> getUserCards(BuildContext context) async {
    final pro = Provider.of<SavedCardsProvider>(context, listen: false);
    if (pro.userCardsData.isEmpty) {
      await Future.delayed(Duration(seconds: 1), () {});
      SavedCardsProvider.of(context).getUserCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
        future: getUserCards(context),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Column(
                  children: [
                    buildShimmerContainer(
                      theme,
                      context,
                    ),
                    buildHeightBox(
                      context,
                      0.02,
                    ),
                    Shimmer.fromColors(
                      baseColor: theme.buttonColor,
                      highlightColor: theme.primaryColorLight,
                      child: Container(
                        width: 25,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              : SavedCardsProvider.of(context).userCardsData.isEmpty
                  ? Container()
                  : Column(
                      children: [
                        buildHeightBox(context, 0.01),
                        Selector<SavedCardsProvider, List<UserCardsData>>(
                            selector: (con, selector) => selector.userCardsData,
                            builder: (context, cards, _) {
                              return Container(
                                height: 220,
                                child: PageView.builder(
                                    onPageChanged: (index) {
                                      SavedCardsProvider.of(context)
                                          .changeCarouselIndicator(index);
                                    },
                                    itemCount: cards.length,
                                    itemBuilder: (con, index) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: cards[index].gradient),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image.asset(
                                                  AssetHelper.chip,
                                                  width: 80,
                                                ),
                                                Image.asset(
                                                  AssetHelper.visa,
                                                  width: 80,
                                                ),
                                              ],
                                            ),
                                            buildHeightBoxNormal(context, 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: List.generate(
                                                  cards[index]
                                                      .cardNumber
                                                      .length,
                                                  (i) => GenericText(
                                                        title:
                                                            "${cards[index].cardNumber[i]}",
                                                        textStyle: TextHelper.h3
                                                            .copyWith(
                                                                color: theme
                                                                    .primaryColor),
                                                      )),
                                            ),
                                            Spacer(),
                                            // buildHeightBoxNormal(
                                            //     context, 30),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GenericText(
                                                        title: "CARD",
                                                        textStyle: TextHelper.h6
                                                            .copyWith(
                                                                fontSize: 10)
                                                            .copyWith(
                                                                color: theme
                                                                    .primaryColor),
                                                      ),
                                                      buildHeightBoxNormal(
                                                          context, 3),
                                                      GenericText(
                                                        title:
                                                            "${cards[index].cardId}",
                                                        textStyle: TextHelper.h3
                                                            .copyWith(
                                                                color: theme
                                                                    .primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GenericText(
                                                        title: "EXPIRE",
                                                        textStyle: TextHelper.h6
                                                            .copyWith(
                                                                fontSize: 10)
                                                            .copyWith(
                                                                color: theme
                                                                    .primaryColor),
                                                      ),
                                                      buildHeightBoxNormal(
                                                          context, 3),
                                                      GenericText(
                                                        title:
                                                            "${cards[index].cardExp}",
                                                        textStyle: TextHelper.h3
                                                            .copyWith(
                                                                color: theme
                                                                    .primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            buildHeightBoxNormal(context, 25),
                                          ],
                                        ),
                                      );
                                    },
                                    controller: PageController(
                                      viewportFraction: 0.9,
                                      initialPage:
                                          SavedCardsProvider.of(context)
                                                  .currentView ??
                                              0,
                                    )),
                              );
                            }),
                        buildHeightBox(
                          context,
                          0.02,
                        ),
                        Selector<SavedCardsProvider, int>(
                            selector: (con, selector) => selector.currentView,
                            builder: (context, count, _) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    SavedCardsProvider.of(context)
                                        .userCardsData
                                        .length, (index) {
                                  return AnimatedContainer(
                                    margin: EdgeInsets.only(right: 2),
                                    width: count == index ? 25 : 15,
                                    height: 8,
                                    duration: Duration(milliseconds: 400),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: count == index
                                          ? Colors.black
                                          : theme.buttonColor,
                                    ),
                                  );
                                }),
                                // children: [

                                // ],
                              );
                            }),
                      ],
                    );
        });
  }
}

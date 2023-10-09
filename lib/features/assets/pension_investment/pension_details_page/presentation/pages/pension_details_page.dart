import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_view_indicators/animated_circle_page_indicator.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class PensionDetailsPage extends StatefulWidget {
  PensionDetailsPage({Key? key}) : super(key: key);

  @override
  _PensionDetailsPageState createState() => _PensionDetailsPageState();
}

class _PensionDetailsPageState extends State<PensionDetailsPage> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  List<bool> isSelected = [true, false];

  AppLocalizations? translate;

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: Text("${translate!.add} ${translate!.pensions}"),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
        ),
        body: Padding(
          padding: const EdgeInsets.all(kpadding),
          child: ListView(
            children: [
              Container(
                height: 170,
                child: PageView.builder(
                    onPageChanged: (value) {
                      _currentPageNotifier.value = value;
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, index) {
                      return _mainCard();
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: AnimatedCirclePageIndicator(
                  itemCount: 3,
                  currentPageNotifier: _currentPageNotifier,
                  borderWidth: 0,
                  spacing: 6,
                  radius: 5,
                  activeRadius: 4,
                  fillColor: appThemeColors!.primary!,
                  activeColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  height: 40,
                  child: ToggleButtons(
                      fillColor: appThemeColors!.primary,
                      selectedColor: kfontColorLight,
                      textStyle: const TextStyle(color: kfontColorDark),
                      borderRadius: BorderRadius.circular(kborderRadius),
                      onPressed: (index) {
                        setState(() {
                          if (index == 0) {
                            isSelected = [true, false];
                          } else {
                            isSelected = [false, true];
                          }
                        });
                      },
                      isSelected: isSelected,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2.6,
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Center(child: Text("Performance")),
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2.6,
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Center(child: Text("Allocations")),
                            )),
                      ]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // isSelected[0] ? NetworthLineChart() : AssetsLiabilityPieChart(),
              const SizedBox(
                height: 20,
              ),
              _expTile("Total Collectives"),
              const SizedBox(
                height: 6,
              ),
              _expTile("Total Notes"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kborderRadius)),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "General Transactions Account",
                          style: TextStyle(
                              fontSize: kfontMedium,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "\$23000",
                          style: TextStyle(
                              fontSize: kfontMedium,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _mainCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kborderRadius),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xfff15534B),
                Color(0xfff11403A),
              ],
            )),
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RL360",
                    style: TextStyle(
                        fontSize: kfontLarge,
                        fontFamily: kSecondortfontFamily,
                        color: kfontColorLight),
                  ),
                  Text(
                    "NST6352891",
                    style: TextStyle(
                        fontSize: kfontLarge,
                        // fontFamily: kSecondortfontFamily,
                        color: kfontColorLight),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "\$1000",
                          style: TextStyle(
                              fontSize: kfontMedium,
                              fontFamily: kSecondortfontFamily,
                              color: kfontColorLight),
                        ),
                        Text(
                          "Initial Value",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              // fontFamily: kSecondortfontFamily,
                              color: kfontColorLight),
                        )
                      ],
                    ),
                  ),
                  VerticalDivider(
                    width: 3.0,
                    thickness: 0.5,
                    color: Colors.black38,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "\$1000",
                          style: TextStyle(
                              fontSize: kfontMedium,
                              fontFamily: kSecondortfontFamily,
                              color: kfontColorLight),
                        ),
                        Text(
                          "Current valuation ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              // fontFamily: kSecondortfontFamily,
                              color: kfontColorLight),
                        )
                      ],
                    ),
                  ),
                  VerticalDivider(
                    width: 3.0,
                    thickness: 0.5,
                    color: Colors.black38,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "40%",
                          style: TextStyle(
                              fontSize: kfontMedium,
                              fontFamily: kSecondortfontFamily,
                              color: kfontColorLight),
                        ),
                        Text(
                          "Growth",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              // fontFamily: kSecondortfontFamily,
                              color: kfontColorLight),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expTile(title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text(
                "\$662,380",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          // subtitle: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [Text(leftSubtitle), Text(rightSubtitle)],
          // ),
          children: [_expTileContent(), _expTileContent(), _expTileContent()],
        ),
      ),
    );
  }

  Widget _expTileContent() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("1",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: kfontMedium)),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "Fundsmith Equity Feeder Acc GBP ",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: kfontMedium),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("on FTSE 100 Index et al GBP 06/11/2024"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("ISIN - LU38297398092HG739"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: klightGrey,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Text("\$1000",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: kfontMedium)),
                        Text("Current Value",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: kfontSmall))
                      ]),
                      VerticalDivider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      Column(children: [
                        Text("23%",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: kfontMedium)),
                        Text("Allocation",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: kfontSmall))
                      ]),
                      VerticalDivider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      Column(children: [
                        Text("16%",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: kfontMedium)),
                        Text("Growth",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: kfontSmall))
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}

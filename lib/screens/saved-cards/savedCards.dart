import 'package:flutter/material.dart';
import 'package:hoxtoncapital/providers/performance-data-pro.dart';
import 'package:hoxtoncapital/providers/saved-cards-pro.dart';
import 'package:hoxtoncapital/utils/asset_helper.dart';
import 'package:hoxtoncapital/utils/constants.dart';
import 'package:hoxtoncapital/utils/text_helper.dart';
import 'package:hoxtoncapital/widgets/generic_text.dart';
import 'package:hoxtoncapital/widgets/transaction_data.dart';
import 'package:provider/provider.dart';

import 'components/cards-indicators.dart';

class SavedCards extends StatelessWidget {
  SavedCards({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back)),
        title: GenericText(
          title: "My saved cards",
          textStyle: TextHelper.h2,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                AssetHelper.menu,
                width: 15,
              ))
        ],
      ),
      body: Column(
        children: [
          CardsIndicators(),
          buildHeightBox(
            context,
            0.02,
          ),
          Expanded(
            child: Consumer<SavedCardsProvider>(builder: (context, pro, _) {
              final data = pro.data;
              return DefaultTabController(
                  length: pro.data.length, // length of tabs
                  initialIndex: 0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Stack(
                            fit: StackFit.passthrough,
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: theme.primaryColorDark,
                                        width: 1.0),
                                  ),
                                ),
                              ),
                              TabBar(
                                indicatorWeight: 4,
                                isScrollable: true,
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 35),
                                unselectedLabelColor: theme.primaryColorDark,
                                labelStyle: TextHelper.h5
                                    .copyWith(fontWeight: FontWeight.bold),
                                tabs: List.generate(pro.data.length, (index) {
                                  return Tab(
                                      text: 'Menu title ${data[index]['tab']}');
                                }),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              // height: 400, //height of TabBarView
                              decoration: BoxDecoration(border: Border()),
                              child: TabBarView(
                                  children: List.generate(data.length, (index) {
                                return ListView.builder(
                                    itemCount: 20,
                                    itemBuilder: (con, index) {
                                      return Container(
                                        margin:
                                            EdgeInsets.only(top: 20, right: 20),
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
                                    });
                              }))),
                        )
                      ]));
            }),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hoxtoncapital/models/top_community_user.dart';
import 'package:hoxtoncapital/providers/main-pro.dart';
import 'package:hoxtoncapital/utils/asset_helper.dart';
import 'package:hoxtoncapital/utils/constants.dart';
import 'package:hoxtoncapital/utils/text_helper.dart';
import 'package:hoxtoncapital/widgets/generic_text.dart';
import 'package:hoxtoncapital/widgets/title_more.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TopUsers extends StatefulWidget {
  const TopUsers({Key key}) : super(key: key);

  @override
  _TopUsersState createState() => _TopUsersState();
}

class _TopUsersState extends State<TopUsers> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> getTopUser() async {
    if (MainProvider.of(context).topUserComm.isEmpty) {
      await MainProvider.of(context).getTopUserCommData();
      // Intentionally done to show shimmer for a longer time.
      await Future.delayed(Duration(seconds: 2), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        FutureBuilder(
            future: getTopUser(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Shimmer.fromColors(
                            baseColor: theme.buttonColor,
                            highlightColor: theme.primaryColorLight,
                            child: Row(
                                children: List.generate(
                              10,
                              (index) => Container(
                                margin: EdgeInsets.only(
                                    left: 20,
                                    bottom:
                                        getHeightWidth(context, true) * 0.06),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.red,
                                    ),
                                    buildHeightBoxNormal(context, 10),
                                    Container(
                                      width: 40,
                                      color: Colors.grey,
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            )),
                          ),
                        ),
                      ],
                    )
                  : Selector<MainProvider, List<TopUserComm>>(
                      selector: (con, selector) => selector.topUserComm,
                      builder: (context, topUser, _) {
                        return topUser.isEmpty
                            ? Container()
                            : Column(
                                children: [
                                  TitleMore(
                                      onMorePressed: () {},
                                      title: "Top USERS FROM YOUR COMMUNITY"),
                                  buildHeightBox(context, 0.03),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: List.generate(10, (index) {
                                      return Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                                radius: 30,
                                                backgroundImage: AssetImage(
                                                    AssetHelper.topUser)),
                                            buildHeightBoxNormal(context, 10),
                                            GenericText(
                                              textStyle: TextHelper.h5,
                                              title: "${topUser[index].name}",
                                              align: TextAlign.center,
                                              textWidth: 70,
                                            )
                                          ],
                                        ),
                                      );
                                    })),
                                  ),
                                  buildHeightBox(context, 0.06),
                                ],
                              );
                      });
            }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hoxtoncapital/utils/asset_helper.dart';
import 'package:hoxtoncapital/utils/constants.dart';
import 'package:hoxtoncapital/utils/text_helper.dart';
import 'package:hoxtoncapital/widgets/generic_text.dart';

class SliverHeader extends StatelessWidget {
  const SliverHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50))),
      backgroundColor: theme.accentColor,
      pinned: true,
      title: Container(
        color: theme.accentColor,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GenericText(
                  textStyle: TextHelper.h3.copyWith(color: theme.primaryColor),
                  title: "Hola, Michael",
                ),
                SizedBox(
                  height: 5,
                ),
                GenericText(
                  textStyle: TextHelper.h7.copyWith(color: theme.primaryColor),
                  title: "Te tenemos excelentes noticias para ti",
                ),
              ],
            ),
            Spacer(),
            Image.asset(
              AssetHelper.bellIcon,
              width: 18,
            ),
            buildWidthBox(
              context,
              0.03,
            ),
            Image.asset(
              AssetHelper.userImage,
              width: 18,
            )
          ],
        ),
      ),
      expandedHeight: getHeightWidth(context, true) * 0.34,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          width: double.infinity,
          height: getHeightWidth(context, true) * 0.45,
          padding: EdgeInsets.symmetric(horizontal: 23),
          child: Column(
            children: [
              buildHeightBox(context, 0.08),
              buildHeightBox(context, 0.06),
              GenericText(
                align: TextAlign.center,
                textStyle: TextHelper.h1
                    .copyWith(fontSize: 34, color: theme.primaryColor),
                title: "\$56,271.68",
              ),
              buildHeightBox(context, 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenericText(
                    align: TextAlign.center,
                    textStyle:
                        TextHelper.h5.copyWith(color: theme.primaryColor),
                    title: "\$56,271.68",
                  ),
                  buildWidthBox(context, 0.02),
                  Icon(
                    Icons.arrow_upward,
                    color: theme.textTheme.caption.color,
                    size: 15,
                  ),
                  buildWidthBoxNormal(context, 5.0),
                  GenericText(
                    align: TextAlign.center,
                    textStyle: TextHelper.h5.copyWith(
                      color: theme.textTheme.caption.color,
                    ),
                    title: "2.3%",
                  ),
                ],
              ),
              buildHeightBoxNormal(context, 10.0),
              GenericText(
                align: TextAlign.center,
                textStyle: TextHelper.h6
                    .copyWith(color: theme.primaryColorDark, fontSize: 13),
                title: "Account balance".toUpperCase(),
              ),
              Spacer(),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildStatusColumn(theme, context,
                        subTitle: "Following", title: "12"),
                    buildVerticalDivider(theme),
                    buildStatusColumn(theme, context,
                        subTitle: "Transactions", title: "36"),
                    buildVerticalDivider(theme),
                    buildStatusColumn(theme, context,
                        subTitle: "Bills", title: "4"),
                  ],
                ),
              ),
              buildHeightBox(context, 0.04),
            ],
          ),
          decoration: BoxDecoration(
              color: theme.accentColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
        ),
      ),
    );
  }

  Container buildVerticalDivider(ThemeData theme) {
    return Container(
      height: 39,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: VerticalDivider(
        thickness: 1,
        color: theme.primaryColor,
        width: 1,
      ),
    );
  }

  Widget buildStatusColumn(ThemeData theme, BuildContext context,
      {@required String title, @required String subTitle}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GenericText(
            align: TextAlign.center,
            textStyle: TextHelper.h4.copyWith(
                color: theme.primaryColor, fontWeight: FontWeight.bold),
            title: "$title",
          ),
          buildHeightBoxNormal(context, 5.0),
          GenericText(
            align: TextAlign.center,
            textStyle: TextHelper.h6.copyWith(color: theme.primaryColorDark),
            title: "$subTitle",
          ),
        ],
      ),
    );
  }
}

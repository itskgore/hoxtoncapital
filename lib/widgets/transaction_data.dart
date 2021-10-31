import 'package:flutter/material.dart';
import 'package:hoxtoncapital/utils/constants.dart';
import 'package:hoxtoncapital/utils/text_helper.dart';
import 'package:hoxtoncapital/widgets/generic_text.dart';

class TransactionData extends StatelessWidget {
  final String title;
  final String subTitle;
  final String icon;
  TransactionData({
    Key key,
    this.title,
    this.subTitle,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GenericText(
              title: title,
              textStyle: TextHelper.h5.copyWith(fontSize: 14),
              textWidth: icon != null ? null : 100,
            ),
            icon != null
                ? Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Image.asset(
                      icon,
                      width: 15,
                    ),
                  )
                : Container()
          ],
        ),
        buildHeightBoxNormal(context, 5),
        GenericText(
          title: subTitle,
          textStyle: TextHelper.h6.copyWith(color: theme.primaryColorDark),
        ),
      ],
    );
  }
}

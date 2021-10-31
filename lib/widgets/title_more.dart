import 'package:flutter/material.dart';
import 'package:hoxtoncapital/utils/text_helper.dart';

import 'generic_text.dart';

class TitleMore extends StatelessWidget {
  final String title;
  final Function onMorePressed;
  const TitleMore({Key key, this.title, this.onMorePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GenericText(
            title: title.toUpperCase(),
            textStyle: TextHelper.h5.copyWith(fontWeight: FontWeight.bold),
          ),
          onMorePressed == null
              ? Container()
              : Container(
                  height: 30,
                  width: 70,
                  child: RaisedButton(
                    onPressed: onMorePressed,
                    child: GenericText(
                      textStyle: TextHelper.h6.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold),
                      title: "More".toUpperCase(),
                    ),
                    color: theme.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
        ],
      ),
    );
  }
}

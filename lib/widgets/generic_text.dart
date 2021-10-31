import 'package:flutter/material.dart';

class GenericText extends StatelessWidget {
  final String title;
  TextStyle textStyle;
  TextAlign align;
  double textWidth;
  GenericText({Key key, this.title, this.textStyle, this.align, this.textWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: textWidth ?? null,
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
        textAlign: align ?? TextAlign.start,
      ),
    );
  }
}

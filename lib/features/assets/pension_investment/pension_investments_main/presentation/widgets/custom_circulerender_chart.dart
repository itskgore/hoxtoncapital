import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'package:charts_flutter/src/text_style.dart' as chartsTextStyle;

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  static String? pValue;
  static String? xValue;

  @override
  CustomCircleSymbolRenderer.paint(
      charts.ChartCanvas canvas, Rectangle<num> bounds,
      {required List<int> dashPattern,
      required charts.FillPatternType fillPattern,
      required charts.Color fillColor,
      required charts.Color strokeColor,
      required double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: charts.Color.white,
        strokeColor: charts.Color.black,
        strokeWidthPx: 1);

    const num bubbleHeight = 40;
    const num bubbleWidth = 100;
    final num bubbleBoundLeft = bounds.left;
    final num bubbleBoundTop = bounds.top - bubbleHeight;
    canvas.drawRRect(
      Rectangle(bubbleBoundLeft, bubbleBoundTop, bubbleWidth, bubbleHeight),
      fill: charts.Color.black,
      stroke: charts.Color.black,
      radius: 10.0,
      roundTopLeft: true,
      roundBottomLeft: true,
      roundBottomRight: true,
      roundTopRight: true,
    );

    final textStyle = chartsTextStyle.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 12;

    final chartsTextElement.TextElement textElement =
        chartsTextElement.TextElement(
            pValue! + " GBP \n${xValue!.substring(0, 10)}".toString(),
            style: textStyle);

    final num textElementBoundsLeft = ((bounds.left +
            (bubbleWidth - textElement.measurement.horizontalSliceWidth) / 3))
        .round();
    final num textElementBoundsTop = (bounds.top - 30).round();

    canvas.drawText(textElement, int.parse(textElementBoundsLeft.toString()),
        int.parse(textElementBoundsTop.toString()));
  }
}

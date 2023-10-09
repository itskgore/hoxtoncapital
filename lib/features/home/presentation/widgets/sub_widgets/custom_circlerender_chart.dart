// // import 'dart:html';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'dart:convert';
// import 'dart:math';
// import "package:charts_flutter/src/chart_canvas.dart";
// import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
// import 'package:charts_flutter/src/text_style.dart' as chartsTextStyle;
// import 'package:flutter/material.dart';
// // import 'dart:html';

// class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
//   static String? pValue;
//   static String? xValue;
//   // CustomCircleSymbolRenderer(this.pointerValue);
//   // var x = "abbbc";
//   @override
//   void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
//       {List<int>? dashPattern,
//       charts.FillPatternType? fillPattern,
//       charts.Color? fillColor,
//       charts.Color? strokeColor,
//       double? strokeWidthPx}) {
//     super.paint(canvas, bounds,
//         dashPattern: dashPattern,
//         fillColor: charts.Color.white,
//         strokeColor: charts.Color.black,
//         strokeWidthPx: 1);

//     // Draw a bubble

//     final num bubbleHight = 40;
//     final num bubbleWidth = 100;
//     // final num bubbleRadius = bubbleHight / 1.0;
//     final num bubbleBoundLeft = bounds.left;
//     final num bubbleBoundTop = bounds.top - bubbleHight;
//     canvas.drawRRect(
//       Rectangle(bubbleBoundLeft, bubbleBoundTop, bubbleWidth, bubbleHight),
//       fill: charts.Color.black,
//       stroke: charts.Color.black,
//       radius: 10.0,
//       roundTopLeft: true,
//       roundBottomLeft: true,
//       roundBottomRight: true,
//       roundTopRight: true,
//     );

//     final textStyle = chartsTextStyle.TextStyle();
//     textStyle.color = charts.Color.white;
//     textStyle.fontSize = 12;

//     final chartsTextElement.TextElement textElement =
//         chartsTextElement.TextElement(
//             pValue.toString() + " GBP \n${xValue?.substring(0, 10)}".toString(),
//             style: textStyle);

//     final num textElementBoundsLeft = ((bounds.left +
//             (bubbleWidth - textElement.measurement.horizontalSliceWidth) / 3))
//         .round();
//     final num textElementBoundsTop = (bounds.top - 30).round();

//     canvas.drawText(textElement, int.parse(textElementBoundsLeft.toString()),
//         int.parse(textElementBoundsTop.toString()));
//   }
//   // void paint(ChartCanvas canvas, Rectangle<num> bounds,
//   //     {List<int> dashPattern,
//   //     Color fillColor,
//   //     Color strokeColor,
//   //     Size sizeWithOverflow,
//   //     double textScaleFactor, /*And the missing link I missed*/

//   //     /*The missing link*/

//   //     double strokeWidthPx}) {
//   //   super.paint(canvas, bounds,
//   //       dashPattern: dashPattern,

//   //       // fillColor: fillColor,
//   //       // strokeColor: strokeColor,
//   //       strokeWidthPx: strokeWidthPx);
//   //   canvas.drawRect(
//   //     Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
//   //         bounds.height + 10),
//   //   );

//   //   var textStyle = style.TextStyle();
//   //   //TextStyle(color: Colors.black, fontSize: 15);
//   //   // textStyle.color = Color.black;
//   //   textStyle.fontSize = 15;
//   //   textStyle.fontSize = 15;
//   //   canvas.drawText(TextElement("100", style: textStyle), (bounds.left).round(),
//   //       (bounds.top - 28).round());
//   // }
// }

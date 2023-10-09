// import 'dart:html';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class NetworthLineChart extends StatefulWidget {
  final List? chartData;

  NetworthLineChart({this.chartData});

  @override
  State<StatefulWidget> createState() => NetworthLineChartState();
}

class NetworthLineChartState extends State<NetworthLineChart> {
  late bool isShowingMainData;
  List<FlSpot> flSpotData = [];

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;

    for (int i = 0; i < widget.chartData!.length; i++) {
      flSpotData.add(FlSpot(double.parse(widget.chartData![i]![0].toString()),
          double.parse(widget.chartData![i][1].toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: LineChart(
                  sampleData1(),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          //  dotData: FlDotData(
          //         show: true,
          //         getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
          //           radius: 3,
          //           strokeWidth: 0,
          //           color: Color(0xFF147AD6),
          //         ),
          //         checkToShowDot: (spot, _) => spot.y == 300,
          //       ),
          // IconButton(
          //   icon: Icon(
          //     Icons.refresh,
          //     color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       isShowingMainData = !isShowingMainData;
          //     });
          //   },
          // )
        ],
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white,
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
          show: false, drawHorizontalLine: false, verticalInterval: null),
      // titlesData: FlTitlesData(
      //   bottomTitles: SideTitles(
      //     showTitles: true,
      //     reservedSize: 20,
      //     getTextStyles: (context, value) => const TextStyle(
      //       color: Colors.grey,
      //       // fontWeight: FontWeight.w600,
      //       fontSize: 12,
      //     ),
      //     margin: -30,
      //     // getTitles: (value) {
      //     //   // switch (value.toInt()) {
      //     //   //   case 1:
      //     //   //     return 'Jan';
      //     //   //   case 2:
      //     //   //     return 'Feb';
      //     //   //   case 3:
      //     //   //     return 'Mar';
      //     //   //   case 4:
      //     //   //     return 'Apr';
      //     //   //   case 5:
      //     //   //     return 'May';
      //     //   //   case 6:
      //     //   //     return 'Jun';
      //     //   //   case 7:
      //     //   //     return 'Jul';
      //     //   //   case 8:
      //     //   //     return 'Aug';
      //     //   //   case 9:
      //     //   //     return 'Sep';
      //     //   //   case 10:
      //     //   //     return 'Oct';
      //     //   //   case 11:
      //     //   //     return 'Nov';
      //     //   //   case 12:
      //     //   //     return 'Dec';
      //     //   // }
      //     //   return value.toString();
      //     // },
      //   ),
      //   leftTitles: SideTitles(
      //     showTitles: true,
      //     getTextStyles: (context, value) => const TextStyle(
      //       color: Colors.grey,
      //       // fontWeight: FontWeight.w600,
      //       fontSize: 12,
      //     ),
      //     getTitles: (value) {
      //       return value.toString();
      //       // switch (value.toInt()) {
      //       //   case 1:
      //       //     return '100';
      //       //   case 2:
      //       //     return '200';
      //       //   case 3:
      //       //     return '300';
      //       //   case 4:
      //       //     return '500';
      //       // }
      //       // return '';
      //     },
      //     margin: 12,
      //     reservedSize: 30,
      //   ),
      // ),
      borderData: FlBorderData(
        // show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.transparent,
            width: 0.2,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 1,
      maxX: 5,
      maxY: 300000,
      minY: 50000,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final lineChartBarData1 = LineChartBarData(
      spots: flSpotData,

      //  [
      //   FlSpot(1, 1),
      //   FlSpot(3, 1.5),
      //   FlSpot(5, 1.4),
      //   FlSpot(7, 3.4),
      //   FlSpot(10, 2),
      //   FlSpot(12, 2.2),
      //   FlSpot(13, 1.8),
      // ],
      isCurved: true,
      colors: [Color.fromRGBO(1, 186, 75, 0.37), Color(0xfff51AF86)],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
          radius: 3,
          strokeWidth: 0,
          color: Color(0xFF147AD6),
        ),
        checkToShowDot: (spot, _) => spot.y == 300,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: [Colors.blue],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 2.8),
        FlSpot(3, 1.9),
        FlSpot(6, 3),
        FlSpot(10, 1.3),
        FlSpot(13, 2.5),
      ],
      isCurved: true,
      colors: const [
        Color(0xff27b6fc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      // lineChartBarData2,
      // lineChartBarData3,
    ];
  }

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff72719b),
            // fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: kfontColorDark,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '100';
              case 2:
                return '200';
              case 3:
                return '300';
              case 4:
                return '500';
              case 5:
                return '600';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 14,
      maxY: 6,
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x444af699),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      // LineChartBarData(
      //   spots: [
      //     FlSpot(1, 1),
      //     FlSpot(3, 2.8),
      //     FlSpot(7, 1.2),
      //     FlSpot(10, 2.8),
      //     FlSpot(12, 2.6),
      //     FlSpot(13, 3.9),
      //   ],
      //   isCurved: true,
      //   colors: const [
      //     Color(0x99aa4cfc),
      //   ],
      //   barWidth: 4,
      //   isStrokeCapRound: true,
      //   dotData: FlDotData(
      //     show: false,
      //   ),
      //   belowBarData: BarAreaData(show: true, colors: [
      //     const Color(0x33aa4cfc),
      //   ]),
      // ),
      // LineChartBarData(
      //   spots: [
      //     FlSpot(1, 3.8),
      //     FlSpot(3, 1.9),
      //     FlSpot(6, 5),
      //     FlSpot(10, 3.3),
      //     FlSpot(13, 4.5),
      //   ],
      //   isCurved: true,
      //   curveSmoothness: 0,
      //   colors: const [
      //     Color(0x4427b6fc),
      //   ],
      //   barWidth: 2,
      //   isStrokeCapRound: true,
      //   dotData: FlDotData(show: true),
      //   belowBarData: BarAreaData(
      //     show: false,
      //   ),
      // ),
    ];
  }
}

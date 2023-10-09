import 'package:flutter/material.dart';

class RetirementCalculatorIndicators extends StatelessWidget {
  bool isFirst;
  List<Map<String, dynamic>> indicators;

  RetirementCalculatorIndicators(
      {Key? key, required this.isFirst, required this.indicators})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(
        //   height: 20,
        // ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                indicators.length,
                (index) => Row(
                      children: [
                        Container(
                          height: 5,
                          width: 40,
                          decoration: BoxDecoration(
                              color: indicators[index]['isSelected']
                                  ? Colors.black
                                  : const Color(0xfffEAEBE1),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ))),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}

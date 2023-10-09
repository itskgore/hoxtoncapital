import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class EmptyCreditcard extends StatelessWidget {
  final backgroundColor;

  const EmptyCreditcard({required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(252, 253, 201, 1),
                Color.fromRGBO(164, 207, 197, 0.18)
              ],
            ),
            //color: Color.fromRGBO(255, 238, 195, 0.33),
            borderRadius: BorderRadius.circular(20)),
        height: 200,
        width: 300,
        child: Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Your bank",
                          style: TextStyle(
                              fontSize: kfontMedium,
                              fontWeight: FontWeight.w600),
                        ),
                        // Text("7 July 1")
                      ],
                    ),
                    SizedBox(height: 20),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "GBP **********",
                          style: TextStyle(shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 0.0,
                              color: Colors.black,
                            ),
                            Shadow(
                                // offset: Offset(10.0, 10.0),
                                blurRadius: 0.0,
                                color: Colors.black),
                          ], fontWeight: FontWeight.w600),
                        )),
                    SizedBox(height: 20),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Account No. ******")),
                    SizedBox(height: 20),
                    Align(
                        alignment: Alignment.centerLeft, child: Text("Country"))
                  ],
                ),
              ),
            ),
            Positioned(bottom: -100.0, left: -100.0, child: circle())
          ],
        ),
      ),
    );
  }

  Widget circle() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white12, borderRadius: BorderRadius.circular(100.0)),
    );
  }
}

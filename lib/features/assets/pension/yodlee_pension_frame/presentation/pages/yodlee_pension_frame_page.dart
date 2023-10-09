import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/features/assets/pension/pension_main/presentation/pages/pension_main_page.dart';

class YodleePensionFramePage extends StatefulWidget {
  // YodleePensionFramePage({Key key}) : super(key: key);

  @override
  _YodleePensionFramePageState createState() => _YodleePensionFramePageState();
}

class _YodleePensionFramePageState extends State<YodleePensionFramePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const Text("pension provider screen"),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => PensionMainPage()));
                },
                child: const Text("next"))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/widgets/login_background_widget.dart';
import 'package:wedge/features/auth/belgravia_login/presentation/pages/belgravia_login_page.dart';

import '../../../../../core/config/app_config.dart';

class BelgreviaPasswordPage extends StatefulWidget {
  @override
  _BelgreviaPasswordPageState createState() => _BelgreviaPasswordPageState();
}

class _BelgreviaPasswordPageState extends State<BelgreviaPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: LoginBackground(
        title: "Hoxton Capital User Login",
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 100,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: ktextfeildBorderRadius,
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: 'Enter new password',
                      prefixText: ' ',
                      suffixStyle: const TextStyle(color: Colors.green)),
                ),
                SizedBox(
                  height: 24,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: ktextfeildBorderRadius,
                        borderSide: BorderSide(color: Colors.grey)),
                    hintText: 'Re - enter password ',
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: appThemeColors!.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => BelgraviaLoginPage()));
                    },
                    child: Text(
                      'Create Password',
                      style: TextStyle(fontSize: kfontMedium),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/widgets/login_background_widget.dart';

class BelgraviaLoginPage extends StatefulWidget {
  @override
  _BelgraviaLoginPageState createState() => _BelgraviaLoginPageState();
}

class _BelgraviaLoginPageState extends State<BelgraviaLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: LoginBackground(
        title: "Success! You can now login using your credintials",
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: ktextfeildBorderRadius,
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: 'Registered email ID',
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
                    hintText: 'Password',
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                        onPressed: () {}, child: Text("Forgot password?"))),
                SizedBox(
                  height: 12,
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
                    onPressed: () {},
                    child: Text(
                      'Login',
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

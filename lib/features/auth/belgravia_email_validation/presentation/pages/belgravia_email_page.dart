import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/widgets/login_background_widget.dart';
import 'package:wedge/features/auth/belgravia_password_register/presentation/pages/belgravia_password_page.dart';

class BelgraviaEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: LoginBackground(
        title: "Belgravia User Registration",
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: ktextfeildBorderRadius,
                        borderSide: BorderSide(color: Colors.grey)),
                    labelText: 'Registered Email ID',
                    prefixText: ' ',
                    // suffixText: 'USD',
                    suffixStyle: TextStyle(color: Colors.green)),
              ),
              const SizedBox(
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
                    // print("object");
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => BelgreviaPasswordPage()));
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: kfontMedium),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

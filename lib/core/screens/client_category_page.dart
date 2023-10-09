import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/widgets/login_background_widget.dart';
import 'package:wedge/features/auth/belgravia_email_validation/presentation/pages/belgravia_email_page.dart';

// TODO @karan This page is not user any where
class ClientCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: LoginBackground(
          title:
              "If you are an existing Hoxton or Belgravia client you can login using your existing login creditials ",
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey[300],
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    onTap: () {
                      RootApplicationAccess().navigateToLogin(context);
                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //         builder: (context) => HoxtonLoginScreen()));
                    },
                    title: const Text(
                      "Hoxton Capital Users",
                      style: TextStyle(fontSize: kfontLarge),
                    ),
                    trailing: const Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey[300],
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    onTap: () {
                      cupertinoNavigator(
                          context: context,
                          screenName: BelgraviaEmailPage(),
                          type: NavigatorType.PUSH);
                    },
                    title: const Text(
                      "Belgravia Users",
                      style: TextStyle(
                        fontSize: kfontLarge,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey[300],
                    height: 1,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

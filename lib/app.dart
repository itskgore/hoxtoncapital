import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/screens/splash_screen/presentation/pages/splash_screen.dart';
import 'package:wedge/service_registration/register_main_bloc.dart';
import 'package:wiredash/wiredash.dart';

//navigatorKey used to get page state and context dynamic
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: GestureDetector(
          onTap: () {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          child: Wiredash(
            projectId: "wedge-6ff8jlt",
            secret: "4kWcOsPFHd-c-Qi3VmZz97x2nBuNFSIb",
            navigatorKey: navigatorKey,
            child: MaterialApp(
                title: 'Hoxton Wealth',
                navigatorKey: navigatorKey,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale("en", ""),
                debugShowCheckedModeBanner: false,
                theme: ThemeConstants.getTheme(context),
                home: const SplashScreen(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!,
                  );
                },
                routes: <String, WidgetBuilder>{
                  "login": (_) => const SplashScreen(),
                }),
          ),
        ),
      ),
    );
  }
}

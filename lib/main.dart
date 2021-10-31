import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoxtoncapital/providers/main-pro.dart';
import 'package:hoxtoncapital/providers/saved-cards-pro.dart';
import 'package:hoxtoncapital/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'screens/home-screen/home-screen.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MainProvider()),
        ChangeNotifierProvider.value(value: SavedCardsProvider()),
      ],
      child: MaterialApp(
        title: 'Huxton Capital',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: HomeScreen(),
      ),
    );
  }
}

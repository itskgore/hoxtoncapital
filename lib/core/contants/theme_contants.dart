import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/utils/wedge_colors.dart';

class ThemeConstants {
  static ThemeData getTheme(context) {
    return ThemeData(
      dialogBackgroundColor: Colors.white,
      dialogTheme: const DialogTheme(backgroundColor: Colors.white),
      primaryColor: appThemeColors!.primary,
      primarySwatch: Colors.grey,
      primaryColorDark: Colors.green,
      primaryColorLight: Colors.white,
      textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      fontFamily: kfontFamily,
      appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: appThemeColors!.bg,
          elevation: 0.0,
          titleTextStyle: const TextStyle(
              fontFamily: kSecondortfontFamily,
              fontSize: 20,
              color: Color(0xfff11403A)),
          iconTheme: IconThemeData(color: appThemeColors!.primary)),
    );
  }
}

const Color kprimaryColor = Color(0xfff103833);
const Color khomeDashBoard = Color(0xfff11403A);
const Color kprimaryColorLight = Color(0xfff15534B);
const Color kBackgroundColor = Color(0xfffF7F8F0);
const Color ksectionColorLight = Colors.white;
const Color kgreen = Color(0xfff51AF86); //51AF86
const Color kred = Color(0xfffF47373);
const Color kgreyFont = Color(0xfffD6D6D6); //F47373
const Color kblue = Color(0xfff428DFF);
const Color klightGrey = Color(0xfffF6F6F6);
const Color klightYellow = Color(0xfffEAEBE1);
const Color kDividerColor = Color(0xfffE0E0E0);
const Color kDashboardValueMainTextColor = Color(0xfff0F978F);
const List<Color> kWedgeExpansionTileGradient = [
  Color.fromRGBO(242, 242, 242, 1),
  Color.fromRGBO(246, 246, 246, 0)
];

const List kcreditCardColors = [
  [Color.fromRGBO(255, 238, 195, 0.55), Color.fromRGBO(249, 240, 208, 1)],
  [Color.fromRGBO(64, 212, 177, 0.22), Color.fromRGBO(207, 245, 234, 1)],
  [Color.fromRGBO(181, 211, 239, 0.33), Color.fromRGBO(209, 230, 250, 1)],
  [Color.fromRGBO(243, 238, 255, 1), Color.fromRGBO(220, 200, 236, 1)],
];

const Color kfontColorLight = Colors.white;
const Color kfontColorDark = Colors.black;

const double kfontSmall = 12.0;
const double kfontMedium = 16.0;
const double kfontLarge = 20.0;
const double kfontMainContainerValueLarge = 25.0;
const double kfontexLarge = 24;

const double kpadding = 16.0;
const double kborderRadius = 10.0;

const String kfontFamily = "Roboto";
const String kSecondortfontFamily = "Roboto";

double getDeviceHight(context) {
  return MediaQuery.of(context).size.height;
}

double getDeviceWidth(context) {
  return MediaQuery.of(context).size.width;
}

const MaterialColor kwedgeColor = MaterialColor(
  0,
  <int, Color>{
    0: Color(0xfff11403A),
  },
);

const TextStyle kheadingDescriptionText =
    TextStyle(fontSize: kfontMedium, color: kfontColorDark);

// Text feild
const BorderRadius ktextfeildBorderRadius = BorderRadius.all(
  Radius.circular(10.0),
);

const OutlineInputBorder ktextFeildOutlineInputBorder = OutlineInputBorder(
    borderRadius: ktextfeildBorderRadius,
    borderSide: BorderSide(color: Color(0xfffD6D6D6), width: 0.8));

const OutlineInputBorder ktextFeildOutlineInputBorderFocused =
    OutlineInputBorder(
        borderRadius: ktextfeildBorderRadius,
        borderSide: BorderSide(color: Color(0xfff428DFF), width: 0.8));

const double ktextBoxGap = 18.0;

var labelStyle = TextStyle(
    color: WedgeColors.hintTextColor, fontFamily: appThemeSubtitleFont);

const OutlineInputBorder kerrorTextfeildBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: kred,
    ),
    borderRadius: BorderRadius.all(Radius.circular(kborderRadius)));

const TextStyle kerrorTextstyle = TextStyle(fontSize: 16.0, color: kred);
// Text feild

class TextHelper {
  static var h1 = const TextStyle(
    fontSize: kfontexLarge,
    color: Colors.black,
    fontFamily: kfontFamily,
    // fontWeight: FontWeight.w600
  );
  static var h1Second = const TextStyle(
    fontSize: kfontexLarge,
    color: Colors.black,
    fontFamily: kSecondortfontFamily,
    // fontWeight: FontWeight.w600
  );

  static var h2 = const TextStyle(
    fontSize: 23,
    color: Colors.black,
    fontFamily: kfontFamily,
    // fontWeight: FontWeight.w800
  );
  static var h3 = const TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontFamily: kfontFamily,
    // fontWeight: FontWeight.w600
  );
  static var h4 = const TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontFamily: kfontFamily,
    // fontWeight: FontWeight.w500
  );
  static var h5 = const TextStyle(
    fontSize: kfontMedium,
    color: Colors.black,
    fontFamily: kfontFamily,
    // fontWeight: FontWeight.w400
  );
  static var h6 = const TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontFamily: kfontFamily,
  );
  static var h7 = const TextStyle(
      fontSize: 10,
      color: Colors.black,
      fontFamily: kfontFamily,
      fontWeight: FontWeight.w400);
}

class TitleHelper {
  static var h1 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h1,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,

    fontFamily: appThemeHeadlineFont,
    // fontWeight: FontWeight.w600
  );
  static var h1Second = TextStyle(
    fontSize: appThemeHeadlineSizes!.h2,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,

    fontFamily: appThemeHeadlineFont,
    // fontWeight: FontWeight.w600
  );

  static var h2 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h2,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
  static var h3 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h3,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
  static var h4 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h4,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
  static var h5 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h5,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
  static var h6 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h6,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
  static var h7 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h7,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
  static var h8 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h8,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
  static var h9 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h9,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
  static var h10 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h10,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
  static var h11 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h11,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
  static var h12 = TextStyle(
    fontSize: appThemeHeadlineSizes!.h12,
    color: appThemeColors!.primary,
    fontWeight: appThemeHeadlineIsBold ? FontWeight.w600 : null,
    fontFamily: appThemeHeadlineFont,
  );
}

class SubtitleHelper {
  static var h1 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h1,
    color: appThemeColors!.textDark,

    fontFamily: appThemeSubtitleFont,
    // fontWeight: FontWeight.w600
  );
  static var h1Second = TextStyle(
    fontSize: appThemeSubtitleSizes!.h2,
    color: appThemeColors!.textDark,

    fontFamily: appThemeSubtitleFont,
    // fontWeight: FontWeight.w600
  );

  static var h2 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h2,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
  static var h3 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h3,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
  static var h4 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h4,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
  static var h5 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h5,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
  static var h6 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h6,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
  static var h7 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h7,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
  static var h8 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h8,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
  static var h9 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h9,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
  static var h10 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h10,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
  static var h11 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h11,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
  static var h12 = TextStyle(
    fontSize: appThemeSubtitleSizes!.h12,
    color: appThemeColors!.textDark,
    fontFamily: appThemeSubtitleFont,
  );
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

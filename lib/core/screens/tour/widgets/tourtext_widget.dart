import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:google_fonts/google_fonts.dart';

class TourText extends StatelessWidget {
  final tourText;
  const TourText(this.tourText);

  @override
  Widget build(BuildContext context) {
    bool isSmallDevice = MediaQuery.of(context).size.width <= 414;
    double padding = isSmallDevice ? 30 : 25;

    return Container(
      // height: 100,
      decoration: BoxDecoration(
          // color: appThemeColors!.primary,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.5),
          //     spreadRadius: 3,
          //     blurRadius: 20,
          //     offset: Offset(9, -20), // changes position of shadow
          //   ),
          // ],
          ),
      padding:
          EdgeInsets.only(top: 20, bottom: 20, left: padding, right: padding),
      child: Center(
        child: Text(
          tourText,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontFamily: appThemeHeadlineFont,
                  letterSpacing: 1.0,
                  color: appThemeColors!.textLight,
                  fontSize: isSmallDevice
                      ? appThemeHeadlineSizes!.h10
                      : appThemeHeadlineSizes!.h9)),
        ),
      ),
    );
  }
}

// Positioned(
//       bottom: 10.0,
//       left: 20.0,
//       right: 20.0,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Center(
//           child: Text(
//             tourText,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontWeight: FontWeight.w100,
//                 letterSpacing: 1.0,
//                 color: kfontColorLight,
//                 fontSize: kfontLarge),
//           ),
//         ),
//       ),
//     );
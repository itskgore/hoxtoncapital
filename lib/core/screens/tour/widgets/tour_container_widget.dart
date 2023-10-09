import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../contants/theme_contants.dart';
import '../../../utils/wedge_func_methods.dart';

class TourContainer extends StatelessWidget {
  // all slidable contents
  final personImage;
  final tourText;

  const TourContainer({this.personImage, this.tourText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size.height * .35,
          margin: EdgeInsets.only(top: size.height * .04),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "assets/images/carousel/carosel_$personImage.svg",
            fit: BoxFit.fitHeight,
          ),
        ),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 64, right: 64, top: 20),
            child: Text(
              tourText,
              softWrap: true,
              textAlign: TextAlign.center,
              style: SubtitleHelper.h7
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
            ))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/widgets/wedge_logo.dart';

class LoginBackground extends StatelessWidget {
  //common background contains wedge logo and triangles
  final child;
  final title;
  final subTitle;
  const LoginBackground({this.child, this.title, this.subTitle});
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        const Center(
          child: WedgeLogo(
            height: 100.0,
            width: 150.0,
            darkLogo: false,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: kfontLarge,
                color: kfontColorLight,
                fontFamily: kSecondortfontFamily),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            subTitle,
            style:
                const TextStyle(fontSize: kfontMedium, color: Colors.white38),
            textAlign: TextAlign.center,
          ),
        ),
        child,
      ],
    );
  }
}

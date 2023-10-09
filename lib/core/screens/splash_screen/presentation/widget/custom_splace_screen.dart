import 'package:flutter/material.dart';

import '../../../../config/app_config.dart';
import '../../../../widgets/wedge_logo.dart';

class CustomSplashScreen extends StatelessWidget {
  final double? logoOpacity;
  const CustomSplashScreen({Key? key, this.logoOpacity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: appThemeColors!.primary,
      child: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          Hero(
            tag: 'logoimage',
            child: Opacity(
              opacity: logoOpacity ?? 1,
              child: const WedgeLogo(
                width: 200.0,
                height: 100.0,
                darkLogo: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

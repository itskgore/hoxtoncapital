import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/wedge_func_methods.dart';

class ReconnectButton extends StatelessWidget {
  final void Function() onPressed;
  final bool showWarning;

  const ReconnectButton(
      {super.key, required this.onPressed, this.showWarning = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xffEA943E),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showWarning
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SvgPicture.asset(
                        'assets/icons/reconnect_warning_white.svg'),
                  )
                : const SizedBox(),
            Text(
              translate!.reconnect,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

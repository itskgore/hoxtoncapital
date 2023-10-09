import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputDoneView extends StatelessWidget {
  const InputDoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: CupertinoColors.white,
            border: Border.symmetric(
                horizontal: BorderSide(
                    style: BorderStyle.solid, color: Colors.black12))),
        child: Align(
            alignment: Alignment.topRight,
            child: CupertinoButton(
              padding:
                  const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: const Text("Done",
                  style: TextStyle(
                    color: CupertinoColors.activeBlue,
                  )),
            )));
  }
}

class KeyboardOverlay {
  static OverlayEntry? _overlayEntry;

  static showOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: const InputDoneView());
    });

    overlayState!.insert(_overlayEntry!);
  }

  static removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}

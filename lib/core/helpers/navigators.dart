import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BouncingNavigation extends PageRouteBuilder {
  final Widget widget;

  BouncingNavigation({required this.widget})
      : super(
            transitionDuration: const Duration(milliseconds: 270),
            transitionsBuilder: (BuildContext con, Animation<double> animation,
                Animation<double> secAnimation, Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.easeInOutBack);
              return ScaleTransition(
                scale: animation,
                alignment: Alignment.topCenter,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secanimation) {
              return widget;
            });
}

class SlideNavigation extends PageRouteBuilder {
  final Widget widget;

  SlideNavigation({required this.widget})
      : super(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext con, Animation<double> animation,
                Animation<double> secAnimation, Widget child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return SlideTransition(
                transformHitTests: true,
                position:
                    Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                        .animate(animation),
                textDirection: TextDirection.ltr,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secanimation) {
              return widget;
            });
}

class DownSlideNavigation extends PageRouteBuilder {
  final Widget widget;

  DownSlideNavigation({required this.widget})
      : super(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext con, Animation<double> animation,
                Animation<double> secAnimation, Widget child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return SlideTransition(
                transformHitTests: true,
                position:
                    Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.ease))
                        .animate(animation),
                textDirection: TextDirection.ltr,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secanimation) {
              return widget;
            });
}

class FadeNavigation extends PageRouteBuilder {
  final Widget widget;

  FadeNavigation({required this.widget})
      : super(
            transitionDuration: const Duration(milliseconds: 650),
            transitionsBuilder: (BuildContext con, Animation<double> animation,
                Animation<double> secAnimation, Widget child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return FadeTransition(
                opacity: animation,
                alwaysIncludeSemantics: true,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secanimation) {
              return widget;
            });
}

enum NavigatorType { PUSH, PUSHREPLACE, PUSHREMOVEUNTIL }

cupertinoNavigator(
    {required BuildContext context,
    required Widget screenName,
    required NavigatorType type,
    Function(dynamic)? then}) {
  switch (type) {
    case NavigatorType.PUSH:
      Navigator.push(
              context, CupertinoPageRoute(builder: (context) => screenName))
          .then((value) {
        if (then != null) {
          then(value);
        }
      });
      return;
    case NavigatorType.PUSHREPLACE:
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => screenName));
      return;
    case NavigatorType.PUSHREMOVEUNTIL:
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => screenName),
          (Route<dynamic> route) => false);
      return;
  }
}

downSlideNavigator(
    {required BuildContext context,
    required Widget screenName,
    required NavigatorType type}) {
  switch (type) {
    case NavigatorType.PUSH:
      Navigator.push(context, DownSlideNavigation(widget: screenName));
      return;
    case NavigatorType.PUSHREPLACE:
      Navigator.pushReplacement(
          context, DownSlideNavigation(widget: screenName));
      return;
    case NavigatorType.PUSHREMOVEUNTIL:
      Navigator.pushAndRemoveUntil(
          context,
          DownSlideNavigation(widget: screenName),
          (Route<dynamic> route) => false);
      return;
  }
}

fadeNavigator(
    {required BuildContext context,
    required Widget screenName,
    required NavigatorType type,
    Function(dynamic)? then}) {
  switch (type) {
    case NavigatorType.PUSH:
      Navigator.push(context, FadeNavigation(widget: screenName)).then((value) {
        if (then != null) {
          then(value);
        }
      });
      return;
    case NavigatorType.PUSHREPLACE:
      Navigator.pushReplacement(context, FadeNavigation(widget: screenName));
      return;
    case NavigatorType.PUSHREMOVEUNTIL:
      Navigator.pushAndRemoveUntil(context, FadeNavigation(widget: screenName),
          (Route<dynamic> route) => false);
      return;
  }
}

materialNavigator(
    {required BuildContext context,
    required Widget screenName,
    required NavigatorType type}) {
  switch (type) {
    case NavigatorType.PUSH:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => screenName));
      return;
    case NavigatorType.PUSHREPLACE:
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => screenName));
      return;
    case NavigatorType.PUSHREMOVEUNTIL:
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => screenName),
          (Route<dynamic> route) => false);
      return;
  }
}

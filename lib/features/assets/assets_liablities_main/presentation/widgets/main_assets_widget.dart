import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class MainAssetsWidget extends StatefulWidget {
  final String name;
  final String icon;
  final Widget page;
  final String? total;
  final double? iconSize;
  final Function onBack;
  final Color circleColor;
  final bool showDisconnected;

  const MainAssetsWidget({
    super.key,
    required this.name,
    required this.icon,
    required this.page,
    this.showDisconnected = false,
    this.total,
    this.iconSize,
    required this.onBack,
    required this.circleColor,
  });

  @override
  State<MainAssetsWidget> createState() => _AssetsWidgetState();
}

class _AssetsWidgetState extends State<MainAssetsWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => widget.page),
        ).then((value) {
          widget.onBack();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10.0, spreadRadius: 1.0),
            ],
          ),
          child: Column(children: [
            ListTile(
              title: Text(
                widget.name,
                style: SubtitleHelper.h10.copyWith(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "${widget.total}",
                style: SubtitleHelper.h11
                    .copyWith(color: appThemeColors!.disableText),
              ),
              leading: SizedBox(
                width: 70.0,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: appThemeColors!.primary,
                          borderRadius: BorderRadius.circular(5)),
                      child: Image.asset(
                        widget.icon,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    circle(widget.circleColor)
                  ],
                ),
              ),
              trailing: FittedBox(
                child: Row(children: [
                  Visibility(
                    visible: widget.showDisconnected,
                    child: SvgPicture.asset(
                      "assets/icons/warning.svg",
                      height: 35,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

Widget circle(color) {
  return Container(
    height: 10.0,
    width: 10.0,
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(100.0)),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class AssetsWidget extends StatefulWidget {
  final String name;
  final String icon;
  final Widget page;
  final String? total;
  final Function onBack;

  const AssetsWidget(
      {required this.name,
      required this.icon,
      required this.page,
      this.total,
      required this.onBack});

  @override
  State<AssetsWidget> createState() => _AssetsWidgetState();
}

class _AssetsWidgetState extends State<AssetsWidget> {
  @override
  Widget build(BuildContext context) {
    var translate = AppLocalizations.of(context);

    List<String> mainVal = [];
    if (widget.total!.isNotEmpty) {
      mainVal = widget.total!.trimLeft().trimRight().split(" ");
    }

    return GestureDetector(
      onTap: () async {
        final data = await Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => widget.page),
        );
        widget.onBack();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10.0, spreadRadius: 1.5),
            ],
          ),
          // shape: ,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  tileColor: Colors.white,
                  title: Text("${translate!.add} ${widget.name}",
                      style: TitleHelper.h10
                      // TextStyle(
                      //     fontWeight: appThemeFonts!.headline!.isBold ?? false
                      //         ? FontWeight.w600
                      //         : null,
                      //     color: appThemeColors!.primary,
                      //     fontFamily: appThemeFonts!.headline!.font),
                      ),
                  subtitle: Text(
                    "${mainVal[0]} ${numberFormat.format(num.parse(mainVal[mainVal.length - 1]))}",
                    style: TextStyle(
                        fontFamily: appThemeFonts!.subtitle!.font,
                        color: appThemeColors!.disableText),
                  ),
                  leading: Container(
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
                  trailing: const Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

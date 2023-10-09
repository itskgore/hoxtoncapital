import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/app_config.dart';
import '../contants/theme_contants.dart';
import '../utils/wedge_func_methods.dart';

class WedgeListTile extends StatefulWidget {
  final String leftTitle;
  final String leftSubtitle;
  final String rightSubTitle;
  final String rightTitle;
  final int index;
  final Widget? leading;
  Function()? onTab;
  bool? initiallyExpanded;
  bool? isFromHoxton;
  bool? hideBottom;
  int? isOpen;
  Widget? reconnectIcon;
  bool? isProvider;

  WedgeListTile({
    Key? key,
    required this.index,
    this.hideBottom,
    this.isOpen,
    required this.leftTitle,
    this.onTab,
    this.leading,
    this.initiallyExpanded,
    this.reconnectIcon,
    this.isFromHoxton,
    this.isProvider,
    required this.leftSubtitle,
    required this.rightSubTitle,
    required this.rightTitle,
  }) : super(key: key);

  @override
  State<WedgeListTile> createState() => _WedgeExpansionTileState();
}

class _WedgeExpansionTileState extends State<WedgeListTile> {
  int? _currentExpandedTileIndex;
  bool isTileExpended = false;

  @override
  Widget build(BuildContext context) {
    final numFormatter = NumberFormat('#,###,###.##');
    final List<String> rightValue = widget.rightTitle.split(" ");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 9.9, spreadRadius: 0.5),
            ],
          ),
          // borderRadius: BorderRadius.circular(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                onTap: widget.onTab,
                leading: widget.leading,
                title: Align(
                  alignment: const Alignment(-1, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 4),
                                child: Text(
                                  widget.leftTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TitleHelper.h10
                                      .copyWith(color: appThemeColors!.primary),
                                ),
                              ),
                            ),
                            Visibility(
                                visible: (widget.isProvider ?? false),
                                child: Image.asset(
                                    "assets/icons/link_badge.png",
                                    height: 18)),
                          ],
                        ),
                      ),

                      // Spacer(),
                      Text(widget.rightSubTitle,
                          // rightTitle,
                          style: SubtitleHelper.h11
                              .copyWith(color: appThemeColors!.disableText)),
                    ],
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(
                    //   width: 28,
                    // ),
                    Expanded(
                        child: Text(
                            widget.leftSubtitle.length > 14
                                ? "${widget.leftSubtitle.substring(0, 13)}..."
                                : widget.leftSubtitle.length == 3
                                    ? getCountryNameFromISO3(
                                        name: widget.leftSubtitle)
                                    : widget.leftSubtitle,
                            overflow: TextOverflow.ellipsis,
                            style: SubtitleHelper.h11
                                .copyWith(color: appThemeColors!.disableText)
                            // TextStyle(
                            //   color: appThemeColors!.disableText,
                            //   fontFamily: appThemeSubtitleFont,
                            // )
                            )),
                    Text(
                      "${rightValue[0]} ${numFormatter.format(num.parse(rightValue[1]))}",
                      style: TitleHelper.h10
                          .copyWith(color: appThemeColors!.primary),
                    )
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: appThemeColors!.primary,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

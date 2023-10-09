// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';

class WedgeExpansionTile extends StatefulWidget {
  final String leftTitle;
  final String leftSubtitle;
  final String? rightSubTitle;
  final String? rightTitle;
  final dynamic midWidget;
  final int index;
  Function? onTab;
  void Function()? onDeletePressed;
  Function? onEditPressed;
  bool isUnlink;
  bool? isFromYodlee;
  bool? initiallyExpanded;
  bool? isFromHoxton;
  bool? hideBottom;
  int? isOpen;
  int maxLines;
  Widget? reconnectIcon;
  double? borderRadius;
  EdgeInsets? padding;
  EdgeInsets? margin;
  Widget? leading;
  bool showLeftButton;
  Widget? rightButton;
  TextStyle? leftTitleStyle;
  TextStyle? leftSubtitleStyle;
  TextStyle? rightSubtitleStyle;
  final TextStyle? rightTitleStyle;
  final EdgeInsets? tilePadding;
  final String source;
  final bool linked;

  WedgeExpansionTile({
    Key? key,
    required this.index,
    this.hideBottom,
    this.isOpen,
    required this.leftTitle,
    this.isUnlink = false,
    this.onTab,
    this.borderRadius,
    this.padding,
    this.margin,
    this.isFromYodlee,
    this.leading,
    this.maxLines = 1,
    this.initiallyExpanded,
    this.reconnectIcon,
    this.isFromHoxton,
    this.leftSubtitle = '',
    this.rightSubTitle,
    this.rightTitle,
    required this.midWidget,
    this.onDeletePressed,
    this.onEditPressed,
    this.showLeftButton = true,
    this.rightButton,
    this.leftTitleStyle,
    this.leftSubtitleStyle,
    this.tilePadding,
    this.rightSubtitleStyle,
    this.rightTitleStyle,
    this.source = 'Manual',
    this.linked = false,
  }) : super(key: key);

  @override
  State<WedgeExpansionTile> createState() => _WedgeExpansionTileState();
}

class _WedgeExpansionTileState extends State<WedgeExpansionTile> {
  bool isTileExpended = false;

  @override
  Widget build(BuildContext context) {
    final List<String>? rightValue = widget.rightTitle?.split(" ");

    return Padding(
      padding: widget.margin ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Stack(children: [
        Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 9.9, spreadRadius: 0.5),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                  leading: widget.leading,
                  tilePadding: widget.tilePadding,
                  onExpansionChanged: (value) {
                    setState(() {
                      if (widget.onTab != null) {
                        widget.onTab!(value);
                      }
                    });
                    isTileExpended = value;
                  },
                  initiallyExpanded:
                      widget.initiallyExpanded ?? widget.index == widget.isOpen,
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  textColor: Colors.black,
                  collapsedTextColor: Colors.black,
                  title: Align(
                    alignment: const Alignment(-1, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            child: Text(
                              widget.leftTitle,
                              maxLines: widget.maxLines,
                              overflow: TextOverflow.ellipsis,
                              style: widget.leftTitleStyle ??
                                  TitleHelper.h10
                                      .copyWith(color: appThemeColors!.primary),
                            ),
                          ),
                        ),
                        rightValue != null
                            ? Text(
                                "${rightValue[0]} ${rightValue[1]}",
                                style: widget.rightTitleStyle ??
                                    TitleHelper.h10.copyWith(
                                        color: appThemeColors!.primary),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.leftSubtitle.length > 14
                              ? "${widget.leftSubtitle.substring(0, 13)}..."
                              : widget.leftSubtitle.length == 3
                                  ? getCountryNameFromISO3(
                                      name: widget.leftSubtitle)
                                  : widget.leftSubtitle,
                          overflow: TextOverflow.ellipsis,
                          style: widget.leftSubtitleStyle ??
                              SubtitleHelper.h11
                                  .copyWith(color: appThemeColors!.disableText),
                        ),
                      ),
                      Text(
                        widget.rightSubTitle ?? getRightSubtitle(),
                        style: widget.rightSubtitleStyle ??
                            SubtitleHelper.h11.copyWith(
                              color: widget.linked
                                  ? Colors.green
                                  : widget.source.toLowerCase() == 'manual'
                                      ? appThemeColors!.disableText
                                      : Colors.orange,
                            ),
                      ),
                    ],
                  ),
                  children: [
                    widget.midWidget == null
                        ? Container()
                        : const Divider(
                            color: kDividerColor,
                          ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        child: widget.midWidget),
                    const SizedBox(
                      height: 10,
                    ),
                    widget.hideBottom ?? false
                        ? Container()
                        : Container(
                            // TODO: New UI gradient sprint yet to decide
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: kWedgeExpansionTileGradient,
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              // height: 50.0,
                              child: Row(children: [
                                ///Added additional constraint to show delete button.
                                widget.showLeftButton
                                    ? Expanded(
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  widget.onDeletePressed == null
                                                      ? const Color(0xfffCFCFCF)
                                                      : Color(0xFFAA2E26),
                                              // Set the desired border color here
                                              width:
                                                  1, // Set the desired border width
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                4), // Set border radius as needed
                                          ),
                                          child: TextButton(
                                            onPressed: widget.onDeletePressed,
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                alignment:
                                                    Alignment.centerLeft),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    widget.isUnlink
                                                        ? Icons
                                                            .link_off_outlined
                                                        : Icons
                                                            .delete_outline_outlined,
                                                    color: widget
                                                                .onDeletePressed ==
                                                            null
                                                        ? const Color(
                                                            0xfffCFCFCF)
                                                        : Color(
                                                            0xFFAA2E26), // Set the icon color to match the border color
                                                  ),
                                                  Text(
                                                    widget.isUnlink
                                                        ? translate!.unlink
                                                        : translate!.delete,
                                                    style: TextStyle(
                                                      color: widget
                                                                  .onDeletePressed ==
                                                              null
                                                          ? const Color(
                                                              0xfffCFCFCF)
                                                          : Color(
                                                              0xFFAA2E26), // Set text color to match the border color
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),

                                const SizedBox(
                                  width: 20,
                                ),
                                // const Spacer(),
                                widget.rightButton == null
                                    ? Expanded(
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  widget.onDeletePressed == null
                                                      ? const Color(0xfffCFCFCF)
                                                      : Color(0xFF192C63),
                                              // Set the desired border color here
                                              width:
                                                  1, // Set the desired border width
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                4), // Set border radius as needed
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              if (widget.onEditPressed ==
                                                  null) {
                                                showSnackBar(
                                                    context: context,
                                                    title:
                                                        "Can't edit a live data");
                                              } else if (widget.onEditPressed ==
                                                  null) {
                                                showSnackBar(
                                                    context: context,
                                                    title:
                                                        "Deleting in progress");
                                              } else {
                                                widget.onEditPressed!();
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                alignment:
                                                    Alignment.centerLeft),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.mode_edit_outlined,
                                                    color: widget
                                                                .onEditPressed ==
                                                            null
                                                        ? const Color(
                                                            0xfffCFCFCF)
                                                        : Color(
                                                            0xFF192C63), // Set the icon color to match the border color
                                                  ),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      color: widget
                                                                  .onEditPressed ==
                                                              null
                                                          ? const Color(
                                                              0xfffCFCFCF)
                                                          : Color(
                                                              0xFF192C63), // Set text color to match the border color
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: widget.rightButton ??
                                            const SizedBox()),
                              ]),
                            ),
                          )
                  ]),
            ),
          ),
        ),
        Visibility(
          visible: (widget.isFromYodlee ??
              false == true || widget.isFromHoxton == true),
          child: Positioned(
            right: 0.0,
            top: 0.0,
            child: SvgPicture.asset(
              "${appIcons.aggregatorIcon}",
              width: 35,
            ),
          ),
        ),
        Visibility(
          visible: (widget.isFromHoxton ??
              false == true || widget.isFromHoxton == true),
          child: Positioned(
            right: 6,
            top: 6,
            child: Image.asset(
              "assets/icons/hoxton_badge.png",
              width: 45,
            ),
          ),
        )
      ]),
    );
  }

  String getRightSubtitle() {
    if (widget.source.toLowerCase() == 'manual') {
      return 'Manual';
    } else {
      return widget.linked ? 'Linked' : 'Disconnected';
    }
  }
}

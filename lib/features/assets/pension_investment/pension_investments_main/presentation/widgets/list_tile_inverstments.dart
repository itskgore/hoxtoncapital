import 'package:flutter/material.dart';

import '../../../../../../core/common/functions/common_functions.dart';
import '../../../../../../core/contants/theme_contants.dart';

class ListTileInvestment extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final String? subTitle;
  final dynamic saltedgeData;
  final Widget? leading;
  final String? trailing;
  final String? source;

  const ListTileInvestment({
    Key? key,
    this.onTap,
    this.leading,
    this.title,
    this.subTitle,
    this.saltedgeData,
    this.trailing,
    this.source,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: kpadding),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kborderRadius),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 9.9, spreadRadius: 0.5),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading ?? const SizedBox(),
            SizedBox(
              width: leading != null ? 20 : 0,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("$title",
                          overflow: TextOverflow.ellipsis,
                          style: TitleHelper.h10.copyWith(color: Colors.black)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("$trailing",
                        style: TitleHelper.h10.copyWith(color: Colors.black)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                        visible: subTitle != "",
                        child: Expanded(
                          child: Text(
                            "$subTitle",
                            overflow: TextOverflow.ellipsis,
                            style: SubtitleHelper.h11.copyWith(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400),
                          ),
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    source == 'hoxton'
                        ? Text('Hoxton',
                            style: SubtitleHelper.h11
                                .copyWith(color: const Color(0xFF192C63)))
                        : isAggregatorExpired(data: saltedgeData)
                            ? Text("Disconnected",
                                style: SubtitleHelper.h11
                                    .copyWith(color: const Color(0xFFEA943E)))
                            : Text("Linked",
                                style: SubtitleHelper.h11
                                    .copyWith(color: const Color(0xFF4D9B4B))),
                  ],
                ),
              ],
            )),
            onTap != null
                ? const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/features/wealth_vault/documents/presentation/pages/wealth_valt_main.dart';

class FinancialTools extends StatelessWidget {
  const FinancialTools({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appThemeColors!.bg,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => WealthValtMainPage()));
            },
            child: _toolCard(WEALTH_VAULT, "wealth_vault_dark.svg", context,
                "wealth_vault.png",
                iconColor: appThemeColors!.primary),
          )
        ],
      ),
    );
  }

  Widget _toolCard(title, icon, context, bgImage, {Color? iconColor}) {
    return Container(
      margin: const EdgeInsets.only(top: 40.0),
      height: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (appTheme.clientName!.toLowerCase() == "wedge") ...[
              const BoxShadow(
                  color: Colors.black12, blurRadius: 9.9, spreadRadius: 0.5),
            ],
          ],
          color: appTheme.clientName!.toLowerCase() != "wedge"
              ? appThemeColors!.buttonLight!
              : appThemeColors!.bg!),
      child: Stack(
        children: [
          appTheme.clientName!.toLowerCase() != "wedge"
              ? Container()
              : Positioned(
                  top: -30,
                  right: -40,
                  child: Image.asset(
                    "assets/icons/$bgImage",
                  ),
                ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 30,
              ),
              Center(
                child: SvgPicture.asset(
                  "assets/icons/$icon",
                  color: iconColor,
                  width: 60,
                  height: 60,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TitleHelper.h8,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_right_alt,
                        size: 40,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  title == WEALTH_VAULT
                      ? Text(
                          "Securely store all your important financial documents, add beneficiary and a trusted member.",
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: SubtitleHelper.h11.copyWith(
                              color: appThemeColors!.disableText, height: 1.5),
                          // maxLines: 3,
                        )
                      : Text(
                          "Access some of the most useful financial calculators anytime for making informed financial decisions.",
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: SubtitleHelper.h11.copyWith(
                              color: appThemeColors!.disableText, height: 1.5),
                        ),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}

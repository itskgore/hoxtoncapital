import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';

import '../../../../../core/contants/string_contants.dart';
import '../../../../../core/contants/theme_contants.dart';
import 'widget_access_list_bottomsheet.dart';

class widgetListTile extends StatelessWidget {
  String? name;
  String? role;
  String? email;
  String? accessLevel;

  widgetListTile({Key? key, this.name, this.role, this.email, this.accessLevel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
          color: ksectionColorLight, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(name!,
                      overflow: TextOverflow.clip, style: TitleHelper.h10),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return widgetAccessListBottomSheet(
                          accessLevel: accessLevel!,
                          email: email!,
                          role: role!,
                          // selectedAccessLevel: accessLevel!,
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        translate!.permission,
                        style: TitleHelper.h12.copyWith(color: Colors.black38),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text("$accessLevel",
                            style: TitleHelper.h12.copyWith(
                                color: accessLevel.toString().toLowerCase() ==
                                            "only view" ||
                                        accessLevel.toString().toLowerCase() ==
                                            "view only"
                                    ? Colors.orange
                                    : accessLevel.toString().toLowerCase() ==
                                            "full access"
                                        ? Colors.green
                                        : Colors.black)),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 22,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text("$role",
                style: SubtitleHelper.h10
                    .copyWith(color: appThemeColors!.primary)),
          ),
          Text("$email", style: SubtitleHelper.h10)
        ],
      ),
    );
  }
}

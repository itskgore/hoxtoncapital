import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/contants/theme_contants.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/utils/wedge_func_methods.dart';
import '../../domain/model/third_party_url_model.dart';
import '../cubit/third_party_cubit.dart';

class widgetAccessListBottomSheet extends StatelessWidget {
  final String email;
  final String role;
  final String accessLevel;

  const widgetAccessListBottomSheet(
      {Key? key,
      required this.email,
      required this.accessLevel,
      required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var accessLevelList = ["None", "View Only", "Full Access"];
    String accountAccessPermission = accessLevel;

    return Container(
      height: size.height < 700 ? size.height * .4 : size.height * .36,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18))),
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate!.permission,
                    style: TitleHelper.h9,
                  ),
                  const SizedBox(
                      height: 40, child: FittedBox(child: CloseButton()))
                ],
              ),
            ),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: appThemeColors!.primary,
                      title: Text(accessLevelList[index].toString(),
                          style: TextHelper.h6.copyWith(
                              color: accessLevelList[index]
                                          .toString()
                                          .toLowerCase() ==
                                      "Full Access".toLowerCase()
                                  ? Colors.green
                                  : accessLevelList[index]
                                                  .toString()
                                                  .toLowerCase() ==
                                              "View Only".toLowerCase() ||
                                          accessLevelList[index]
                                                  .toString()
                                                  .toLowerCase() ==
                                              "View Only".toLowerCase()
                                      ? Colors.deepOrange
                                      : Colors.black)),
                      value: accessLevelList[index],
                      groupValue: accountAccessPermission,
                      onChanged: (value) {
                        accountAccessPermission = value.toString();
                        if (value.toString().toLowerCase() ==
                            "Full Access".toString().toLowerCase()) {
                          context
                              .read<ThirdPartyCubit>()
                              .getThirdPartyAccessData(ThirdPartyUrlParams(
                                  "thirdpartyAccessor",
                                  "add",
                                  {
                                    "party": email,
                                    "role": role,
                                    "accessLevel": "Full Access"
                                  },
                                  isUpdate: true));
                          Navigator.pop(context);
                        } else if (value.toString().toLowerCase() ==
                            "None".toLowerCase()) {
                          context
                              .read<ThirdPartyCubit>()
                              .getThirdPartyAccessData(ThirdPartyUrlParams(
                                  "thirdpartyAccessor",
                                  "add",
                                  {
                                    "party": email,
                                    "role": role,
                                    "accessLevel": "None"
                                  },
                                  isUpdate: true));
                          Navigator.pop(context);
                        } else {
                          context
                              .read<ThirdPartyCubit>()
                              .getThirdPartyAccessData(ThirdPartyUrlParams(
                                  "thirdpartyAccessor",
                                  "add",
                                  {
                                    "party": email,
                                    "role": role,
                                    "accessLevel": "View Only"
                                  },
                                  isUpdate: true));
                          Navigator.pop(context);
                        }
                      });
                },
                separatorBuilder: (context, index) => const Divider(
                    height: 5, color: Colors.black12, thickness: 1),
                itemCount: 3)
          ],
        ),
      ),
    );
  }
}

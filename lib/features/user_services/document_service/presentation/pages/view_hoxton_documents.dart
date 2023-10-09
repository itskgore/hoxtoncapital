import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/contants/string_contants.dart';
import '../../../../../core/contants/theme_contants.dart';
import '../../../../../core/utils/wedge_app_bar.dart';
import '../../../../../core/utils/wedge_circular_progress_indicator.dart';
import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../core/widgets/dialog/custom_dialog.dart';
import '../../../../../core/widgets/wedge_expension_tile.dart';
import '../../../../../dependency_injection.dart';
import '../cubit/servicedocuments_cubit.dart';

class ViewHoxtonDocuments extends StatefulWidget {
  final String folderID;

  const ViewHoxtonDocuments({
    super.key,
    required this.folderID,
  });

  @override
  State<ViewHoxtonDocuments> createState() => _ViewHoxtonDocumentsState();
}

class _ViewHoxtonDocumentsState extends State<ViewHoxtonDocuments> {
  // getData(String folderId) async {
  //   await context.read<ServiceDocumentsCubit>().getData(
  //     body: {"parentFolderId": folderId},
  //     urlParameters: "document/view/execute",
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
          context: context, title: translate!.hoxtonDocuments ?? ''),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          BlocBuilder<ServiceDocumentsCubit, ServiceDocumentsState>(
            bloc: context.read<ServiceDocumentsCubit>().getData(
              body: {"parentFolderId": widget.folderID},
              urlParameters: "document/view/execute",
            ),
            builder: (context, state) {
              if (state is ServiceDocumentsLoaded) {
                return state.files.isEmpty
                    ? Center(
                        child: Text(
                        "${translate?.noDataFound ?? ""}!",
                        style: SubtitleHelper.h10,
                      ))
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: state.files.length,
                          itemBuilder: (con, index) {
                            return WedgeExpansionTile(
                              tilePadding: const EdgeInsets.only(right: 18),
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/file_icon.png',
                                      height: 25,
                                    ),
                                  ],
                                ),
                              ),
                              index: index,
                              leftTitle: state.files[index].name,
                              leftTitleStyle: SubtitleHelper.h11.copyWith(
                                color: appThemeColors?.textDark,
                                // fontWeight: FontWeight.w400,
                              ),
                              leftSubtitle: dateFormatter.format(DateTime.parse(
                                  state.files[index].lastUpdatedAt)),
                              leftSubtitleStyle: TitleHelper.h12.copyWith(
                                // fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              midWidget: null,
                              showLeftButton: false,
                              borderRadius: 6,
                              rightButton: Container(
                                height: 40.0,
                                width: 95.0,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10.0,
                                        spreadRadius: 1.0),
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(kborderRadius),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    locator<WedgeDialog>().confirm(
                                        context,
                                        CupertinoAlertDialog(
                                          title: const Text("Download File"),
                                          content: Container(),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                                textStyle: TextStyle(
                                                    color: appThemeColors!
                                                        .primary),
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  context
                                                      .read<
                                                          ServiceDocumentsCubit>()
                                                      .downloadData(
                                                          body: {
                                                        "fullPath": state
                                                            .files[index]
                                                            .fullPath,
                                                        "fileName": state
                                                            .files[index].name
                                                      },
                                                          urlParameters:
                                                              "document/viewAttachment/execute");
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Download",
                                                )),
                                            CupertinoDialogAction(
                                                textStyle: TextStyle(
                                                    color: appThemeColors!
                                                        .primary),
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cancel")),
                                          ],
                                        ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/download_document_icon.png',
                                        height: 16,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Download',
                                        style: SubtitleHelper.h12.copyWith(
                                          color: Color(0xFF538EF7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
              } else {
                return Center(
                  child: buildCircularProgressIndicator(width: 90),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

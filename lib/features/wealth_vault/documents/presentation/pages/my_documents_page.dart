import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/wedge_app_bar.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/wealth_vault/documents/presentation/bloc/cubit/document_cubit.dart';

import '../../../../../core/contants/string_contants.dart';
import '../../../../../core/utils/wedge_circular_progress_indicator.dart';
import '../../../../../core/utils/wedge_snackBar.dart';
import '../../../../../core/widgets/dialog/wedge_comfirm_dialog.dart';

class MyDocumentsPage extends StatefulWidget {
  MyDocumentsPage({Key? key}) : super(key: key);

  @override
  State<MyDocumentsPage> createState() => _MyDocumentsPageState();
}

class _MyDocumentsPageState extends State<MyDocumentsPage> {
  bool _enableDelete = true;
  bool uploading = false;
  String _downloadFilePath = "";
  int _lastDownloaded = -1;
  bool _downloading = false;
  final List _allowedExtensions = [
    ".jpg",
    ".png",
    "svg",
    ".pdf",
    ".doc",
    ".XLSX",
    ".docx"
  ];

  @override
  void initState() {
    // TODO: implement initState
    context.read<DocumentCubit>().getData();
    setPath();
  }

  String getFileExtension(String fileName) {
    try {
      return ".${fileName.split('.').last}";
    } catch (e) {
      return "";
    }
  }

  setPath() async {
    var dir = await DownloadsPathProvider.downloadsDirectory;

    if (dir != null) {
      _downloadFilePath = dir.path;
    }
  }

  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    // if no file is picked
    if (result == null) return;
    uploadImage(result.files.first.path);
  }

  uploadImage(path) async {
    var file = File(path);
    String fileName = file.path.split('/').last;
    if (_allowedExtensions.contains(getFileExtension(fileName))) {
      setState(() {
        uploading = true;
      });
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      context.read<DocumentCubit>().uploadDocumentvault(formData);
    } else {
      showSnackBar(context: context, title: "Invalid File Format!");
    }
  }

  String documentCount = "0";

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);

    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: WedgeAppBar(
            heading: "${translate!.myDocuments} ($documentCount)",
            actions: [
              IconButton(
                  onPressed: () {
                    _pickFile();
                  },
                  icon: const Icon(Icons.add))
            ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            spreadRadius: 1.5),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Text(translate.uploadedDocuments,
                            style: TitleHelper.h9),
                      ),
                      BlocConsumer<DocumentCubit, DocumentState>(
                        listener: (context, state) {
                          if (state is DocumentLoaded) {
                            setState(() {
                              documentCount = state.docs.length.toString();
                            });
                            if (state.documentUploaded) {
                              setState(() {
                                uploading = false;
                              });
                              locator<WedgeDialog>().success(
                                  context: context,
                                  title: "Success",
                                  info:
                                      "The file has been successfully uploaded",
                                  onClicked: () {
                                    Navigator.pop(context);
                                    context.read<DocumentCubit>().getData();
                                  });
                            }
                            if (state.deleteMessageSent) {
                              showSnackBar(
                                  context: context,
                                  title: "Document deleted successfully!");
                              context.read<DocumentCubit>().getData();
                              setState(() {
                                _enableDelete = true;
                              });
                            }

                            if (state.documentDownloaded) {
                              showSnackBar(
                                  context: context,
                                  title:
                                      "Downloaded to \n  $_downloadFilePath / ${state.docs[_lastDownloaded].name}");
                              context.read<DocumentCubit>().getData();
                              setState(() {
                                // _enableDelete = true;
                                _lastDownloaded = -1;
                                _downloading = false;
                              });
                            }

                            if (state.actionError) {
                              showSnackBar(
                                  context: context,
                                  title: state.errorMessage ??
                                      "An error occurred, try again later");
                              context.read<DocumentCubit>().getData();
                              setState(() {
                                // _enableDelete = true;
                                _lastDownloaded = -1;
                                _downloading = false;
                                uploading = false;
                                _enableDelete = true;
                              });
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is DocumentLoaded) {
                            return Column(
                              children:
                                  List.generate(state.docs.length, (index) {
                                return Column(
                                  children: [
                                    index == 0 ? const Divider() : Container(),
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                      leading: Icon(
                                        Icons.description,
                                        color: appThemeColors!.primary,
                                        size: 30,
                                      ),
                                      title: Text(
                                        state.docs[index].name,
                                        style: SubtitleHelper.h10,
                                        maxLines: 1,
                                      ),
                                      //subtitle: Text("239 kb"),
                                      trailing: (_downloading &&
                                              _lastDownloaded == index)
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator())
                                          : PopupMenuButton<int>(
                                              offset: const Offset(0, 40),
                                              onSelected: (_) {
                                                if (_ == 2) {
                                                  setState(() {
                                                    _downloading = true;
                                                    _lastDownloaded = index;
                                                  });
                                                  context
                                                      .read<DocumentCubit>()
                                                      .downloadDocumentValt(
                                                          state.docs[index]
                                                              .name);
                                                }
                                                if (_ == 3) {
                                                  deletePopup(context,
                                                      state.docs[index].name);
                                                }
                                              },
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              icon: Icon(Icons.more_vert,
                                                  color:
                                                      appThemeColors!.primary!),
                                              color: Colors.white,
                                              itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                      enabled: (!_downloading),
                                                      height: 36,
                                                      padding: EdgeInsets.zero,
                                                      value: 2,
                                                      child: popUpItem(
                                                          translate.download),
                                                    ),
                                                    PopupMenuItem(
                                                      enabled: _enableDelete,
                                                      height: 36,
                                                      padding: EdgeInsets.zero,
                                                      value: 3,
                                                      child: popUpItem(
                                                          translate.delete),
                                                    ),
                                                  ]),
                                    ),
                                    index == state.docs.length - 1
                                        ? Container()
                                        : const Divider()
                                  ],
                                );
                              }),

                              //Divider(),
                            );
                          } else {
                            return Center(
                                child: buildCircularProgressIndicator());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (uploading)
                SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Uploading on progress..."),
                        const SizedBox(
                          height: 10.0,
                        ),
                        LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              appThemeColors!.primary!),
                        ),
                      ],
                    ))
              else
                AddNewButton(
                    IconHeight: 25,
                    IconWidth: 25,
                    text: translate.uploadaNewFile,
                    icon: "assets/icons/uploaddoc.png",
                    onTap: () {
                      _pickFile();
                    })
            ],
          ),
        ));
  }

  Align popUpItem(String title) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 15,
        ),
        child: Text(
          "$title",
          textAlign: TextAlign.right,
          style: TextStyle(color: appThemeColors!.textDark),
        ),
      ),
    );
  }

  deletePopup(BuildContext context, String name) {
    var translate = translateStrings(context);

    return locator.get<WedgeDialog>().confirm(
        context,
        WedgeConfirmDialog(
          title: "Delete Documents",
          subtitle: translate!.areYouSure,
          acceptText: translate.yesDelete,
          acceptedPress: () {
            setState(() {
              _enableDelete = false;
            });
            showSnackBar(context: context, title: translate.loading);
            context.read<DocumentCubit>().deletedocumentValt(name);
            Navigator.pop(context);
          },
          deniedText: translate.noiWillKeepIt,
          deniedPress: () {
            Navigator.pop(context);
          },
        ));
  }
}

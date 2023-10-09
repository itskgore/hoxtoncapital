import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/widgets/buttons/app_button.dart';

import '../../../../../core/helpers/multi_value_notifire.dart';
import '../../../../../core/utils/wedge_app_bar.dart';
import '../../../../../core/utils/wedge_circular_progress_indicator.dart';
import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../core/utils/wedge_snackBar.dart';
import '../../../../../core/widgets/buttons/wedge_button.dart';
import '../../../../../core/widgets/dialog/custom_dialog.dart';
import '../../../../../core/widgets/dialog/custom_tooltip.dart';
import '../../../../../core/widgets/dropdown/wedge_custom_dropdown.dart';
import '../../../../../dependency_injection.dart';
import '../../data/Model/upload_document_type_model.dart';
import '../../domain/entities/upload_document_folder_entity.dart';
import '../Widget/custom_unorderd_list.dart';
import '../cubit/upload_document_cubit.dart';
import 'documents_screen.dart';

class UploadDocumentScreen extends StatefulWidget {
  final UploadDocumentTypeModel selectedDocumentModel;
  final UploadDocumentFolderEntity apiData;
  final bool routingFromMain;

  const UploadDocumentScreen(
      {super.key,
      required this.apiData,
      this.routingFromMain = false,
      required this.selectedDocumentModel});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  bool showToolTip = true;
  bool showToolTipOnButton = false;
  bool isBottomSheetVisible = false;
  List<String> typeNames = [];
  double allowedFileSize = 5;

  ValueNotifier<List> pickedFiles = ValueNotifier<List>([]);
  ValueNotifier<Set<int>> unAcceptedFileIndex = ValueNotifier<Set<int>>({});
  ValueNotifier<double> uploadFileIndex = ValueNotifier<double>(0);
  ValueNotifier<bool> isDocumentUploading = ValueNotifier<bool>(false);
  ValueNotifier<bool> isButtonDisable = ValueNotifier<bool>(false);
  ValueNotifier<String> selectedType = ValueNotifier<String>('');
  CancelToken cancelToken = CancelToken();
  bool isIndividualDocument = false;

  @override
  void initState() {
    loadDocumentTypeNames();
    isIndividualDocument = widget.selectedDocumentModel.folder != "POI" &&
        widget.selectedDocumentModel.folder != "POA";
    super.initState();
  }

  //load document subType for dropdown
  void loadDocumentTypeNames() async {
    if (widget.selectedDocumentModel.folder == "POI" ||
        widget.selectedDocumentModel.folder == "POA") {
      List<String> types = widget.selectedDocumentModel.documentType;
      typeNames = types.map((type) => type).toList();
    }
  }

  //Pick ImageFrom Gallery
  Future<void> _pickImageFromGallery() async {
    List<XFile> galleryFiles = await ImagePicker().pickMultiImage();
    if (galleryFiles.isNotEmpty) {
      pickedFiles.value.addAll(galleryFiles);
      _showUploadButtonSheet();
    }
  }

  // Pick Image File Manager
  Future<void> _pickImageFromFileManager() async {
    // Request necessary permissions for accessing storage

    bool hasPermission = await getPermission();

    try {
      if (hasPermission) {
        var newPickedFiles = await FilePicker.platform.pickFiles(
          allowMultiple: true,
        );

        /// If no file is picked.
        if (newPickedFiles != null && newPickedFiles.count != 0) {
          var tempFiles = newPickedFiles.files.map((file) {
            return FilePickerResult([file]);
          });
          pickedFiles.value.addAll(tempFiles);
          _showUploadButtonSheet();
        }
      } else {
        showSnackBar(
            context: context, title: "Permission denied to access storage.");
        // Handle permission denied
        await [
          Permission.photos,
          Permission.storage,
        ].request();
      }
    } catch (error) {
      log("Error:", error: "$error");
      showSnackBar(context: context, title: "$error");
    }
  }

  // File Extinction
  String getFileExtension(String fileName) {
    int dotIndex = fileName.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < fileName.length - 1) {
      return fileName.substring(dotIndex + 1);
    }
    return '';
  }

  //upload files on database
  void uploadFiles({required List<dynamic> files}) async {
    isDocumentUploading.value = true;
    isDocumentUploading.notifyListeners();
    List multipartFiles = [];
    for (var file in files) {
      String fileName = '';
      if (unAcceptedFileIndex.value.contains(files.indexOf(file)) == false) {
        if (file is FilePickerResult) {
          fileName = file.paths.first?.split('/').last ?? '';
        } else if (file is XFile) {
          fileName = file.path.split('/').last;
        }
        multipartFiles.add(await MultipartFile.fromFile(
            file is FilePickerResult ? file.paths.first : file.path,
            filename: fileName));
      }
    }
    FormData formData = FormData.fromMap({
      "file": multipartFiles,
    });
    try {
      context.read<UploadDocumentCubit>().uploadDocumentUseCase({
        "files": formData,
        "documentType": isIndividualDocument
            ? widget.selectedDocumentModel.name
            : selectedType.value,
        "folder": widget.selectedDocumentModel.folder
      }, cancelToken: cancelToken, onSendProgress: (int sent, int total) {
        uploadFileIndex.value = double.parse((sent / total).toStringAsFixed(2));
        uploadFileIndex.notifyListeners();
      }).then((value) {
        if (value.isRight()) {
          uploadSuccess();
        } else {
          // Clear History
          clearPreviousUploadHistory();
        }
      });
    } catch (error) {
      showSnackBar(context: context, title: "Uploading Error: $error");
    }
  }

  //cancel uploading
  void cancelUpload() {
    cancelToken.cancel("Upload request canceled.");
    clearPreviousUploadHistory();
    cancelToken = CancelToken();
    Navigator.pop(context);
    showSnackBar(
      context: context,
      title: "Upload request canceled.",
    );
  }

  void uploadSuccess() {
    // Clear History
    Navigator.pop(context);
    clearPreviousUploadHistory();
    locator.get<WedgeDialog>().success(
        context: context,
        showTitleOnly: true,
        title: translate!.uploadSuccessful,
        info: "",
        buttonLabel: "Continue",
        onClicked: () async {
          log("context: ${context.widget.runtimeType}");
          if (context.widget.runtimeType != UploadDocumentScreen) {
            Navigator.of(context).pop();
          } else {
            if (!(widget.routingFromMain)) {
              Navigator.pop(context);
            }
            Navigator.of(context).pop();

            cupertinoNavigator(
                context: context,
                screenName: DocumentsScreen(
                    apiData: widget.apiData,
                    jsonData: widget.selectedDocumentModel),
                type: NavigatorType.PUSHREPLACE);
          }
        });
  }

  // get File Size
  Future<double> getFileSize(file) async {
    var fileSize = 0;
    if (file.runtimeType == XFile) {
      fileSize = await file.length();
    } else {
      fileSize = await file.files.single.size;
    }
    var newFileSize =
        double.parse((fileSize / (1024 * 1024)).toStringAsFixed(2));

    // if file Size Extended  button will be disable
    if (isFileExtensionsAllowed(file) == false ||
        newFileSize > allowedFileSize) {
      isButtonDisable.value = true;
      isButtonDisable.notifyListeners();
    }

    return newFileSize;
  }

  //get File Extension
  bool isFileExtensionsAllowed(file) {
    final List _allowedExtensions = [
      "jpg",
      "png",
      "jpeg",
      "pdf",
    ];
    String uploadFileName =
        file.runtimeType == XFile ? file.name : file.names.first;
    String fileExtension = getFileExtension(uploadFileName);
    return _allowedExtensions.contains(fileExtension);
  }

  void clearPreviousUploadHistory() {
    uploadFileIndex.value = 0;
    pickedFiles.value.clear();
    pickedFiles.notifyListeners();
    unAcceptedFileIndex.value.clear();
    unAcceptedFileIndex.notifyListeners();
    isDocumentUploading.value = false;
    isDocumentUploading.notifyListeners();
    isButtonDisable.value = false;
    isButtonDisable.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    String titleValue =
        widget.selectedDocumentModel.name.replaceAll(RegExp(r'\s?\(.*\)'), '');
    return Scaffold(
      appBar: wedgeAppBar(context: context, title: titleValue),
      backgroundColor: appThemeColors?.bg,
      body: Stack(
        children: [
          SafeArea(
            bottom: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: size.height,
                child: ValueListenableBuilder<String>(
                    valueListenable: selectedType,
                    builder: (context, selectedDocumentType, _) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height * .02,
                              ),
                              Text(
                                isIndividualDocument
                                    ? translate!
                                        .pleaseBrowseFilesToUploadDocuments
                                    : translate!
                                        .pleaseSelectDocumentTypeMessage,
                                style: SubtitleHelper.h10
                                    .copyWith(color: Colors.black),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                        isIndividualDocument
                                            ? "${translate!.documentType} :"
                                            : "${translate!.selectDocumentType} :",
                                        style: TitleHelper.h11
                                            .copyWith(color: Colors.black)),
                                    Text("*",
                                        style: TitleHelper.h11.copyWith(
                                            color: Colors.red.shade700)),
                                  ],
                                ),
                              ),

                              // Document Type DropDown
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: size.height * .0),
                                child: isIndividualDocument
                                    ? Text(widget.selectedDocumentModel.name,
                                        style: SubtitleHelper.h11)
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          // "Begin with selecting document type",
                                          CustomToolTip(
                                            showToolTop: showToolTip,
                                            targetCenter: const Offset(120, 0),
                                            message: translate!
                                                .beginWithSelectingDocumentType,
                                            child: SizedBox(
                                                width: size.width * .4),
                                          ),
                                          SizedBox(
                                              height: 53.0,
                                              width: double.infinity,
                                              child: WedgeCustomDropDown(
                                                items: typeNames,
                                                value: selectedType.value != ''
                                                    ? selectedType.value
                                                    : null,
                                                hint: Text(translate!
                                                    .selectDocumentType),
                                                onChanged:
                                                    (String? selectedValue) {
                                                  showToolTip = false;
                                                  showToolTipOnButton = true;
                                                  selectedType.value =
                                                      selectedValue ?? "";
                                                  selectedType
                                                      .notifyListeners();
                                                },
                                              )),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Text("${translate!.documentGuidelines}:",
                                  style: TitleHelper.h11
                                      .copyWith(color: Colors.black)),
                              CustomUnOrderList(listItems: [
                                translate!
                                    .theIdentityDocumentsShouldBeCurrentWithinSixMonthsOfExpiry,
                                translate!
                                    .pleaseUploadOnlyAuthenticUnalteredOriginalDocuments,
                                translate!
                                    .forStatementsTheyShouldContainCurrentAddressAndNotBeLessThanThreeMonthsOld,
                                translate!.screenshotsOfDocumentsIsNotPermitted,
                                translate!
                                    .inTheCaseOfAPhotoPleaseEnsureNoFingersAreOverTheDocument,
                                translate!
                                    .theFourCornersOfTheDocumentShouldBeVisible,
                                translate!.permittedSizeIs5MB,
                                translate!.supportedFormatsIsPDFAndPNG,
                              ])
                            ],
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ),
          ValueListenableBuilder<String>(
              valueListenable: selectedType,
              builder: (context, selectedDocumentType, _) {
                return Positioned(
                  bottom: 0,
                  left: 15,
                  right: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomToolTip(
                          message: translate!.beginWithBrowsingFiles,
                          targetCenter: const Offset(120, 0),
                          showToolTop: isBottomSheetVisible
                              ? false
                              : (showToolTipOnButton ||
                                  ((widget.selectedDocumentModel.folder ==
                                              "POI" ||
                                          widget.selectedDocumentModel.folder ==
                                              "POA")
                                      ? selectedType.value != ''
                                      : true)),
                          child: SizedBox(
                            width: size.width * .45,
                          )),
                      Container(
                        height: 40,
                        width: size.width,
                        color: appThemeColors!.bg,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: WedgeSaveButton(
                            onPressed: () {
                              clearPreviousUploadHistory();
                              _openButtonSheet();
                            },
                            textStyle:
                                TitleHelper.h10.copyWith(color: Colors.white),
                            title: translate!.browseFiles,
                            isEnable:
                                (widget.selectedDocumentModel.folder == "POI" ||
                                        widget.selectedDocumentModel.folder ==
                                            "POA")
                                    ? selectedType.value != ''
                                    : true,
                            isLoaing: false),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  // Picker Source Bottom Sheet
  void _openButtonSheet() {
    setState(() {
      showToolTipOnButton = false;
      isBottomSheetVisible = true;
    });
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: size.height * .05),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customSheetListTile(
                context: context,
                title: translate!.gallery,
                leadingIcon: "assets/icons/gallery.png",
                onTab: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              const Divider(
                  height: 10,
                  color: Colors.black26,
                  thickness: 1,
                  indent: 25,
                  endIndent: 25),
              customSheetListTile(
                context: context,
                title: translate!.files,
                leadingIcon: "assets/icons/files.png",
                onTab: () {
                  Navigator.pop(context);
                  _pickImageFromFileManager();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Picker Source BottomSheet ListTile
  InkWell customSheetListTile(
      {required BuildContext context,
      Function()? onTab,
      String? leadingIcon,
      String? title}) {
    return InkWell(
      onTap: onTab,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Visibility(
              visible: leadingIcon != null,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 10, bottom: 10, right: 20),
                child: Image.asset(leadingIcon!, height: 17),
              ),
            ),
            Text(
              title ?? "",
              style: SubtitleHelper.h10.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  // Upload File Bottom Sheet
  void _showUploadButtonSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            cancelUpload();
            return true;
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: size.height * .03, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
            child: ValueListenableBuilder<bool>(
                valueListenable: isDocumentUploading,
                builder: (context, isDocumentUploadingValue, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate!.uploadingDocuments,
                          style: TitleHelper.h9),
                      const Divider(height: 20, thickness: 1.5),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ValueListenableBuilder<List>(
                                  valueListenable: pickedFiles,
                                  builder: (context, pickedFilesValue, _) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: pickedFilesValue.length,
                                      physics: const ScrollPhysics(
                                          parent: ClampingScrollPhysics()),
                                      itemBuilder: (context, index) {
                                        return customUploadItemListTile(
                                            pickedFilesValue: pickedFilesValue,
                                            index: index,
                                            isDocumentUploadingValue:
                                                isDocumentUploadingValue,
                                            context: context);
                                      },
                                    );
                                  }),
                            ),
                            addMoreButton(
                                isDocumentUploadingValue:
                                    isDocumentUploadingValue,
                                context: context)
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          cancelButton(context),
                          const SizedBox(
                            width: 10,
                          ),
                          submitButton(
                              isDocumentUploadingValue:
                                  isDocumentUploadingValue),
                        ],
                      )
                    ],
                  );
                }),
          ),
        );
      },
    );
  }

  // Upload Items List Tile
  Widget customUploadItemListTile(
      {required List<dynamic> pickedFilesValue,
      required int index,
      required bool isDocumentUploadingValue,
      required BuildContext context}) {
    String uploadFileName = pickedFilesValue[index].runtimeType == XFile
        ? pickedFilesValue[index].name
        : pickedFilesValue[index].names.first;

    return FutureBuilder(
        future: getFileSize(pickedFilesValue[index]),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (!(isFileExtensionsAllowed(pickedFilesValue[index])) ||
                snapshot.data! > allowedFileSize) {
              unAcceptedFileIndex.value.add(index);
            }
            Future.delayed(const Duration(milliseconds: 500), () {
              unAcceptedFileIndex.notifyListeners();
            });
          }

          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset("assets/icons/document.png", height: 20),
                  ),
                  Expanded(
                    child: Text(
                      uploadFileName,
                      style: SubtitleHelper.h11.copyWith(color: Colors.black),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  snapshot.hasData == false
                      ? buildCircularProgressIndicator()
                      : !(isFileExtensionsAllowed(pickedFilesValue[index])) ||
                              snapshot.data! > allowedFileSize
                          ? Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: SizedBox(
                                width: size.width * .4,
                                child: Text(
                                  snapshot.data! > allowedFileSize
                                      ? translate!
                                          .fileSizeExceedingAcceptableLimit
                                      : translate!.fileTypeUnacceptable,
                                  textAlign: TextAlign.end,
                                  style: SubtitleHelper.h11
                                      .copyWith(color: Colors.red.shade900),
                                ),
                              ),
                            )
                          : (isDocumentUploadingValue
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: SizedBox(
                                      width: size.width * .3,
                                      child: ValueListenableBuilder(
                                          valueListenable: uploadFileIndex,
                                          builder: (context,
                                              uploadFileIndexValue, _) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: uploadFileIndexValue,
                                                    backgroundColor:
                                                        Colors.black12,
                                                    color:
                                                        appThemeColors!.primary,
                                                  ),
                                                ),
                                                Text(
                                                    "${((uploadFileIndexValue) * 100).round()}%")
                                              ],
                                            );
                                          })),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: InkWell(
                                    child: Image.asset(
                                      'assets/icons/delete.png',
                                      height: 30,
                                    ),
                                    onTap: () {
                                      pickedFiles.value.removeAt(index);
                                      pickedFiles.notifyListeners();
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        unAcceptedFileIndex.notifyListeners();
                                      });
                                      if (pickedFilesValue.isEmpty) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ))
                ],
              ),
              const Divider(height: 20, thickness: 1.5),
            ],
          );
        });
  }

  // add More Button
  Widget addMoreButton(
      {required bool isDocumentUploadingValue, required BuildContext context}) {
    return ValueListenableBuilder<bool>(
        valueListenable: isButtonDisable,
        builder: (context, isButtonDisableValue, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: AppButton(
                label: translate!.addMore,
                color: Colors.white,
                isDisable: isDocumentUploadingValue,
                border: Border.all(
                    width: 1.2,
                    color: (isDocumentUploadingValue)
                        ? appThemeColors!.primary!.withOpacity(.4)
                        : appThemeColors!.primary!),
                borderRadius: 10,
                verticalPadding: 10,
                style: SubtitleHelper.h11.copyWith(
                    color: (isDocumentUploadingValue)
                        ? appThemeColors!.primary!.withOpacity(.4)
                        : appThemeColors!.primary!,
                    fontWeight: FontWeight.w500),
                onTap: () {
                  Navigator.pop(context);
                  _openButtonSheet();
                }),
          );
        });
  }

  // submit Button
  Widget submitButton({required bool isDocumentUploadingValue}) {
    return MultiListenableBuilder<Set<int>, bool>(
        first: unAcceptedFileIndex,
        second: isButtonDisable,
        builder: (context, unAcceptedFileIndexValue, isButtonDisableValue, _) {
          bool isSubmitButtonDisable =
              unAcceptedFileIndex.value.length == pickedFiles.value.length
                  ? true
                  : unAcceptedFileIndex.value.isNotEmpty &&
                          unAcceptedFileIndex.value.length <
                              unAcceptedFileIndex.value.length
                      ? true
                      : false;
          return Expanded(
              child: AppButton(
                  label: translate!.submit,
                  borderRadius: 10,
                  verticalPadding: 10,
                  isDisable: isDocumentUploadingValue || isSubmitButtonDisable,
                  style: SubtitleHelper.h11.copyWith(color: Colors.white),
                  onTap: () {
                    if (pickedFiles.value.isNotEmpty) {
                      uploadFiles(files: pickedFiles.value);
                    }
                  }));
        });
  }

  //cancel Button
  Expanded cancelButton(BuildContext context) {
    return Expanded(
        child: AppButton(
            label: translate!.cancel,
            color: Colors.black12,
            borderRadius: 10,
            verticalPadding: 10,
            style: SubtitleHelper.h11
                .copyWith(fontWeight: FontWeight.w500)
                .copyWith(color: Colors.black),
            onTap: () {
              cancelUpload();
            }));
  }
}

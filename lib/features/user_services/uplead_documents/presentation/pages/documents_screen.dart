import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/features/user_services/uplead_documents/presentation/pages/upload_documents_screen.dart';

import '../../../../../app.dart';
import '../../../../../core/contants/string_contants.dart';
import '../../../../../core/utils/wedge_app_bar.dart';
import '../../../../../core/utils/wedge_circular_progress_indicator.dart';
import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../core/widgets/buttons/wedge_button.dart';
import '../../../../../core/widgets/wedge_expension_tile.dart';
import '../../data/Model/upload_document_type_model.dart';
import '../../domain/entities/upload_document_folder_entity.dart';
import '../cubit/document_screen_cubit.dart';
import '../cubit/document_screen_state.dart';

class DocumentsScreen extends StatefulWidget {
  final UploadDocumentFolderEntity apiData;
  final UploadDocumentTypeModel jsonData;

  const DocumentsScreen(
      {super.key, required this.apiData, required this.jsonData});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  void RefreshScreen() {
    Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    RefreshScreen();
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
          context: navigatorKey.currentContext!, title: widget.jsonData.name),
      body: BlocConsumer<DocumentScreenCubit, DocumentScreenState>(
        bloc: context.read<DocumentScreenCubit>().getDocuments(
            GetUploadedDocumentsParams(parentFolder: widget.apiData.path)),
        listener: (context, state) {
          if (state is DocumentScreenLoadedState) {
            if (state.downloaded) {
              showSnackBar(context: context, title: 'Downloaded');
            }
          }
        },
        builder: (context, state) {
          if (state is DocumentScreenLoadingState) {
            return Center(
              child: buildCircularProgressIndicator(width: 90),
            );
          } else if (state is DocumentScreenErrorState) {
            return Center(
              child: Text(
                state.errorMsg,
                style: SubtitleHelper.h10,
              ),
            );
          } else if (state is DocumentScreenLoadedState) {
            return state.documents.isNotEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Note: ',
                                style: TitleHelper.h11.copyWith(
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: translate?.proofOfIdentityNote,
                                    style: SubtitleHelper.h11.copyWith(
                                        color: appThemeColors?.textDark,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              translate?.documents ?? '',
                              style: TitleHelper.h8.copyWith(
                                  // fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.documents.length,
                          itemBuilder: (context, index) => WedgeExpansionTile(
                            tilePadding: const EdgeInsets.only(right: 18),
                            maxLines: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
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
                            leftTitle: state.documents[index].name,
                            leftTitleStyle: SubtitleHelper.h11.copyWith(
                              color: appThemeColors?.textDark,
                              // fontWeight: FontWeight.w400,
                            ),
                            leftSubtitle: dateFormatter.format(
                                DateTime.parse(state.documents[index].updatedAt)
                                    .toLocal()),
                            leftSubtitleStyle: TitleHelper.h12.copyWith(
                              // fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            midWidget: null,
                            showLeftButton: false,
                            borderRadius: 6,
                            rightButton: Container(
                              height: 40.0,
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
                              child: TextButton(
                                onPressed: () {
                                  context
                                      .read<DocumentScreenCubit>()
                                      .downloadDocument(
                                        DownloadUploadedDocumentsParams(
                                            path: state.documents[index].path),
                                      );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/download_document_icon.png',
                                      height: 12,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      translate?.download ?? '',
                                      style: SubtitleHelper.h12.copyWith(
                                        color: Color(0xFF538EF7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 30),
                        child: SizedBox(
                          height: 48,
                          width: double.infinity,
                          //TODO: @Nikhil link to Upload screen
                          child: WedgeSaveButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => UploadDocumentScreen(
                                    selectedDocumentModel: widget.jsonData,
                                    apiData: widget.apiData,
                                  ),
                                ),
                              );
                            },
                            textStyle:
                                TitleHelper.h10.copyWith(color: Colors.white),
                            title: translate?.uploadDocuments ?? "",
                            isEnable: true,
                            isLoaing: false,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                    translate?.noDataFound ?? '',
                    style: SubtitleHelper.h10,
                  ));
          } else {
            return Center(
              child: buildCircularProgressIndicator(width: 90),
            );
          }
        },
      ),
    );
  }
}

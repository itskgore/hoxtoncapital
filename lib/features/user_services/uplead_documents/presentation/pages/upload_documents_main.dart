import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/features/user_services/uplead_documents/presentation/pages/upload_documents_screen.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/contants/theme_contants.dart';
import '../../../../../core/utils/wedge_app_bar.dart';
import '../../../../../core/utils/wedge_circular_progress_indicator.dart';
import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../core/widgets/folder_tile.dart';
import '../../data/Model/upload_document_type_model.dart';
import '../../data/datasource/local_upload_document_datasource.dart';
import '../../domain/entities/upload_document_folder_entity.dart';
import '../cubit/upload_document_main_cubit.dart';
import '../cubit/upload_document_main_state.dart';
import 'documents_screen.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  List<UploadDocumentTypeModel> documentType = [];

  loadDocumentType() async {
    DocumentTypeService service = DocumentTypeService();
    documentType = await service.getUploadDocumentTypes();
    setState(() {});
  }

  @override
  void initState() {
    loadDocumentType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
          context: context, title: translate?.uploadDocuments ?? ''),
      body: BlocBuilder<UploadDocumentMainCubit, UploadDocumentMainState>(
        bloc:
            context.read<UploadDocumentMainCubit>().getUploadDocumentFolders(),
        builder: (context, state) {
          if (state is UploadDocumentMainLoadingState) {
            return Center(
              child: buildCircularProgressIndicator(width: 90),
            );
          } else if (state is UploadDocumentMainErrorState) {
            return Center(
              child: Text(
                state.errorMsg,
                style: SubtitleHelper.h10,
              ),
            );
          } else if (state is UploadDocumentMainLoadedState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: ListView.builder(
                itemCount: documentType.length,
                itemBuilder: (context, index) {
                  UploadDocumentFolderEntity apiData = state.folders.firstWhere(
                      (element) => element.name == documentType[index].folder);
                  return FolderTile(
                    title: documentType[index].name,
                    subTitle: documentType[index].description,
                    buttonText: !apiData.hasData ? translate?.upload : null,
                    onTap: () {
                      cupertinoNavigator(
                          context: context,
                          screenName: apiData.hasData
                              ? DocumentsScreen(
                                  apiData: apiData,
                                  jsonData: documentType[index])
                              : UploadDocumentScreen(
                                  apiData: apiData,
                                  routingFromMain: true,
                                  selectedDocumentModel: documentType[index],
                                ),
                          type: NavigatorType.PUSH,
                          then: (value) {
                            loadDocumentType();
                          });
                    },
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
      ),
    );
  }
}

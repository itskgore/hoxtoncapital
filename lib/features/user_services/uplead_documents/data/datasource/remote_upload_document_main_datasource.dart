import 'dart:developer';

import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/features/user_services/uplead_documents/data/Model/upload_document_folder_model.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/error/failures.dart';

abstract class RemoteUploadDocumentMainDataSource {
  Future<List<UploadDocumentFolderModel>> getUploadDocumentFolders();
}

class RemoteUploadDocumentMainDataSourceImpl extends Repository
    implements RemoteUploadDocumentMainDataSource {
  @override
  Future<List<UploadDocumentFolderModel>> getUploadDocumentFolders() async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.get(
            '$documentVaultEndPoint/documents/listFolders?parentFolder=__uploadedDocuments',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        log(response.data.toString());
        final List<UploadDocumentFolderModel> documentFolders =
            (response.data as List)
                .map((e) => UploadDocumentFolderModel.fromJson(e))
                .toList();
        return documentFolders;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

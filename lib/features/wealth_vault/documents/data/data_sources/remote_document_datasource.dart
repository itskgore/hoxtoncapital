import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/wealth_vault/documents/data/models/document_model.dart';

abstract class DocumentDataSource {
  Future<dynamic> deleteDocument(String id);

  Future<List<DocumentValtModel>> getDocuments();

  Future<dynamic> uploadDocument(FormData data);

  Future<int> downloadDocument({String? path});
}

class DocumentDataSourceImpl extends Repository implements DocumentDataSource {
  @override
  Future<dynamic> deleteDocument(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '$documentVaultEndPoint/documents?path=$id',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return DocumentValtModel.fromJson(response.data);
      } else {
        // print("failed");
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<List<DocumentValtModel>> getDocuments() async {
    try {
      await isConnectedToInternet();

      final response =
          await Repository().dio.get('$documentVaultEndPoint/documents');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        List<DocumentValtModel> docData = [];
        for (var data in response.data) {
          docData.add(DocumentValtModel.fromJson(data));
        }

        return docData;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  @override
  Future<dynamic> uploadDocument(FormData data) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.post(
          '${documentVaultEndPoint}documents/upload?parentFolder',
          data: data,
          onSendProgress: (int sent, int total) {});

      final status = await hanldeStatusCode(response);
      if (status.status) {
        return 200;
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<int> downloadDocument({String? path}) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String? savePath;
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        if (Platform.isIOS) {
          await Directory('${appDocDir.path}/dir')
              .create(recursive: true)
              .then((Directory directory) {
            savePath = "${directory.path}/$path";
          });
        } else {
          savePath = "${dir.path}/$path";
        }
        try {
          await isConnectedToInternet();
          await Repository().dio.download(
              "${documentVaultEndPoint}documents/view?path=$path", savePath,
              onReceiveProgress: (received, total) {
            if (total != -1) {
              //you can build progressbar feature too
            }
          });
          return 200;
        } on DioException catch (e) {
          return 500;
        } catch (e) {
          throw handleThrownException(e);
        }
      } else {
        return 500;
      }
    } else {
      return 500;
    }
  }
}

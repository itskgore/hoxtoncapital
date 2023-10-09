import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wedge/core/config/repository_config.dart';

import '../../../../../../core/config/app_config.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../core/utils/wedge_func_methods.dart';
import '../Model/uploaded_document_model.dart';

abstract class RemoteViewUploadedDocumentsDatasource {
  Future<List<UploadedDocument>> getUploadedDocuments(String parentFolder);

  Future<int> downloadUploadedDocuments(String path);
}

class RemoteViewUploadedDocumentsIpl extends Repository
    implements RemoteViewUploadedDocumentsDatasource {
  @override
  Future<List<UploadedDocument>> getUploadedDocuments(
      String parentFolder) async {
    log(parentFolder);
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.get(
            '$documentVaultEndPoint/documents?parentFolder=$parentFolder',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        log(response.data.toString());
        final List<UploadedDocument> uploadedDocuments = (response.data as List)
            .map((e) => UploadedDocument.fromJson(e))
            .toList();
        return uploadedDocuments;
      } else {
        log("failed to get documents from folder path: $parentFolder");
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<int> downloadUploadedDocuments(String path) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String? savePath;

    bool hasPermission = await getPermission();

    if (hasPermission) {
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
          log(savePath!);
          await isConnectedToInternet();
          await Repository().dio.download(
              '$documentVaultEndPoint/documents/view?path=$path', savePath,
              onReceiveProgress: (received, total) {
            if (total != -1) {
              log("${(received / total * 100).toStringAsFixed(0)}%");
              //you can build progressbar feature too
            }
          }).then((value) {
            log(value.statusCode.toString());
            // log(value.statusMessage.toString());
          });
          // log("File is saved to download folder.");
          return 200;
        } on DioException catch (e) {
          log('Error while downloading file: ${e.message}');
          return 500;
        } catch (e) {
          throw handleThrownException(e);
        }
      } else {
        return 500;
      }
    } else {
      log("No permission to read and write.");

      return 500;
    }
  }
}

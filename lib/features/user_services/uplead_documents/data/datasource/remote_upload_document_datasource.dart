import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wedge/app.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/config/repository_config.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/widgets/dialog/custom_dialog.dart';
import '../../../../../core/widgets/dialog/wedge_new_custom_dialog_box.dart';
import '../../../../../dependency_injection.dart';

abstract class UploadDocumentDataSource {
  Future<List> uploadDocuments(Map<String, dynamic> body,
      {Function(int, int)? onSendProgress, CancelToken? cancelToken});
}

class UploadDocumentSourceImp extends Repository
    implements UploadDocumentDataSource {
  UploadDocumentSourceImp();

  @override
  Future<List> uploadDocuments(Map<String, dynamic> body,
      {Function(int, int)? onSendProgress, CancelToken? cancelToken}) async {
    try {
      await isConnectedToInternet();
      String url =
          '$documentVaultEndPoint/documents/upload?parentFolder=__uploadedDocuments/${body["folder"]}&documentType=${body["documentType"]}';
      log(url.toString());
      final response = await Repository().dio.post(
            url,
            data: body['files'],
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
          );
      final status = await hanldeStatusCode(response);
      if (response.statusCode == 413) {
        Navigator.pop(navigatorKey.currentContext!);
        locator.get<WedgeDialog>().confirm(navigatorKey.currentContext!,
            Builder(builder: (context) {
          return NewCustomDialogBox(
            showWarningIcon: true,
            title: "Upload Failed",
            description: "Maximum upload limit: 20 files",
            primaryButtonText: "Continue",
            onPressedPrimary: () {
              Navigator.pop(navigatorKey.currentContext!);
            },
          );
        }));
        return response.data;
      } else if (status.status) {
        return response.data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioErrorType.cancel) {
          print("Request was canceled");
        } else {
          print("An error occurred: $e");
        }
      }
      throw handleThrownException(e);
    }
  }
}

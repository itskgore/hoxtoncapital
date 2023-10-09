import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/pension_report_model.dart';
import 'package:wedge/core/data_models/user_services_document_model.dart';
import 'package:wedge/core/data_models/user_services_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';

abstract class GenericServicesDataSource {
  Future<UserServicesModel> getAllPlugins();

  Future<List<Map<String, dynamic>>> getAdvisors(
      Map<String, dynamic> body, String urlParameters);

  Future<UserDocumentRecords> getDocuments(
      Map<String, dynamic> body, String urlParameters);

  Future<int> downloadDocuments(
      {Map<String, dynamic>? body, String? urlParameters});

  Future<PensionReport> getPensionReport(String urlParameters);
}

class GenericServicesDataSourceImp extends GenericServicesDataSource {
  @override
  Future<UserServicesModel> getAllPlugins() async {
    try {
      await isConnectedToInternetData();
      final result = await Repository().dio.get(
            "${userServicesEndPoint}plugins",
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        return UserServicesModel.fromJson(result.data);
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAdvisors(
      Map<String, dynamic> body, String urlParameters) async {
    try {
      await Repository().isConnectedToInternet();

      final result = await Repository()
          .dio
          .post("${userServicesEndPoint}plugins/$urlParameters", data: {});
      final status = await hanldeStatusCode(result);
      if (status.status) {
        List<Map<String, dynamic>> userAdvisorModel = [];
        result.data.forEach((e) {
          userAdvisorModel.add(e);
        });
        return userAdvisorModel;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<UserDocumentRecords> getDocuments(
      Map<String, dynamic> body, String urlParameters) async {
    try {
      final result = await Repository()
          .dio
          .post("${userServicesEndPoint}plugins/$urlParameters", data: body);
      final status = await hanldeStatusCode(result);
      if (status.status) {
        return UserDocumentRecords.fromJson(result.data);
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<int> downloadDocuments(
      {Map<String, dynamic>? body, String? urlParameters}) async {
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
            savePath = "${directory.path}/${body?['fileName']}";
          });
        } else {
          savePath = "${dir.path}/${body?['fileName']}";
        }

        String url = "${userServicesEndPoint}plugins/$urlParameters";
        try {
          final data = await Repository().dio.download(url, savePath,
              options: Options(
                method: 'POST',
              ),
              data: {"fullPath": body?["fullPath"]},
              // queryParameters: {"fullPath": body["fullPath"]},
              onReceiveProgress: (received, total) {
            if (total != -1) {
              // print((received / total * 100).toStringAsFixed(0) + "%");
            }
          });
          // print("$data is saved to download folder.");
          final status = await hanldeStatusCode(data);
          if (status.status) {
            return 200;
          } else {
            throw status.failure ?? ServerFailure();
          }
        } on DioException catch (e) {
          // print(e.message);
          return 500;
        } catch (e) {
          throw handleThrownException(e);
        }
      } else {
        return 500;
      }
    } else {
      // print("No permission to read and write.");

      return 500;
    }
  }

  @override
  Future<PensionReport> getPensionReport(String urlParameters) async {
    try {
      final result = await Repository()
          .dio
          .post("${userServicesEndPoint}plugins/$urlParameters", data: {});
      final status = await hanldeStatusCode(result);
      if (status.status) {
        return PensionReport.fromJson(result.data);
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

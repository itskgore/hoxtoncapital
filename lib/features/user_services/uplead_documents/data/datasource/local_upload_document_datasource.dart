import 'dart:convert';

import 'package:flutter/services.dart';

import '../Model/upload_document_type_model.dart';

class DocumentTypeService {
  Future<List<UploadDocumentTypeModel>> getUploadDocumentTypes() async {
    // Load JSON data from a local asset file
    String jsonString =
        await rootBundle.loadString('assets/json/documentUpload.json');

    // Decode JSON and map to UploadDocumentTypeModel list
    List<dynamic> jsonList = json.decode(jsonString);
    List<UploadDocumentTypeModel> documentTypes = jsonList
        .map((jsonObject) => UploadDocumentTypeModel.fromJson(jsonObject))
        .toList();
    return documentTypes;
  }
}

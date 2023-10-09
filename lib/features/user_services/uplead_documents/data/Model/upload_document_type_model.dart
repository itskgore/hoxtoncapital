import 'dart:convert';

class UploadDocumentTypeModel {
  final String folder;
  final String name;
  final String description;
  final List<String> documentType;

  UploadDocumentTypeModel({
    required this.folder,
    required this.name,
    required this.description,
    required this.documentType,
  });

  factory UploadDocumentTypeModel.fromRawJson(String str) =>
      UploadDocumentTypeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UploadDocumentTypeModel.fromJson(Map<String, dynamic> json) =>
      UploadDocumentTypeModel(
        folder: json["folder"],
        name: json["name"],
        description: json["description"],
        documentType: List<String>.from(json["documentType"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "folder": folder,
        "name": name,
        "description": description,
        "documentType": List<dynamic>.from(documentType.map((x) => x)),
      };
}

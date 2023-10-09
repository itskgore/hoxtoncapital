import '../../domain/entities/upload_document_folder_entity.dart';

class UploadDocumentFolderModel extends UploadDocumentFolderEntity {
  final String name;
  final bool hasData;
  final int count;
  final String path;

  UploadDocumentFolderModel({
    required this.name,
    required this.hasData,
    required this.count,
    required this.path,
  }) : super(
          name: name,
          hasData: hasData,
          count: count,
          path: path,
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hasData': hasData,
      'count': count,
      'path': path,
    };
  }

  // JSON deserialization
  factory UploadDocumentFolderModel.fromJson(Map<String, dynamic> json) {
    return UploadDocumentFolderModel(
      name: json['name'],
      hasData: json['hasData'],
      count: json['count'],
      path: json['path'],
    );
  }
}

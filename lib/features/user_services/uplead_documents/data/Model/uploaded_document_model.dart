import '../../domain/entities/uploaded_document_entity.dart';

class UploadedDocument extends UploadedDocumentEntity {
  UploadedDocument({
    required String name,
    required String path,
    required String type,
    required int size,
    required String updatedAt,
    // Add any additional properties specific to UploadedDocument here
  }) : super(
          name: name,
          path: path,
          type: type,
          size: size,
          updatedAt: updatedAt,
        );

  // Add any additional methods or properties specific to UploadedDocument here

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type,
      'size': size,
      'updatedAt': updatedAt,
      // Add any additional properties to the JSON representation here
    };
  }

  factory UploadedDocument.fromJson(Map<String, dynamic> json) {
    return UploadedDocument(
      name: json['name'],
      path: json['path'],
      type: json['type'],
      size: json['size'],
      updatedAt: json['updatedAt'],
      // Extract and assign any additional properties from the JSON here
    );
  }
}

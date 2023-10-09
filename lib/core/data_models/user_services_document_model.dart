import 'dart:developer';

import 'package:wedge/core/entities/user_services_document_entity.dart';

class UserDocumentRecords extends UserDocumentRecordsEntity {
  final List<DocumentRecords> records;

  UserDocumentRecords({required this.records}) : super(records: records);

  factory UserDocumentRecords.fromJson(Map<String, dynamic> json) {
    return UserDocumentRecords(
      records: List.from(json['records'] ?? {})
          .map((e) => DocumentRecords.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['records'] = records.map((v) => v.toJson()).toList();
    return data;
  }
}

class DocumentRecords extends DocumentRecordsEntity {
  final dynamic id;
  final bool isFolder;
  final bool hasFiles;
  final String parentFolderId;
  final String name;
  final String contentType;
  final String fullPath;
  final String lastUpdatedAt;

  DocumentRecords({
    required this.id,
    required this.isFolder,
    required this.hasFiles,
    required this.parentFolderId,
    required this.name,
    required this.contentType,
    required this.fullPath,
    required this.lastUpdatedAt,
  }) : super(
            contentType: contentType,
            fullPath: fullPath,
            id: id,
            isFolder: isFolder,
            hasFiles: hasFiles,
            name: name,
            parentFolderId: parentFolderId,
            lastUpdatedAt: lastUpdatedAt);

  factory DocumentRecords.fromJson(Map<String, dynamic> json) {
    return DocumentRecords(
      contentType: json['contentType'] ?? "",
      fullPath: json['fullPath'] ?? "",
      id: json['id'] ?? "",
      isFolder: json['isFolder'] ?? "",
      name: json['name'] ?? "",
      parentFolderId: json['parentFolderId'] ?? "",
      hasFiles: json['hasFiles'] ?? false,
      lastUpdatedAt: json['lastUpdatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['isFolder'] = isFolder;
    data['parentFolderId'] = parentFolderId;
    data['name'] = name;
    data['contentType'] = contentType;
    data['fullPath'] = fullPath;
    return data;
  }
}

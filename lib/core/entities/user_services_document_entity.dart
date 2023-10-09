class UserDocumentRecordsEntity {
  final List<DocumentRecordsEntity> records;

  UserDocumentRecordsEntity({required this.records});
}

class DocumentRecordsEntity {
  final dynamic id;
  final bool isFolder;
  final bool hasFiles;
  final String parentFolderId;
  final String name;
  final String contentType;
  final String fullPath;
  final String lastUpdatedAt;

  DocumentRecordsEntity(
      {required this.id,
      required this.isFolder,
      required this.hasFiles,
      required this.parentFolderId,
      required this.name,
      required this.contentType,
      required this.fullPath,
      required this.lastUpdatedAt});
}

class UploadDocumentFolderEntity {
  final String name;
  final bool hasData;
  final int count;
  final String path;

  UploadDocumentFolderEntity(
      {required this.name,
      required this.hasData,
      required this.count,
      required this.path});
}

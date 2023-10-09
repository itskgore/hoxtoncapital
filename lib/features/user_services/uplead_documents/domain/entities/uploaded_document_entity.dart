class UploadedDocumentEntity {
  UploadedDocumentEntity({
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    required this.updatedAt,
  });

  final String name;
  final String path;
  final String updatedAt;
  final String type;
  final int size;
}

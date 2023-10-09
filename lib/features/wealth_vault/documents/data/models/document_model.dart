import 'package:wedge/features/wealth_vault/documents/domain/entities/document_entity.dart';

class DocumentValtModel extends DocumentValtEntity {
  DocumentValtModel({
    required this.name,
  }) : super(name: name);
  late String name;

  factory DocumentValtModel.fromJson(Map<String, dynamic> json) {
    return DocumentValtModel(name: json['name'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    return _data;
  }
}

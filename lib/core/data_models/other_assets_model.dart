import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/other_assets.dart';

class OtherAssetsModel extends OtherAssetsEntity {
  OtherAssetsModel({
    required this.id,
    required this.name,
    required this.type,
    required this.country,
    required this.value,
    required this.source,
  }) : super(
            id: id,
            name: name,
            type: type,
            country: country,
            value: value,
            source: source);
  late final String id;
  late final String name;
  late final String type;
  late final String country;
  final ValueModel value;
  late final String source;

  factory OtherAssetsModel.fromJson(Map<String, dynamic> json) {
    return OtherAssetsModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      type: json['type'] ?? "",
      country: json['country'] ?? "",
      value: ValueModel.fromJson(json['value'] ?? {}),
      source: json['source'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['type'] = type;
    _data['country'] = country;
    _data['value'] = value.toJson();
    _data['source'] = source;
    return _data;
  }
}

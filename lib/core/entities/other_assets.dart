import 'package:wedge/core/entities/value_entity.dart';

class OtherAssetsEntity {
  OtherAssetsEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.country,
    required this.value,
    required this.source,
  });

  late final String id;
  late final String name;
  late final String type;
  late final String country;
  late final ValueEntity value;
  late final String source;

  List<Object> get props => [id, name, type, country, value];
}

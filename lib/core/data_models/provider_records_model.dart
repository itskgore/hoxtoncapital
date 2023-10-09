import 'package:wedge/core/entities/provider_records_entity.dart';

class ProviderResponseModel extends ProviderResponseEntity {
  ProviderResponseModel({
    required this.cursor,
    required this.records,
  }) : super(
          cursor: cursor,
          records: records,
        );
  final ProviderCursorModel cursor;
  final List<ProviderRecordsModel> records;

  factory ProviderResponseModel.fromJson(Map<String, dynamic> json) {
    return ProviderResponseModel(
      cursor: ProviderCursorModel.fromJson(
        //ValueModel.fromJson(json['outstandingAmount'] ?? {})
        json['cursor'] ?? {},
      ),
      records: List.from(json['records'] ?? {})
          .map((e) => ProviderRecordsModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cursor'] = cursor.toJson();
    _data['records'] = records.map((e) => e.toJson()).toList();

    return _data;
  }
}

class ProviderRecordsModel extends ProviderRecordsEntity {
  ProviderRecordsModel({
    required this.id,
    required this.integrator,
    required this.institution,
    required this.institutionId,
    required this.country,
    required this.logo,
  }) : super(
            id: id,
            integrator: integrator,
            institution: institution,
            institutionId: institutionId,
            country: country,
            logo: logo);
  late final String id;
  late String integrator;
  late String institution;
  late final dynamic institutionId;
  late String country;
  late String logo;

  factory ProviderRecordsModel.fromJson(Map<String, dynamic> json) {
    return ProviderRecordsModel(
      id: json['_id'],
      integrator: json['integrator'],
      institution: json['institution'],
      institutionId: json['institutionId'],
      country: json['country'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['integrator'] = integrator;
    _data['institution'] = institution;
    _data['institutionId'] = institutionId;
    _data['country'] = country;
    _data['logo'] = logo;
    return _data;
  }
}

class ProviderCursorModel extends ProviderCursorEntity {
  ProviderCursorModel({
    required this.currentPage,
    required this.perPage,
    required this.totalRecords,
  }) : super(
          currentPage: currentPage,
          perPage: perPage,
          totalRecords: totalRecords,
        );
  late final int currentPage;
  late final int perPage;
  late final int totalRecords;

  factory ProviderCursorModel.fromJson(Map<String, dynamic> json) {
    return ProviderCursorModel(
      currentPage: json['currentPage'],
      perPage: json['perPage'],
      totalRecords: json['totalRecords'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['currentPage'] = currentPage;
    _data['perPage'] = perPage;
    _data['totalRecords'] = totalRecords;

    return _data;
  }
}

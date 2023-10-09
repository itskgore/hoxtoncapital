class ProviderResponseEntity {
  ProviderResponseEntity({
    required this.cursor,
    required this.records,
  });

  late final ProviderCursorEntity cursor;
  late final List<ProviderRecordsEntity> records;
}

class ProviderRecordsEntity {
  ProviderRecordsEntity({
    required this.id,
    required this.integrator,
    required this.institution,
    required this.institutionId,
    required this.country,
    required this.logo,
  });
  late final String id;
  late String integrator;
  late String institution;
  late final dynamic institutionId;
  late String country;
  late String logo;

  List<Object> get props =>
      [id, integrator, institution, institutionId, country, logo];
}

class ProviderCursorEntity {
  ProviderCursorEntity({
    required this.currentPage,
    required this.perPage,
    required this.totalRecords,
  });

  late final int currentPage;
  late final int perPage;
  late final int totalRecords;
}

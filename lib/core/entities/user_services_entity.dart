class UserServicesEntity {
  final CursorEntity cursor;
  final List<RecordsEntity> records;

  UserServicesEntity({required this.cursor, required this.records});
}

class CursorEntity {
  final num currentPage;
  final num perPage;
  final num totalRecords;

  CursorEntity(
      {required this.currentPage,
      required this.perPage,
      required this.totalRecords});
}

class RecordsEntity {
  final String? sId;
  final String? tenant;
  final String code;
  final String name;
  final String? type;
  final String? description;
  final List<TemplatesEntity>? templates;
  final String? icon;
  final String? baseUrl;
  final List<ContextEntity>? context;
  final List<ServicesEntity>? services;
  final bool? isActive;
  final bool isVisible;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  RecordsEntity(
      {this.sId,
      this.tenant,
      required this.code,
      required this.name,
      required this.isVisible,
      this.type,
      this.description,
      this.templates,
      this.icon,
      this.baseUrl,
      this.context,
      this.services,
      this.isActive,
      this.id,
      this.createdAt,
      this.updatedAt});
}

class TemplatesEntity {
  final String id;
  final String name;
  final String template;

  TemplatesEntity(
      {required this.id, required this.name, required this.template});
}

class ContextEntity {
  final String name;
  final String value;
  final String inn;

  ContextEntity({required this.name, required this.value, required this.inn});
}

class ServicesEntity {
  final String id;
  final String name;
  final String code;
  final String httpMethod;
  final String description;
  final String urlSchema;
  final bool launchExternally;
  final RequestEntity request;
  final RequestEntity response;
  final bool isActive;

  ServicesEntity(
      {required this.id,
      required this.name,
      required this.code,
      required this.httpMethod,
      required this.description,
      required this.urlSchema,
      required this.launchExternally,
      required this.request,
      required this.response,
      required this.isActive});
}

class RequestEntity {
  final String contentType;

  RequestEntity({required this.contentType});
}

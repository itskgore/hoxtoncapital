import 'package:wedge/core/entities/user_services_entity.dart';

class UserServicesModel extends UserServicesEntity {
  final Cursor cursor;
  final List<Records> records;

  UserServicesModel({required this.cursor, required this.records})
      : super(cursor: cursor, records: records);

  factory UserServicesModel.fromJson(Map<String, dynamic> json) {
    return UserServicesModel(
        cursor: Cursor.fromJson(json['cursor'] ?? {}),
        records: List.from(json['records'] ?? {})
            .map((e) => Records.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cursor'] = cursor;
    data['records'] = records.map((v) => v.toJson()).toList();
    return data;
  }
}

class Cursor extends CursorEntity {
  final num currentPage;
  final num perPage;
  final num totalRecords;

  Cursor(
      {required this.currentPage,
      required this.perPage,
      required this.totalRecords})
      : super(
            totalRecords: totalRecords,
            perPage: perPage,
            currentPage: currentPage);

  factory Cursor.fromJson(Map<String, dynamic> json) {
    return Cursor(
        currentPage: json['currentPage'] ?? 0,
        perPage: json['currentPage'] ?? 0,
        totalRecords: json['totalRecords'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['perPage'] = perPage;
    data['totalRecords'] = totalRecords;
    return data;
  }
}

class Records extends RecordsEntity {
  final String? sId;
  final String? tenant;
  final String code;
  final String name;
  final String? type;
  final String? description;
  final List<Templates>? templates;
  final String? icon;
  final String? baseUrl;
  final List<Context>? context;
  final List<Services>? services;
  final bool? isActive;
  final bool isVisible;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  Records({
    this.sId,
    this.tenant,
    required this.isVisible,
    required this.code,
    required this.name,
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
    this.updatedAt,
  }) : super(
            baseUrl: baseUrl,
            code: code,
            context: context,
            createdAt: createdAt,
            description: description,
            icon: icon,
            isVisible: isVisible,
            id: id,
            isActive: isActive,
            name: name,
            sId: sId,
            services: services,
            templates: templates,
            tenant: tenant,
            type: type,
            updatedAt: updatedAt);

  factory Records.fromJson(Map<String, dynamic> json) {
    return Records(
      baseUrl: json['baseUrl'] ?? "",
      isVisible: json['isVisible'] ?? false,
      code: json['code'] ?? "",
      context: List.from(json['context'] ?? {})
          .map((e) => Context.fromJson(e))
          .toList(),
      createdAt: json['createdAt'] ?? "",
      description: json['description'] ?? "",
      icon: json['icon'] ?? "",
      id: json['id'] ?? "",
      isActive: json['isActive'] ?? false,
      name: json['name'] ?? "",
      sId: json['sId'] ?? "",
      services: List.from(json['services'] ?? {})
          .map((e) => Services.fromJson(e))
          .toList(),
      templates: List.from(json['templates'] ?? {})
          .map((e) => Templates.fromJson(e))
          .toList(),
      tenant: json['tenant'] ?? "",
      type: json['type'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['tenant'] = tenant;
    data['code'] = code;
    data['isVisible'] = isVisible;
    data['name'] = name;
    data['type'] = type;
    data['description'] = description;
    data['templates'] = templates?.map((v) => v.toJson()).toList() ?? [];
    data['icon'] = icon;
    data['baseUrl'] = baseUrl;
    data['context'] = context?.map((v) => v.toJson()).toList();
    data['services'] = services?.map((v) => v.toJson()).toList() ?? [];
    data['isActive'] = isActive;
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Templates extends TemplatesEntity {
  final String id;
  final String name;
  final String template;

  Templates({required this.id, required this.name, required this.template})
      : super(id: id, name: name, template: template);

  factory Templates.fromJson(Map<String, dynamic> json) {
    return Templates(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        template: json['template'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['template'] = template;
    return data;
  }
}

class Context extends ContextEntity {
  final String name;
  final String value;
  final String inn;

  Context({required this.name, required this.value, required this.inn})
      : super(inn: inn, name: name, value: value);

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
        name: json['name'] ?? "",
        value: json['value'] ?? "",
        inn: json['in'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    data['in'] = inn;
    return data;
  }
}

class Services extends ServicesEntity {
  final String id;
  final String name;
  final String code;
  final String httpMethod;
  final String description;
  final String urlSchema;
  final bool launchExternally;
  final Request request;
  final Request response;
  final bool isActive;

  Services(
      {required this.id,
      required this.name,
      required this.code,
      required this.httpMethod,
      required this.description,
      required this.urlSchema,
      required this.launchExternally,
      required this.request,
      required this.response,
      required this.isActive})
      : super(
            code: code,
            description: description,
            httpMethod: httpMethod,
            id: id,
            isActive: isActive,
            launchExternally: launchExternally,
            name: name,
            request: request,
            response: response,
            urlSchema: urlSchema);

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        code: json['code'] ?? "",
        httpMethod: json['httpMethod'] ?? "",
        description: json['description'] ?? "",
        urlSchema: json['urlSchema'] ?? "",
        launchExternally: json['launchExternally'] ?? false,
        request: Request.fromJson(json['request'] ?? {}),
        response: Request.fromJson(json['response'] ?? {}),
        isActive: json['isActive'] ?? {});
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['httpMethod'] = httpMethod;
    data['description'] = description;
    data['urlSchema'] = urlSchema;
    data['launchExternally'] = launchExternally;
    data['request'] = request;
    data['response'] = response;
    data['isActive'] = isActive;
    return data;
  }
}

class Request extends RequestEntity {
  final String contentType;

  Request({required this.contentType}) : super(contentType: contentType);

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(contentType: json['contentType'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contentType'] = contentType;
    return data;
  }
}

import 'package:wedge/core/entities/notification_entity.dart';

import 'aggregator_model.dart';
import '../../features/home/data/model/banner_model.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel(
      {this.sId,
      this.type,
      this.displayAs,
      this.message,
      this.startDate,
      this.endDate,
      this.extras,
      this.isActive,
      this.pseudonym,
      this.tenant,
      this.id,
      this.createdAt,
      this.updatedAt})
      : super(
            sId: sId,
            type: type,
            displayAs: displayAs,
            message: message,
            startDate: startDate,
            endDate: endDate,
            extras: extras,
            isActive: isActive,
            pseudonym: pseudonym,
            tenant: tenant,
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt);

  final dynamic sId;
  final String? type;
  final String? displayAs;
  final Message? message;
  final String? startDate;
  final String? endDate;
  final ExtrasModel? extras;
  final bool? isActive;
  final String? pseudonym;
  final String? tenant;
  final dynamic id;
  final String? createdAt;
  final String? updatedAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      sId: json['_id'] ?? '',
      type: json['type'] ?? '',
      displayAs: json['displayAs'] ?? '',
      message:
          json['message'] != null ? Message.fromJson(json['message']) : null,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      extras:
          json['extras'] != null ? ExtrasModel.fromJson(json['extras']) : null,
      isActive: json['isActive'] ?? false,
      pseudonym: json['pseudonym'] ?? '',
      tenant: json['tenant'] ?? '',
      id: json['id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['type'] = type;
    data['displayAs'] = displayAs;
    data['message'] = message?.toJson();
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['extras'] = extras?.toJson();
    data['isActive'] = isActive;
    data['pseudonym'] = pseudonym;
    data['tenant'] = tenant;
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ExtrasModel extends ExtrasEntity {
  ExtrasModel(
      {this.fiType,
      this.type,
      this.id,
      this.source,
      this.instituteId,
      this.providerName,
      this.aggregatorId,
      this.status,
      this.aggregator})
      : super(
            fiType: fiType,
            type: type,
            id: id,
            source: source,
            instituteId: instituteId,
            providerName: providerName,
            aggregatorId: aggregatorId,
            status: status,
            aggregator: aggregator);

  final String? fiType;
  final String? type;
  final dynamic id;
  final String? source;
  final dynamic instituteId;
  final String? providerName;
  final dynamic aggregatorId;
  final String? status;
  final AggregatorModel? aggregator;

  factory ExtrasModel.fromJson(Map<String, dynamic> json) {
    return ExtrasModel(
      fiType: json['fiType'] ?? '',
      type: json['type'] ?? '',
      id: json['id'] ?? '',
      source: json['source'] ?? '',
      instituteId: json['instituteId'] ?? '',
      providerName: json['providerName'] ?? '',
      aggregatorId: json['aggregatorId'] ?? '',
      status: json['status'] ?? '',
      aggregator: json['aggregator'] != null
          ? AggregatorModel.fromJson(json['aggregator'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['fiType'] = fiType;
    data['type'] = type;
    data['id'] = id;
    data['source'] = source;
    data['instituteId'] = instituteId;
    data['providerName'] = providerName;
    data['aggregatorId'] = aggregatorId;
    data['status'] = status;
    data['aggregator'] = aggregator?.toJson();
    return data;
  }
}

import 'package:wedge/core/data_models/aggregator_model.dart';
import 'package:wedge/core/data_models/notification_model.dart';

import '../../features/home/data/model/banner_model.dart';
import 'aggregator_entity.dart';

class NotificationEntity {
  dynamic sId;
  String? type;
  String? displayAs;
  Message? message;
  String? startDate;
  String? endDate;
  ExtrasEntity? extras;
  bool? isActive;
  String? pseudonym;
  String? tenant;
  dynamic id;
  String? createdAt;
  String? updatedAt;

  NotificationEntity(
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
      this.updatedAt});
}

class ExtrasEntity {
  String? fiType;
  String? type;
  dynamic id;
  String? source;
  dynamic instituteId;
  String? providerName;
  dynamic aggregatorId;
  String? status;
  AggregatorEntity? aggregator;

  ExtrasEntity(
      {this.fiType,
      this.type,
      this.id,
      this.source,
      this.instituteId,
      this.providerName,
      this.aggregatorId,
      this.status,
      this.aggregator});
}

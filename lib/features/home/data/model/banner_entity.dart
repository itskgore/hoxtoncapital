import 'banner_model.dart';

class BannerEntity {
  String? sId;
  String? tenant;
  String? pseudonym;
  String? type;
  Message? message;
  String? startDate;
  String? endDate;
  bool? isActive;
  String? id;
  String? createdAt;
  String? updatedAt;

  BannerEntity(
      {this.sId,
      this.tenant,
      this.pseudonym,
      this.type,
      this.message,
      this.startDate,
      this.endDate,
      this.isActive,
      this.id,
      this.createdAt,
      this.updatedAt});
}

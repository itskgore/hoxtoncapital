import 'package:wedge/features/home/data/model/banner_entity.dart';

class BannerModel extends BannerEntity {
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

  BannerModel(
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

  BannerModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tenant = json['tenant'];
    pseudonym = json['pseudonym'];
    type = json['type'];
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
    startDate = json['startDate'];
    endDate = json['endDate'];
    isActive = json['isActive'];
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['tenant'] = tenant;
    data['pseudonym'] = pseudonym;
    data['type'] = type;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['isActive'] = isActive;
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Message {
  String? mobile;
  String? web;

  Message({this.mobile, this.web});

  Message.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    web = json['web'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['mobile'] = mobile;
    data['web'] = web;
    return data;
  }
}

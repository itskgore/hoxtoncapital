import 'package:flutter/material.dart';

class UserCardsData {
  List<String> cardNumber;
  String cardId;
  String cardExp;
  List<Color> gradient;

  UserCardsData({this.cardNumber, this.cardId, this.cardExp, this.gradient});

  UserCardsData.fromJson(Map<String, dynamic> json) {
    cardNumber = json['cardNumber'].cast<int>();
    cardId = json['cardId'];
    cardExp = json['cardExp'];
    gradient = json['gradient'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNumber'] = this.cardNumber;
    data['cardId'] = this.cardId;
    data['cardExp'] = this.cardExp;
    data['gradient'] = this.gradient;
    return data;
  }
}

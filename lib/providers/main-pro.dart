import 'package:flutter/material.dart';
import 'package:hoxtoncapital/models/top_community_user.dart';
import 'package:hoxtoncapital/services/api_calls.dart';
import 'package:provider/provider.dart';

class MainProvider with ChangeNotifier {
  // Top-Community Data model
  List<TopUserComm> _topUserComm = [];
  List<TopUserComm> get topUserComm {
    return _topUserComm ?? [];
  }

  API api = new API();

  static MainProvider of(BuildContext context, {listen: false}) {
    return Provider.of<MainProvider>(context, listen: listen);
  }

  Future<void> getTopUserCommData() async {
    try {
      final resp =
          await api.getCalls(url: "https://jsonplaceholder.typicode.com/users");
      if (resp['status']) {
        final data = resp['data'] as List;
        data.forEach((element) {
          _topUserComm.add(TopUserComm.fromJson(element));
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

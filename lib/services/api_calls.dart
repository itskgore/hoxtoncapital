import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class API {
  //:NOTE - If we have headers for any api request it will be saved in constants and if these
  //        headers keeps on changing as per API calls we need to send the header changed content from the providers just like we doo for url

  // GET CALL
  Future<Map<String, dynamic>> getCalls({@required String url}) async {
    if (await checkInternetConnection()) {
      try {
        final response = await http.get(Uri.parse(url));
        if (checkStatus(response)) {
          final responseData = jsonDecode(response.body) as dynamic;
          return reponseData(true, "Data fetched!", data: responseData);
        } else {
          return reponseData(
            true,
            "Http request failed",
          );
        }
      } catch (e) {
        return reponseData(false, "Something went wrong please try again!");
      }
    } else {
      return reponseData(false, "No Internet connection!");
    }
  }

  // API CONSTANTS :
  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Map<String, dynamic> reponseData(bool status, String msg, {dynamic data}) {
    return {"msg": msg, "status": status, "data": data ?? null};
  }

  bool checkStatus(http.Response result) {
    if (result.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

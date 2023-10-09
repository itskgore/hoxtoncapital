import 'dart:convert';

import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteSupportAccountDataSource {
  Future<Map<String, dynamic>> postSupport(Map<String, dynamic> body);
}

class RemoteSupportAccountDataSourceImp extends Repository
    implements RemoteSupportAccountDataSource {
  @override
  Future<Map<String, dynamic>> postSupport(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final result = await Repository()
          .dio
          .post('/supportTickets', data: json.encode(body));
      final status = await hanldeStatusCode(result);
      if (status.status) {
        return result.data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:Instasnitch/data/models/exceptions.dart';
import 'api_utils.dart';

class AccountApi {
  Future<String> getAccount({required String accountName}) async {
    try {
      final Uri accountUri = ApiAddress.getFake(accountName);
      final http.Response searchResponse = await http.get(accountUri).timeout(Duration(seconds: 20));
      if (searchResponse.statusCode == 200) {
        return searchResponse.body;
      } else {
        throw ConnectionException('status code: ${searchResponse.statusCode}');
      }
    } on TimeoutException {
      throw ConnectionTimeoutException();
    } catch (e) {
      throw ConnectionException('error: $e');
    }
  }

  Future<String> getGraphQl({required String accountName}) async {
    try {
      final Uri accountUri = ApiAddress.getGraphQl(accountName);
      final http.Response searchResponse = await http.get(accountUri).timeout(Duration(seconds: 20));
      if (searchResponse.statusCode == 200) {
        return searchResponse.body;
      } else {
        throw ConnectionException('status code: ${searchResponse.statusCode}');
      }
    } on TimeoutException {
      throw ConnectionTimeoutException();
    } catch (e) {
      throw ConnectionException('error: $e');
    }
  }
}

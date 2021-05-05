import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:lurkr/data/models/exceptions.dart';
import 'api_utils.dart';

class AccountApi {
  Future<String> getAccount({required String accountName}) async {
    try {
      final Uri accountUri = ApiAddress.getReal(accountName);
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

  Future<String> getGraphQlUser({required String accountName}) async {
    try {
      final Uri accountUri = ApiAddress.getGraphQlUserUrl(accountName);
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

  Future<String> getGraphQlMedia({required String mediaRawUrl}) async {
    try {
      final Uri mediaUri = ApiAddress.getGraphQlMediaUrl(mediaRawUrl);
      final http.Response mediaGraphQlResponse = await http.get(mediaUri).timeout(Duration(seconds: 20));
      if (mediaGraphQlResponse.statusCode == 200) {
        return mediaGraphQlResponse.body;
      } else {
        throw ConnectionException('status code: ${mediaGraphQlResponse.statusCode}');
      }
    } on TimeoutException {
      throw ConnectionTimeoutException();
    } catch (e) {
      throw ConnectionException('error: $e');
    }
  }

  Future<void> downloadMediaApi(Uri mediaUri, String filepath) async {
    try {
      final http.Response mediaResponse = await http.get(mediaUri).timeout(Duration(seconds: 30));
      if (mediaResponse.statusCode == 200) {
        Uint8List bytes = mediaResponse.bodyBytes;
        File file = new File(filepath);
        await file.writeAsBytes(bytes);
      } else {
        throw ConnectionException('status code: ${mediaResponse.statusCode}');
      }
    } on TimeoutException {
      throw ConnectionTimeoutException();
    } catch (e) {
      throw ConnectionException('error: $e');
    }
  }
}

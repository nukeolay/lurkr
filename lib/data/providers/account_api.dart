import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:Instasnitch/data/models/exceptions.dart';

class AccountApi {
  //static const authority = "instagram.com";
  //static const unencodedPath = "/web/search/topsearch";

  static const authority = "192.168.3.7:3000";
  static const unencodedPath = "/users";

  Future<String> getAccount({required String accountName}) async {
    //final Uri accountUri = Uri.https(authority, unencodedPath, {'query': '$accountName'});
    final Uri accountUri = Uri.http(authority, unencodedPath, {'query': '$accountName'});
    final http.Response searchResponse = await http.get(accountUri);
    if (searchResponse.statusCode == 200) {
      return searchResponse.body;
    } else {
      throw ConnectionException('status code: ${searchResponse.statusCode}');
    }
  }
}
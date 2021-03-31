import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instasnitch/data/api/model/api_account.dart';
import 'package:instasnitch/domain/exception/exception.dart';

class AccountService {
  static const authority = "instagram.com";
  static const unencodedPath = "/web/search/topsearch";

  Future<ApiAccount> getAccount({required String accountName}) async {
    Uri accountUri = Uri.https(authority, unencodedPath, {'query': '$accountName'});
    http.Response searchResponse = await http.get(accountUri);
    if (searchResponse.statusCode == 200) {
      return ApiAccount.fromApi(getOneOfSearchResult(searchResponse, accountName));
    } else {
      throw ConnectionException('status code: ${searchResponse.statusCode}');
    }
  }

  static Map<String, dynamic> getOneOfSearchResult(http.Response searchResponse, String accountName) {
    List tempInstagramResponse;
    try {
      tempInstagramResponse = jsonDecode(searchResponse.body)['users'] as List;
    }
    catch(e) {
      throw NoTriesLeftException();
    }
    if (tempInstagramResponse.length == 0) {
      throw NoAccountException();
    }
    for (Map<String, dynamic> item in tempInstagramResponse) {
      if (item['user']['username'] == accountName) {
        return item['user'] as Map<String, dynamic>;
      }
    }
    throw NoAccountException();
  }
}

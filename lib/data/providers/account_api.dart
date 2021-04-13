import 'package:http/http.dart' as http;
import 'package:Instasnitch/data/models/exceptions.dart';
import 'api_utils.dart';

class AccountApi {
  Future<String> getAccount({required String accountName}) async {
    try {
      final Uri accountUri = ApiAddress.getReal(accountName); //todo для fake не забыть включить mockoon
      final http.Response searchResponse = await http.get(accountUri);
      if (searchResponse.statusCode == 200) {
        return searchResponse.body;
      } else {
        throw ConnectionException('status code: ${searchResponse.statusCode}');
      }
    }
    catch (e) {
      throw ConnectionException('error: $e');
    }
  }
}

import 'package:http/http.dart' as http;

class ApiAddress {
  static Uri getReal(String username) {
    const authority = "instagram.com";
    const unencodedPath = "/web/search/topsearch";
    return Uri.https(authority, unencodedPath, {'query': '$username'});
  }
  static Uri getFake(String username) {
    const authority = "192.168.3.7:3000";
    const unencodedPath = "/users";
    return Uri.http(authority, unencodedPath, {'query': '$username'});
  }
}
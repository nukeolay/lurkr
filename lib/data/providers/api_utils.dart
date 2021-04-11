import 'package:flutter/services.dart';

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

class ImageConverter {
  static Future<String> convertUriImageToString(String stringUri) async {
    final Uri imageUri = Uri.parse(stringUri);
    final ByteData imageData = await NetworkAssetBundle(imageUri).load('');
    final String imageSavedAsString = String.fromCharCodes(imageData.buffer.asUint8List());
    return imageSavedAsString;
  }
}

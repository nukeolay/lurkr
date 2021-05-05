import 'dart:async';
import 'dart:typed_data';

import 'package:lurkr/data/models/exceptions.dart';
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

  static Uri getGraphQlUserUrl(String username) {
    const authority = "instagram.com";
    String unencodedPath = "/$username";
    return Uri.https(authority, unencodedPath, {'__a': '1'});
  }

  static Uri getGraphQlMediaUrl(String mediaRawUrl) {
    Uri url = Uri.parse(mediaRawUrl);
    String authority = url.host;
    String path = url.path;
    return Uri.https(authority, path, {'__a': '1'});
  }
}

class ImageConverter {
  static Future<String> convertUriImageToString(String stringUri) async {
    final Uri imageUri = Uri.parse(stringUri);
    try {
      final ByteData imageData = await NetworkAssetBundle(imageUri).load('').timeout(Duration(seconds: 20));
      final String imageSavedAsString = String.fromCharCodes(imageData.buffer.asUint8List());
      return imageSavedAsString;
    } on TimeoutException {
      throw ConnectionTimeoutException();
    } catch (e) {
      throw ConnectionException('error: $e');
    }
  }
}

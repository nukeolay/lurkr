import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

class AccountList {
  List<Account> accounts;

  AccountList({required this.accounts});

  factory AccountList.fromJson(Map<String, dynamic> json) {
    List accountJson = json['users'] as List;
    List<Account> accountList = accountJson.map((i) => Account.fromJson(i['user'])).toList();
    return AccountList(accounts: accountList);
  }
}

class Account {
  final String username;
  final Uri profilePicUrl;
  final bool isPrivate;
  final String pk;
  final String fullName;
  final bool isVerified;
  final bool hasAnonymousProfilePicture;

  Account(
      {required this.username,
      required this.profilePicUrl,
      required this.isPrivate,
      required this.pk,
      required this.fullName,
      required this.isVerified,
      required this.hasAnonymousProfilePicture});

  factory Account.fromJson(Map<String, dynamic> inputJson) {
    return Account(
        username: inputJson['username'] as String,
        profilePicUrl: inputJson['profile_pic_url'] as Uri,
        isPrivate: inputJson['is_private'] as bool,
        pk: inputJson['pk'] as String,
        fullName: inputJson['full_name'] as String,
        isVerified: inputJson['is_verified'] as bool,
        hasAnonymousProfilePicture: inputJson['has_anonymous_profile_picture'] as bool);
  }

  @override
  String toString() {
    return 'name: $username, private: $isPrivate';
  }
}

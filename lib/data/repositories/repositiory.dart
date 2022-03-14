import 'dart:async';
import 'dart:convert';

import 'package:lurkr/data/models/account.dart';
import 'package:lurkr/data/models/exceptions.dart';
import 'package:lurkr/data/models/updater.dart';
import 'package:lurkr/data/providers/account_api.dart';
import 'package:lurkr/data/providers/account_list_local.dart';
import 'package:lurkr/data/providers/api_utils.dart';
import 'package:lurkr/data/providers/updater_local.dart';

class Repository {
  List<Account> _accountList = [];
  final AccountListLocal _accountListLocal = AccountListLocal();
  final AccountApi _accountApi = AccountApi();
  final UpdaterLocal _updaterLocal = UpdaterLocal();

  Future<Account> getAccountFromInternet({required String accountName}) async {
    final String apiAccountString = await _accountApi.getAccount(accountName: accountName);
    List tempInstagramResponse;
    try {
      tempInstagramResponse = jsonDecode(apiAccountString)['users'] as List;
    } catch (e) {
      throw NoTriesLeftException();
    }
    if (tempInstagramResponse.length == 0) {
      throw NoAccountException();
    }
    for (Map<String, dynamic> element in tempInstagramResponse) {
      if (element['user']['username'] == accountName) {
        String stringImage;
        if (!(element['user']['has_anonymous_profile_picture'] as bool)) {
          // if account has avatar, then this parameter false
          // converts avatar image to string, to save it in sharedprefs
          stringImage = await ImageConverter.convertUriImageToString(element['user']['profile_pic_url']);
        } else {
          stringImage = 'error';
        }
        return Account.fromApi(element['user'], stringImage);
      }
    }
    throw NoAccountException();
  }

  Future<String> getHdPicUri({required String accountName}) async {
    final String hdPicUriString = await _accountApi.getGraphQlUser(accountName: accountName);
    try {
      return jsonDecode(hdPicUriString)['graphql']['user']['profile_pic_url_hd'] as String;
    } catch (e) {
      throw NoTriesLeftException();
    }
  }

  Future<String> getMediaUri({required String mediaRawUrl}) async {
    final String mediaUriString = await _accountApi.getGraphQlMedia(mediaRawUrl: mediaRawUrl);
    final bool isVideo;
    try {
      isVideo = jsonDecode(mediaUriString)['graphql']['shortcode_media']['is_video'];
      if (isVideo) {
        return jsonDecode(mediaUriString)['graphql']['shortcode_media']['video_url'];
      } else {
        return jsonDecode(mediaUriString)['graphql']['shortcode_media']['display_url'];
      }
    } catch (e) {
      throw NoTriesLeftException();
    }
  }

  Future<List<String>> getAllMediaUri({required String mediaRawUrl}) async {
    final String mediaUriString = await _accountApi.getGraphQlMedia(mediaRawUrl: mediaRawUrl);
    List<String> uriList = [];
    try {
      Map<String, dynamic> graphQLResponce = jsonDecode(mediaUriString)['graphql']['shortcode_media'];
      if (graphQLResponce.containsKey('edge_sidecar_to_children')) {
        // if there is more than 1 media in this post
        for (dynamic element in graphQLResponce['edge_sidecar_to_children']['edges']) {
          if ((element['node']).containsKey('video_url')) {
            uriList.add(element['node']['video_url']);
          } else {
            uriList.add(element['node']['display_url']);
          }
        }
      } else {
        // if there is 1 media in this post
        if ((jsonDecode(mediaUriString)['graphql']['shortcode_media']).containsKey('video_url')) {
          uriList.add(jsonDecode(mediaUriString)['graphql']['shortcode_media']['video_url']);
        } else {
          uriList.add(jsonDecode(mediaUriString)['graphql']['shortcode_media']['display_url']);
        }
      }
      return uriList;
    } catch (e) {
      print('=========================$e');
      throw NoTriesLeftException();
    }
  }

  Future<Updater> getUpdater() async {
    final Updater updater = await _updaterLocal.getUpdater();
    return updater;
  }

  Future<void> saveUpdater({required Updater updater}) async {
    await _updaterLocal.setUpdater(refreshPeriod: updater.refreshPeriod, isDark: updater.isDark, isFirstTime: updater.isFirstTime);
  }

  Future<List<Account>> getAccountListFromSharedprefs() async {
    final String? accountListLocalString = await _accountListLocal.getAccountListLocal();
    try {
      List<dynamic> tempList = jsonDecode(accountListLocalString!);
      _accountList = []; // clear list to avoid dublicate
      for (dynamic element in tempList) {
        _accountList.add(Account.fromSharedPrefs(element));
      }
      return _accountList;
    } catch (e) {
      return _accountList;
    }
  }

  Future<void> saveAccountListToSharedprefs({required List<Account> accountList}) async {
    await _accountListLocal.setAccountListLocal(accountList: jsonEncode(accountList));
  }

  Future<void> downloadMedia(String stringUri, String filepath) async {
    final Uri mediaUri = Uri.parse(stringUri);
    try {
      await _accountApi.downloadMediaApi(mediaUri, filepath);
    } on ConnectionException {} on TimeoutException {
      throw ConnectionTimeoutException();
    } catch (e) {
      throw ConnectionException('error: $e');
    }
  }

  static Account getDummyAccount(
      {String userName = 'dummy',
      String savedProfilePic = '',
      bool isPrivate = false,
      String pk = 'error',
      String fullName = 'error',
      bool isVerified = false,
      bool hasAnonymousProfilePicture = false,
      bool isChanged = false}) {
    Uri profilePicUrl = Uri.http('', 'error');
    int lastTimeUpdated = 0;
    return Account(
        username: userName,
        profilePicUrl: profilePicUrl,
        savedProfilePic: savedProfilePic,
        isPrivate: isPrivate,
        pk: pk,
        fullName: fullName,
        isVerified: isVerified,
        hasAnonymousProfilePicture: hasAnonymousProfilePicture,
        isChanged: isChanged,
        lastTimeUpdated: lastTimeUpdated);
  }
}

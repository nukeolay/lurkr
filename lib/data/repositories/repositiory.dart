import 'dart:convert';
import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/data/models/exceptions.dart';
import 'package:Instasnitch/data/models/updater.dart';
import 'package:Instasnitch/data/providers/account_api.dart';
import 'package:Instasnitch/data/providers/account_list_local.dart';
import 'package:Instasnitch/data/providers/api_utils.dart';
import 'package:Instasnitch/data/providers/updater_local.dart';

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
          //если у аккаунта есть аватар, тогда этот параметр false
          //преобразовываем аватарку в строку, чтобы хранить ее в sharedprefs
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
    final String apiAccountString = await _accountApi.getGraphQl(accountName: accountName);
    try {
      return jsonDecode(apiAccountString)['graphql']['user']['profile_pic_url_hd'] as String;
    } catch (e) {
      throw NoTriesLeftException();
    }
  }

  Future<Updater> getUpdater() async {
    final Updater updater = await _updaterLocal.getUpdater();
    return updater;
  }

  Future<void> saveUpdater({required Updater updater}) async {
    _updaterLocal.setUpdater(refreshPeriod: updater.refreshPeriod);
  }

  Future<List<Account>> getAccountListFromSharedprefs() async {
    final String? accountListLocalString = await _accountListLocal.getAccountListLocal();
    try {
      List<dynamic> tempList = jsonDecode(accountListLocalString!); // '!' значит пообещать, то тут не будет null
      _accountList = []; //обнуляю список, а то он начинает дублироваться
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

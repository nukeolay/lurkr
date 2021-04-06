import 'package:instasnitch/data/models/api_account.dart';
import 'file:///D:/MyApps/MyProjects/FlutterProjects/instasnitch/lib/data/models/account.dart';

class AccountMapper {
  static Account fromApi(ApiAccount apiAccount) {
    return Account(username: apiAccount.username,
        profilePicUrl: Uri.parse(apiAccount.profilePicUrl),
        isPrivate: apiAccount.isPrivate,
        pk: apiAccount.pk,
        fullName: apiAccount.fullName,
        isVerified: apiAccount.isVerified,
        hasAnonymousProfilePicture: apiAccount.hasAnonymousProfilePicture);
  }
}
import 'package:instasnitch/data/api/model/api_account.dart';
import 'package:instasnitch/domain/model/account.dart';

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
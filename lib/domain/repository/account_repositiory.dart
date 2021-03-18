import 'package:instasnitch/domain/model/account.dart';

abstract class AccountRepository {
  Future<Account> getAccount({required String accountName});
}
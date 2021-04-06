import 'file:///D:/MyApps/MyProjects/FlutterProjects/instasnitch/lib/data/models/account.dart';

abstract class AccountRepository {
  Future<Account> getAccount({required String accountName});
}
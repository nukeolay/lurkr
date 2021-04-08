import 'package:Instasnitch/data/repositories/account_repositiory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Instasnitch/data/models/exceptions.dart';
import 'package:Instasnitch/presentation/theme/theme.dart';

import 'data/models/account.dart';
import 'data/providers/account_api.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.grey[900],
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) // всегда портретная ориентация экрана
      .then((_) {
    runApp(InstasnitchApp());
  });
}

class InstasnitchApp extends StatelessWidget {
  const InstasnitchApp({Key? key}) : super(key: key);
  static List<String> accountList = ['1tv', 'nukeolay', 'kjhsdlmhxjmslkxhoi', 'to_be_ksusha'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instasnitch',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 50.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30,
                        color: Colors.white,
                        child: Image.asset('assets/top_logo.png'),
                      ),
                      Transform.rotate(
                        angle: 0.7,
                        child: Container(
                          child: GestureDetector(
                            child: Icon(
                              Icons.brightness_2_outlined,
                              size: 25,
                              color: Colors.black,
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: FutureBuilder(
                      future: getAccountList(accountList),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        else {
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            itemCount: accountList.length,
                            itemExtent: 90,
                            addAutomaticKeepAlives: true,
                            itemBuilder: (context, index) {
                              Account tempLoadedAccount;
                              tempLoadedAccount = snapshot.data[index];
                              return ListTile(
                                  leading: Container(
                                    height: 55.0,
                                    width: 55.0,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(const Radius.circular(50.0)),
                                      border: tempLoadedAccount.isPrivate == true
                                          ? Border.all(color: Colors.red, width: 3.0)
                                          : Border.all(color: Colors.green, width: 3.0),
                                    ),
                                    child: tempLoadedAccount.profilePicUrl.toString() == 'error'
                                        ? Icon(Icons.image_not_supported_outlined)
                                        : tempLoadedAccount.isPrivate
                                            ? Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(300.0),
                                                    child: ColorFiltered(
                                                      colorFilter: ColorFilter.mode(Colors.blueGrey, BlendMode.lighten),
                                                      child: Image.network(tempLoadedAccount.profilePicUrl.toString()),
                                                    ),
                                                  ),
                                                  Center(
                                                      child: Icon(
                                                    Icons.lock_outline_rounded,
                                                    color: Colors.red,
                                                  ))
                                                ],
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(300.0),
                                                child: Image.network(tempLoadedAccount.profilePicUrl.toString()),
                                              ),
                                  ),
                                  title: Text(accountList[index]),
                                  subtitle: tempLoadedAccount.fullName == 'error'
                                      ? Text('error getting info', style: TextStyle(color: Colors.red))
                                      : Text(tempLoadedAccount.fullName)
                                  // trailing: Icon(
                                  //   Icons.lock_outline_rounded,
                                  //   size: 30,
                                  // ),
                                  );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                tooltip: 'Set refresh period',
                icon: const Icon(Icons.hourglass_bottom_outlined, size: 25),
                onPressed: () {},
              ),
              IconButton(
                tooltip: 'Add account',
                icon: const Icon(Icons.add_box_rounded, size: 30),
                onPressed: () {},
              ),
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh_rounded, size: 25),
                onPressed: () {},
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add_circle),
        //   onPressed: () {},
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

Future<List<Account>> getAccountList(List<String> accountList) async {
  AccountRepository accountRepository = AccountRepository();
  List<Account> accountDataList = [];
  Map<String, dynamic> dummyAccount = {
    'username': 'user',
    'profile_pic_url': 'error',
    'is_private': true,
    'pk': 'error',
    'full_name': 'error',
    'is_verified': false,
    'has_anonymous_profile_picture': false
  };

  for (String account in accountList) {
    try {
      Account tempAccount = await accountRepository.getAccountFromInternet(accountName: account);
      accountDataList.add(tempAccount);
    } on NoTriesLeftException {
      dummyAccount['username'] = account;
      dummyAccount['full_name'] = 'try again later';
      accountDataList.add(Account.fromApi(dummyAccount));
    }
    on NoAccountException {
      dummyAccount['username'] = account;
      dummyAccount['full_name'] = 'account not found';
      accountDataList.add(Account.fromApi(dummyAccount));
    }
  }
  return accountDataList;
}

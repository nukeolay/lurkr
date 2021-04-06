import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instasnitch/data/models/api_account.dart';
import 'package:instasnitch/data/models/exceptions.dart';
import 'package:instasnitch/presentation/theme/theme.dart';

import 'data/providers/account_service.dart';

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
  static List<String> accountList = ['1tv', 'nukeolay', 'kjhsdlmhxjmslkxhoi'];

  @override
  Widget build(BuildContext context) {
    AccountService accountService = AccountService();

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
                        } else {
                          print('snapshot.data: ${snapshot.data}');
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            itemCount: accountList.length,
                            itemExtent: 90,
                            addAutomaticKeepAlives: true,
                            itemBuilder: (context, index) {
                              ApiAccount tempLoadedAccount;
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
                                    child: tempLoadedAccount.profilePicUrl == 'error'
                                        ? Icon(Icons.image_not_supported_outlined)
                                        : tempLoadedAccount.isPrivate
                                            ? Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(300.0),
                                                    child: ColorFiltered(
                                                      colorFilter: ColorFilter.mode(Colors.white30, BlendMode.lighten),
                                                      child: Image.network(tempLoadedAccount.profilePicUrl),
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
                                                child: Image.network(tempLoadedAccount.profilePicUrl),
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

// main() async {
//   AccountService accountService = AccountService();
//   List<String> accountList = [
//     'nukeolay',
//     'klhnjknhkjhkhblkj',
//     'to_be_ksusha',
//     '1tv',
//   ];
//   for (String account in accountList) {
//     try {
//       ApiAccount tempAccount = await accountService.getAccount(accountName: account);
//       print('${tempAccount.username}: ${tempAccount.isPrivate ? 'private' : 'public'}');
//     } catch (e) {
//       print(e.toString());
//     }
//   }
// }

Future<List<ApiAccount>> getAccountList(List<String> accountList) async {
  AccountService accountService = AccountService();
  List<ApiAccount> accountDataList = [];

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
      ApiAccount tempAccount = await accountService.getAccount(accountName: account);
      print('${tempAccount.username}: ${tempAccount.isPrivate ? 'private' : 'public'}');
      accountDataList.add(tempAccount);
    } on NoTriesLeftException {
      dummyAccount['username'] = account;
      dummyAccount['full_name'] = 'try again later';
      accountDataList.add(ApiAccount.fromApi(dummyAccount));
    }
    on NoAccountException {
      dummyAccount['username'] = account;
      dummyAccount['full_name'] = 'account not found';
      accountDataList.add(ApiAccount.fromApi(dummyAccount));
    }
  }
  return accountDataList;
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instasnitch/data/api/model/api_account.dart';
import 'package:instasnitch/domain/exception/exception.dart';
import 'package:instasnitch/presentation/theme/theme.dart';

import 'data/api/service/account_service.dart';

main() {
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
  const InstasnitchApp({
    Key? key,
  }) : super(key: key);

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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(90)),
                          color: Colors.black,
                        ),
                        child: Icon(
                          Icons.brightness_2,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 600,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    itemCount: 20,
                    itemExtent: 90,
                    addAutomaticKeepAlives: false,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          Icons.check_circle_rounded,
                          size: 55,
                        ),
                        title: Text('account name $index'),
                        subtitle: Text('private status changed $index mins ago'),
                        trailing: Icon(
                          Icons.lock_outline_rounded,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
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

import 'file:///D:/MyApps/MyProjects/FlutterProjects/instasnitch/lib/presentation/screens/home_screen.dart';
import 'package:Instasnitch/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Instasnitch/presentation/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'domain/blocs/account_list_bloc/account_list_states.dart';
import 'domain/blocs/connection_bloc/connection_bloc.dart';

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
    return MultiBlocProvider(
        providers: [
          BlocProvider<AccountListBloc>(create: (context) => AccountListBloc()),
          BlocProvider<ConnectionBloc>(create: (context) => ConnectionBloc()),
        ],
        child: MaterialApp(
          title: 'Instasnitch',
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.lightTheme,
          themeMode: ThemeMode.light,
          home: BlocBuilder<AccountListBloc, AccountListState>(
            buildWhen: (previousState, state) {
              bool isNeedToRebuild = previousState is AccountListStateStarting;
              return isNeedToRebuild;
            },
            builder: (context, state) {
              if (state is AccountListStateStarting) {
                return SplashScreen();
              }
              return HomeScreen();
            },
          ),
        ));
  }
}

// Future<List<Account>> getAccountList(List<String> accountList) async {
//   AccountRepository accountRepository = AccountRepository();
//   List<Account> accountDataList = [];
//   Map<String, dynamic> dummyAccount = {
//     'username': 'user',
//     'profile_pic_url': 'error',
//     'is_private': true,
//     'pk': 'error',
//     'full_name': 'error',
//     'is_verified': false,
//     'has_anonymous_profile_picture': false
//   };
//
//   for (String account in accountList) {
//     try {
//       Account tempAccount = await accountRepository.getAccountFromInternet(accountName: account);
//       accountDataList.add(tempAccount);
//     } on NoTriesLeftException {
//       dummyAccount['username'] = account;
//       dummyAccount['full_name'] = 'try again later';
//       accountDataList.add(Account.fromApi(dummyAccount));
//     } on NoAccountException {
//       dummyAccount['username'] = account;
//       dummyAccount['full_name'] = 'account not found';
//       accountDataList.add(Account.fromApi(dummyAccount));
//     }
//   }
//   return accountDataList;
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:lurkr/data/repositories/repositiory.dart';
import 'package:lurkr/domain/background/bg_updater.dart';
import 'package:lurkr/presentation/screens/home_screen.dart';
import 'package:lurkr/presentation/screens/on_boarding_screen.dart';
import 'package:lurkr/presentation/screens/splash_screen.dart';
import 'package:lurkr/presentation/theme/theme.dart';
import 'package:lurkr/data/models/account.dart';
import 'package:lurkr/domain/background/notification.dart';
import 'package:lurkr/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:lurkr/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:lurkr/domain/blocs/account_list_bloc/account_list_states.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    List<Account> accountList = await BgUpdater.updateAccounts(); // update privacy status in the background
    String result;
    switch (accountList.length) {
      case 0:
        break;
      default:
        {
          result = '${accountList[0].username} is ${accountList[0].isPrivate ? 'private now' : 'public now'}';
          for (int i = 1; i < accountList.length; i++) {
            result = result + ', ${accountList[i].username} is ${accountList[i].isPrivate ? 'private now' : 'public now'}';
          }
          await LocalNotification.initializer();
          await LocalNotification.showOneTimeNotification(title: 'Lurkr', text: result);
          break;
        }
    }
    return Future.value(true);
  });
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  int refreshPeriod = (await Repository().getUpdater()).refreshPeriod;
  BgUpdater bgUpdater = BgUpdater(refreshPeriod: refreshPeriod);
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await Workmanager().registerPeriodicTask('lurkr_task', 'lurkr_task',
      inputData: {}, frequency: Duration(microseconds: bgUpdater.refreshPeriod), initialDelay: Duration(microseconds: bgUpdater.refreshPeriod));
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(EasyLocalization(
      supportedLocales: [Locale('ru'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      useOnlyLangCode: true,
      child: LurkrApp(),
    ));
  });
}

class LurkrApp extends StatefulWidget {
  @override
  _LurkrAppState createState() => _LurkrAppState();
}

class _LurkrAppState extends State<LurkrApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState? _appLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    setState(() {
      _appLifecycleState = appLifecycleState;
      print(_appLifecycleState);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOnBoardingLoaded = false; // to rebuild screen after OnBoardingScreen
    return MultiBlocProvider(
        providers: [
          BlocProvider<AccountListBloc>(create: (context) => AccountListBloc()),
        ],
        child: MaterialApp(
          title: 'Lurkr',
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.lightTheme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: BlocBuilder<AccountListBloc, AccountListState>(
            buildWhen: (previousState, state) {
              bool isNeedToRebuild = previousState is AccountListStateStarting || _appLifecycleState == AppLifecycleState.resumed || isOnBoardingLoaded;
              isOnBoardingLoaded = false;
              return isNeedToRebuild;
            },
            builder: (context, state) {
              print('state: $state');
              if (_appLifecycleState == AppLifecycleState.resumed) {
                _appLifecycleState = null;
                BlocProvider.of<AccountListBloc>(context).add(AccountListEventStart());
              }
              if (state is AccountListStateStarting) {
                return SplashScreen();
              }
              if (state.updater.isFirstTime) {
                isOnBoardingLoaded = true;
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: OnBoardingScreen(),
                );
              }
              return HomeScreen();
            },
          ),
        ));
  }
}

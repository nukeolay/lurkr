import 'package:Instasnitch/data/repositories/repositiory.dart';
import 'package:Instasnitch/domain/background/bg_updater.dart';
import 'package:Instasnitch/presentation/screens/home_screen.dart';
import 'package:Instasnitch/presentation/screens/on_boarding_screen.dart';
import 'package:Instasnitch/presentation/screens/splash_screen.dart';
import 'package:Instasnitch/presentation/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'data/models/account.dart';
import 'domain/background/notification.dart';
import 'domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'domain/blocs/account_list_bloc/account_list_events.dart';
import 'domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';

//TODO для ios нужно настроить podfile, но он появится только на Маке, инструкция по настройке тут https://github.com/fluttercommunity/flutter_workmanager/blob/master/IOS_SETUP.md
//TODO для ios нужно настроить AppDelegate.swift, инструкция по настройке тут https://pub.dev/packages/flutter_local_notifications#custom-notification-icons-and-sounds

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    List<Account> accountList =
        await BgUpdater.updateAccounts(); //обновляем в фоне данные аккаунтов
    String result;
    switch (accountList.length) {
      case 0:
        break;
      default:
        {
          result =
              '${accountList[0].username} is ${accountList[0].isPrivate ? 'private now' : 'public now'}';
          for (int i = 1; i < accountList.length; i++) {
            result = result +
                ', ${accountList[i].username} is ${accountList[i].isPrivate ? 'private now' : 'public now'}';
          }
          await LocalNotification.initializer();
          await LocalNotification.showOneTimeNotification(
              title: 'Instasnitch', text: result);
          break;
        }
    }
    return Future.value(
        true); //TODO проверить, когда все булет работать без future
  });
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  int refreshPeriod = (await Repository().getUpdater()).refreshPeriod;
  BgUpdater bgUpdater = BgUpdater(
      refreshPeriod:
          refreshPeriod); //TODO разобраться зачем это делать, если можно сразу передавать дальше refreshPeriod без bgUpdater
  //print('refreshPeriod in main: ${bgUpdater.refreshPeriod / 60000000}');
  await Workmanager().initialize(callbackDispatcher,
      isInDebugMode: false); //TODO сделать false
  await Workmanager().registerPeriodicTask(
      'instasnitch_task', 'instasnitch_task',
      inputData: {},
      frequency: Duration(microseconds: bgUpdater.refreshPeriod),
      initialDelay: Duration(microseconds: bgUpdater.refreshPeriod));
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]) // всегда портретная ориентация экрана
      .then((_) {
    runApp(EasyLocalization(
      supportedLocales: [Locale('ru'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      useOnlyLangCode: true,
      child: InstasnitchApp(),
    ));
  });
}

class InstasnitchApp extends StatefulWidget {
  @override
  _InstasnitchAppState createState() => _InstasnitchAppState();
}

class _InstasnitchAppState extends State<InstasnitchApp>
    with WidgetsBindingObserver {
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
    bool isOnBoardingLoaded =
        false; //костыль чтобы перестроить экран, после просмотра OnBoardingScreen
    return MultiBlocProvider(
        providers: [
          BlocProvider<AccountListBloc>(create: (context) => AccountListBloc()),
        ],
        child: MaterialApp(
          title: 'Instasnitch',
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.lightTheme,
          //darkTheme: CustomTheme.darkTheme,
          //themeMode: ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: BlocBuilder<AccountListBloc, AccountListState>(
            buildWhen: (previousState, state) {
              // а то при каждом стейте будем перестраивать весь HomePage, а надо только те куски, которые я внутри определил
              bool isNeedToRebuild =
                  previousState is AccountListStateStarting ||
                      _appLifecycleState == AppLifecycleState.resumed ||
                      isOnBoardingLoaded;
              isOnBoardingLoaded = false;
              return isNeedToRebuild;
            },
            builder: (context, state) {
              print('state: $state');
              if (_appLifecycleState == AppLifecycleState.resumed) {
                //если приложение было свернуто, а теперь открыто, то для обвления списка (если в фоне было обновление), нужно как бы заново запустить приложение,
                _appLifecycleState = null;
                BlocProvider.of<AccountListBloc>(context)
                    .add(AccountListEventStart());
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

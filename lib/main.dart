import 'package:Instasnitch/domain/background/bg_updater.dart';
import 'package:Instasnitch/presentation/screens/home_screen.dart';
import 'package:Instasnitch/presentation/screens/splash_screen.dart';
import 'package:Instasnitch/presentation/theme/theme.dart';
import 'data/models/account.dart';
import 'domain/background/notification.dart';
import 'domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'domain/blocs/account_list_bloc/account_list_states.dart';
import 'domain/blocs/connection_bloc/connection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//todo в pubspec.yaml испольозовал форк workmanager, потому что основной не имеет поддержки null safety, нужно отследить, когда появится поддержка и убрать ссылку на этот форк а строке dependency_overrides
//todo для ios нужно настоить podfile, но он появится только на Маке, инструкция по настройке тут https://github.com/fluttercommunity/flutter_workmanager/blob/master/IOS_SETUP.md
//todo для ios нужно настроить AppDelegate.swift, инструкция по настройке тут https://pub.dev/packages/flutter_local_notifications#custom-notification-icons-and-sounds

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    List<Account> accountList = await BgUpdater.updateAccounts();
    //todo написать чтобы список в приложении обновлялся из sharedprefs

    if (accountList.length > 0) {
      await LocalNotification.initializer();
      LocalNotification.showOneTimeNotification(title: 'Instasnitch', text: '${accountList[0].username}');
    }
    return Future.value(true);
  });
}

main() async {
  //todo узнать для чего async
  WidgetsFlutterBinding.ensureInitialized();
  BgUpdater bgUpdater = BgUpdater();
  await Workmanager.initialize(callbackDispatcher, isInDebugMode: true); //todo сделать false
  await Workmanager.registerPeriodicTask('instasnitch_task', 'instasnitch_task',
      inputData: {}, frequency: Duration(minutes: 15), initialDelay: Duration(minutes: 15));
//todo!!!!!!!!!!!!frequency: Duration(microseconds: bgUpdater.refreshPeriod), initialDelay: Duration(microseconds: bgUpdater.refreshPeriod)
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
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
              // а то при каждом стейте будем перестраивать весь HomePage, а надо только те куски, которые я внутри определил
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

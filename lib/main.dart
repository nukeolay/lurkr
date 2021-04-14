import 'package:Instasnitch/presentation/screens/home_screen.dart';
import 'package:Instasnitch/presentation/screens/splash_screen.dart';
import 'package:Instasnitch/presentation/theme/theme.dart';
import 'domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'domain/blocs/account_list_bloc/account_list_states.dart';
import 'domain/blocs/connection_bloc/connection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

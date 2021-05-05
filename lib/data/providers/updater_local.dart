import 'package:lurkr/data/models/updater.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdaterLocal {
  Future<Updater> getUpdater() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload(); //добавил, чтобы получить актульные записи после обновления в фоне
    int? refreshPeriod;
    bool isDark;
    bool isFirstTime;
    try {
      refreshPeriod = prefs.getInt('refreshPeriod')!;
    } catch (e) {
      refreshPeriod = 3600000000; //по-умолчанию стоит 1 час
    }
    try {
      isDark = prefs.getBool('isDark')!;
    } catch (e) {
      isDark = false;
    }
    try {
      isFirstTime = prefs.getBool('isFirstTime')!;
    } catch (e) {
      isFirstTime = true;
    }
    return Updater(refreshPeriod: refreshPeriod, isDark: isDark, isFirstTime: isFirstTime); //todo когда получаю результат проверять на null
  }

  Future<void> setUpdater({required int refreshPeriod, required isDark, required isFirstTime}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('refreshPeriod', refreshPeriod);
    await prefs.setBool('isDark', isDark);
    await prefs.setBool('isFirstTime', isFirstTime);
  }
}

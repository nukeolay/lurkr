import 'package:Instasnitch/data/models/updater.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdaterLocal {
  Future<Updater> getUpdater() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastTimeUpdated;
    int? refreshPeriod;
    bool isDark;
    try {
      lastTimeUpdated = prefs.getInt('lastTimeUpdated')!;
    } catch (e) {
      lastTimeUpdated = 0;
    }
    try {
      refreshPeriod = prefs.getInt('refreshPeriod')!;
    } catch (e) {
      refreshPeriod = 3600000000;
    }
    try {
      isDark = prefs.getBool('isDark')!;
    } catch (e) {
      isDark = false;
    }
    return Updater(lastTimeUpdated: lastTimeUpdated, refreshPeriod: refreshPeriod, isDark: isDark); //todo когда получаю результат проверять на null
  }

  Future<void> setUpdater({required int lastTimeUpdated, required int refreshPeriod}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastTimeUpdated', lastTimeUpdated);
    await prefs.setInt('refreshPeriod', refreshPeriod);
  }
}

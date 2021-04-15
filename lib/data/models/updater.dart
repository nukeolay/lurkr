class Updater {
  final int lastTimeUpdated;
  final int refreshPeriod;
  final bool isDark;

  Updater({required this.lastTimeUpdated, required this.refreshPeriod, required this.isDark});

  factory Updater.fromSharedPrefs(Map<String, dynamic> inputJson) {
    return Updater(lastTimeUpdated: inputJson['lastTimeUpdated'] as int, refreshPeriod: inputJson['refreshPeriod'] as int, isDark: inputJson['isDark'] == 'true' ? true : false);
  }
}

enum Period {
  off,
  minutes30,
  hour1,
  hour2,
  hour6,
  hour12,
  hour24,
}

int getPeriod(Period period) {
  const int hour = 3600000000;
  switch (period) {
    case Period.minutes30:
      return 1800000000;
    case Period.hour1:
      return hour;
    case Period.hour2:
      return hour * 2;
    case Period.hour6:
      return hour * 6;
    case Period.hour12:
      return hour * 12;
    case Period.hour24:
      return hour * 24;
    default:
      return 0;
  }
}

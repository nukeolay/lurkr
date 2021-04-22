class Updater {
  final int refreshPeriod;
  final bool isDark;

  Updater({required this.refreshPeriod, required this.isDark});

  factory Updater.fromSharedPrefs(Map<String, dynamic> inputJson) {
    return Updater(refreshPeriod: inputJson['refreshPeriod'] as int, isDark: inputJson['isDark'] == 'true' ? true : false);
  }
}

enum Period {
  off,
  minutes15,
  minutes20,
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
    case Period.off:
      return 0;
    case Period.minutes15:
      return 900000000;
    case Period.minutes20:
      return 1200000000;
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

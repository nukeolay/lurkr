class Updater {
  final int lastTimeUpdated;
  final int refreshPeriod;

  Updater({required this.lastTimeUpdated, required this.refreshPeriod});

  factory Updater.fromSharedPrefs(Map<String, dynamic> inputJson) {
    return Updater(lastTimeUpdated: inputJson['lastTimeUpdated'] as int, refreshPeriod: inputJson['refreshPeriod'] as int);
  }
}

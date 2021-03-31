class NoAccountException implements Exception {
  String getErrorMessage() {
    return "No such account";
  }
}

class NoTriesLeftException implements Exception {
  String getErrorMessage() {
    return "No tries Left";
  }
}

class ConnectionException implements Exception {
  String errorText;
  ConnectionException(this.errorText);
  String getErrorMessage() {
    return "Connection error: $errorText";
  }
}
class NoAccountException implements Exception {
  String message = "No such account";

  @override
  String toString() {
    return message;
  }
}

class NoTriesLeftException implements Exception {
  String message = "No tries Left";

  @override
  String toString() {
    return message;
  }
}

class ConnectionException implements Exception {
  String errorText;

  ConnectionException(this.errorText);

  @override
  String toString() {
    return "Connection error: $errorText";
  }
}

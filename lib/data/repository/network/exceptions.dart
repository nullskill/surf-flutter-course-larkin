class ApiException implements Exception {
  ApiException([this._message, this._prefix]);

  final String _prefix;
  final String _message;

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String message])
      : super(message, 'Error During Communication: ');
}

class BadRequestException extends ApiException {
  BadRequestException([String message]) : super(message, 'Invalid Request: ');
}

class InvalidInputException extends ApiException {
  InvalidInputException([String message]) : super(message, 'Invalid Input: ');
}

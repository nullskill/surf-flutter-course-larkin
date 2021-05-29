class LocationException implements Exception {
  LocationException([this._message]);

  final String _message;

  @override
  String toString() {
    return _message;
  }
}

class ServiceException extends LocationException {
  ServiceException() : super('Location service is disabled');
}

class NoPermissionException extends LocationException {
  NoPermissionException() : super('Location permission is not granted');
}

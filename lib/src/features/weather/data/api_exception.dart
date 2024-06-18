sealed class APIException implements Exception {
  APIException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}

class InvalidApiKeyException extends APIException {
  InvalidApiKeyException() : super('Invalid API key');
}

class NoInternetConnectionException extends APIException {
  NoInternetConnectionException() : super('No Internet connection');
}

class CityNotFoundException extends APIException {
  CityNotFoundException() : super('City not found');
}

class UnknownException implements Exception {
  UnknownException();

  @override
  String toString() {
    return "unknown error occurred'";
  }
}

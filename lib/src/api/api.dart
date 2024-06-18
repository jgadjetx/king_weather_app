class OpenWeatherMapAPI {

  OpenWeatherMapAPI(this.apiKey);

  final String apiKey;
  static const String _apiBaseUrl = "api.openweathermap.org";
  static const String _apiPath = "/data/2.5/";  

  Uri weather(String city, bool isInCelsius) => _buildUri(
    endpoint: "weather",
    parametersBuilder: () => cityQueryParameters(city, isInCelsius),
  );

  Uri forecast(String city, bool isInCelsius) => _buildUri(
    endpoint: "forecast",
    parametersBuilder: () => cityQueryParameters(city, isInCelsius),
  );

  Uri _buildUri({required String endpoint,required Map<String, dynamic> Function() parametersBuilder}) {
    return Uri(
      scheme: "https",
      host: _apiBaseUrl,
      path: "$_apiPath$endpoint",
      queryParameters: parametersBuilder(),
    );
  }

  Map<String, dynamic> cityQueryParameters(String city, bool isInCelsius) => {
    "q": city,
    "appid": apiKey,
    "units": isInCelsius ? "metric" : "imperial",
    "type": "like",
    "cnt": "30",
  };

}

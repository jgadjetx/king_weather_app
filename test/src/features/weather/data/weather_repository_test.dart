import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_helper.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/Models/CurrentWeatherData.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/Models/ForecastWeatherData.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'dart:convert' as convert;

class MockHttpClient extends Mock implements ApiHelper {}
class MockHttpWeatherRepository extends Mock implements HttpWeatherRepository {}

const encodedWeatherJsonResponse = """
{
    "coord": {
        "lon": 28.1878,
        "lat": -25.7449
    },
    "weather": [
        {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
        }
    ],
    "base": "stations",
    "main": {
        "temp": 9.1,
        "feels_like": 8.58,
        "temp_min": 7.4,
        "temp_max": 12.65,
        "pressure": 1025,
        "humidity": 66
    },
    "visibility": 10000,
    "wind": {
        "speed": 1.54,
        "deg": 190
    },
    "clouds": {
        "all": 0
    },
    "dt": 1718654385,
    "sys": {
        "type": 1,
        "id": 2001,
        "country": "ZA",
        "sunrise": 1718599938,
        "sunset": 1718637851
    },
    "timezone": 7200,
    "id": 964137,
    "name": "Pretoria",
    "cod": 200
}
""";


void main() async {

  await dotenv.load(fileName: ".env");
  setupInjection();

  test('repository with mocked http client, success', () async {

    final mockHttpClient = MockHttpClient();
    final api = OpenWeatherMapAPI(sl<String>(instanceName: 'api_key'));
    final weatherRepository = HttpWeatherRepository(api: api, client: mockHttpClient);

    when(() => mockHttpClient.getData(api.weather("Pretoria",true))).thenAnswer((_) => Future.value(decodeWeatherJson(encodedWeatherJsonResponse)));

    final data = await weatherRepository.getWeather(isInCelsius: true, city: "Pretoria");

    expect(data, isNotNull);

    verify(() => weatherRepository.getWeather(isInCelsius: true, city: "Pretoria")).called(1);
  });

  test('repository with mocked http client, failure', () async {
    final mockHttpClient = MockHttpClient();
    final api = OpenWeatherMapAPI(sl<String>(instanceName: 'api_key'));
    final weatherRepository = HttpWeatherRepository(api: api, client: mockHttpClient);

    when(() => mockHttpClient.getData(api.weather("ErrorCity", true))).thenThrow("City not found");

    final data = await weatherRepository.getWeather(isInCelsius: true, city: "ErrorCity");

    expect(data,"City not found");

  });
  
  group('WeatherProvider Tests', () {

    late WeatherProvider provider;
    late MockHttpWeatherRepository mockRepository;

    final mockCurrentWeatherData = CurrentWeatherData();
    final mockForecastWeatherData = List<ForecastWeatherData>.from([]);

    setUp(() {
      mockRepository = MockHttpWeatherRepository();
      provider = WeatherProvider();
    });

    test('getWeatherData fetches data and updates currentWeather, success', () async {
      when(() => mockRepository.getWeather(isInCelsius: true, city: 'Pretoria')).thenAnswer((_) => Future.value(mockCurrentWeatherData));

      await provider.getWeatherData();

      expect(provider.currentWeather, isNotNull);
      expect(provider.hasError, false);
      expect(provider.errorMessage, null);
    });

    test('getForecastData fetches data and updates forecastWeather, success', () async {
  
      when(() => mockRepository.getForecast(isInCelsius: true, city: 'Pretoria')).thenAnswer((_) => Future.value(mockForecastWeatherData));

      await provider.getForecastData();
      
      expect(provider.forecastWeather, isNotNull);
      expect(provider.hasError, false);
      expect(provider.errorMessage, null);
    });

  });

}

Map<String, dynamic> decodeWeatherJson(String encodedJson) {
  final jsonData = convert.jsonDecode(encodedJson);
  if (jsonData is Map<String, dynamic>) {
    return jsonData;
  } else {
    throw const FormatException("Invalid json");
  }
}


import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_helper.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/Models/CurrentWeatherData.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/Models/ForecastWeatherData.dart';

class HttpWeatherRepository{

  const HttpWeatherRepository({required this.api, required this.client});
  final OpenWeatherMapAPI api;
  final ApiHelper client;

  Future<dynamic> getWeather({required String city, required bool isInCelsius}) async{

    try {
      final data = await client.getData(api.weather(city,isInCelsius));
      final currentWeatherData = CurrentWeatherData.fromJson(data);
      return currentWeatherData;
    } 
    catch (e) {
      return e;
    }

  }

  Future<dynamic> getForecast({required String city, required isInCelsius}) async{

    try {
      final data =  await client.getData(api.forecast(city,isInCelsius));

      //displaying weather at around 12pm

      final List<dynamic> allForecasts = data['list'];
      final List<ForecastWeatherData> dailyForecasts = [];

      String currentDate = '';
  
      for (final forecast in allForecasts) {
        final dateTime = DateTime.parse(forecast['dt_txt']);
        final date = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

        if (date != currentDate && dateTime.hour >= 12 && dateTime.hour < 18) {
          currentDate = date;
          dailyForecasts.add(ForecastWeatherData.fromJson(forecast));
        }
      }

      return dailyForecasts;

    } 
    catch (e) {
      return e;
    }

  }

}
import 'package:flutter/cupertino.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_helper.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/Models/CurrentWeatherData.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/Models/ForecastWeatherData.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
class WeatherProvider extends ChangeNotifier {
  
  HttpWeatherRepository repository = HttpWeatherRepository(
    api: OpenWeatherMapAPI(sl<String>(instanceName: 'api_key')),
    client: ApiHelper(),
  );

  String city = 'Pretoria';

  CurrentWeatherData? currentWeather;
  List<ForecastWeatherData>? forecastWeather;

  bool showResultsView = false;
  bool isFetchingData = false;
  bool isInCelsius = true;
  String? errorMessage;
  bool hasError = false;

  Future<void> getWeatherData() async {

    currentWeather = null;
    final data = await repository.getWeather(isInCelsius: isInCelsius, city: city);

    if(data is CurrentWeatherData){
      currentWeather = data;
      hasError = false;
    }
    else{
      hasError = true;
      errorMessage = data.toString();
    }
    
  }

  Future<void> getForecastData() async {

    forecastWeather = null;
    final data = await repository.getForecast(isInCelsius: isInCelsius,city: city);

    if(data is List<ForecastWeatherData>){
      forecastWeather = data;
      hasError = false;
    }
    else{
      hasError = true;
      errorMessage = data.toString();
    } 

  }

  Future<void> getAllWeatherData() async{

    isFetchingData = true;
    notifyListeners();

    await getWeatherData();

    if(currentWeather != null){
      await getForecastData();
    }

    if(currentWeather == null || forecastWeather == null){
      showResultsView = false;
    }

    isFetchingData = false;
    notifyListeners();

  }

  void setTempConversion(bool inCelsius){
    isInCelsius = inCelsius;
    getAllWeatherData();
  }

}

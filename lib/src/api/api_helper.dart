import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';

class ApiHelper{

  void printHi(){
    
  }

  Future<Map<String, dynamic>> getData(Uri uri) async {

    try {

      final response = await http.get(uri);

      switch (response.statusCode) {
        case 200:
          return json.decode(response.body);
        case 401:
          throw InvalidApiKeyException();
        case 404:
          throw CityNotFoundException();
        default:
          throw UnknownException();
      }
    } 
    on http.ClientException {
      throw NoInternetConnectionException();
    } 
    on CityNotFoundException {
      rethrow;
    } 
    catch (e) {
      if (e is InvalidApiKeyException) {
        rethrow;
      } else if (e is CityNotFoundException) {
        rethrow;
      } else {
        throw UnknownException();
      }
    }
    
  }

}
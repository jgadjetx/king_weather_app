import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/Models/CurrentWeatherData.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/widgets/weather_icon_image.dart';
import 'package:provider/provider.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key});

  @override
  Widget build(BuildContext context) {

    return Selector<WeatherProvider, (String city, CurrentWeatherData weatherData)>(
      selector: (context, provider) => (provider.city, provider.currentWeather!),
      builder: (context, data, _) {
        return CurrentWeatherContents(data: data.$2);
      }
    );
  }

}

class CurrentWeatherContents extends StatelessWidget {
  const CurrentWeatherContents({super.key, required this.data});

  final CurrentWeatherData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.main!.temp!.toInt().toString();
    final minTemp = data.main!.tempMin!.toInt().toString();
    final maxTemp = data.main!.tempMax!.toInt().toString();
    
    final highAndLow = 'H:$maxTemp° L:$minTemp°';
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeatherIconImage(iconUrl: data.weather![0].icon!, size: 120),
        Text("$temp°", style: textTheme.displayMedium),
        Text(highAndLow, style: textTheme.bodyMedium),
      ],
    );
  }
}

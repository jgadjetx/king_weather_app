import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/Models/ForecastWeatherData.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/widgets/weather_icon_image.dart';
import 'package:provider/provider.dart';

class ForecastWeather extends StatelessWidget {
  const ForecastWeather({super.key});

  @override
  Widget build(BuildContext context) {

    return Selector<WeatherProvider, (String city, List<ForecastWeatherData> weatherData)>(
      selector: (context, provider) => (provider.city, provider.forecastWeather!),
      builder: (context, data, _) {

        return ForecastWeatherContents(data: data.$2);
      }

    );
  }

}

class ForecastWeatherContents extends StatelessWidget {
  const ForecastWeatherContents({super.key, required this.data});

  final List<ForecastWeatherData> data;

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Container(
      alignment: Alignment.topCenter,
      height: 300,
      margin: const EdgeInsets.only(top: 30),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {

          final temp = "${data[index].main!.temp!.ceilToDouble().toStringAsFixed(0)}°";
          final icon = data[index].weather![0].icon;
          final day = Jiffy.parse(data[index].dtTxt.toString()).format(pattern: "EE");
          
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(day, style: textTheme.bodyMedium),
              WeatherIconImage(iconUrl: icon!, size: 120),             
              Text(temp.toString(), style: textTheme.bodyMedium),
            ],
          );

        },
      ),
    );

  }

}

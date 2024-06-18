import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/widgets/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/widgets/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/widgets/forecast_weather.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
class WeatherPage extends StatefulWidget {
  
  const WeatherPage({super.key, required this.city});
  final String city;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  late WeatherProvider weatherProvider;
  int toggleTab = 0;

  @override
  void initState() {
    super.initState();
    weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.rainGradient,
          ),
        ),
        child: SafeArea(
          child: AnimatedSizeAndFade(
            child: weatherProvider.showResultsView ?  resultsView() : searchView()
          )
        ),
      ),
    );
    
  }

  Widget searchView(){

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: CitySearchBox() 
        ),
        AnimatedSizeAndFade(
          child: weatherProvider.hasError ? Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              weatherProvider.errorMessage!,
              style: const TextStyle(
                color: AppColors.accentColor
              ),
            ),
          ) : Container()
        )
      ],
    );

  }

  Widget resultsView(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CitySearchBox(),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: ToggleSwitch(
            cornerRadius: 30,
            activeBgColors: const [[AppColors.accentColor],[AppColors.accentColor]],
            animate: true,
            minWidth: double.infinity,
            initialLabelIndex: toggleTab,
            totalSwitches: 2,
            labels: const ['Current', 'Forecast'],
            onToggle: (index) {
              setState(() {
                toggleTab = index!;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Fahrenheit"),
              Switch(
                value: weatherProvider.isInCelsius,
                onChanged: (value) {
                  weatherProvider.setTempConversion(value);
                },
                activeTrackColor: AppColors.accentColor,
                activeColor: AppColors.accentColor,
              ),
              const Text("Celcius")
            ],
          ),
        ),  
        Flexible(
          child:  
          AnimatedSizeAndFade(
            child: weatherProvider.isFetchingData ? 
            const Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 5,
                )
              ),
            ) : 
            AnimatedSizeAndFade(
              child: toggleTab == 0 ? const CurrentWeather() : const ForecastWeather()
            )
          )
        )
      ],
    );

  }

}

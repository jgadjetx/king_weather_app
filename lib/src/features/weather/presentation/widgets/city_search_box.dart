import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:provider/provider.dart';

class CitySearchBox extends StatefulWidget {
  const CitySearchBox({super.key});

  @override
  State<CitySearchBox> createState() => _CitySearchRowState();
}

class _CitySearchRowState extends State<CitySearchBox> {

  static const _radius = 30.0;
  late final _searchController = TextEditingController();
  late WeatherProvider weatherProvider;

  @override
  void initState() {
    super.initState();
    weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    _searchController.text = weatherProvider.city;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: _radius * 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(                            
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(   
                    borderSide: BorderSide.none, 
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(_radius), bottomLeft: Radius.circular(_radius)),
                  ),
                ),
                controller: _searchController,
              ),
            ),
            InkWell(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(_radius),
                    bottomRight: Radius.circular(_radius),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text('search', style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
              onTap: () async {
                FocusScope.of(context).unfocus();
                weatherProvider.showResultsView = true;
                weatherProvider.city = _searchController.text;
                await weatherProvider.getAllWeatherData();

              },
            )
          ],
        ),
      ),
    );
  }

}

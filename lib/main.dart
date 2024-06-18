import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';
import 'package:provider/provider.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  setupInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final textStyleWithShadow = TextStyle(
      color: Colors.white, 
      shadows: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.25),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 0.5),
        )
      ]
    );

    return MaterialApp(
      title: 'Flutter Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        textTheme: TextTheme(
          displayLarge: textStyleWithShadow,
          displayMedium: textStyleWithShadow,
          displaySmall: textStyleWithShadow,
          headlineMedium: textStyleWithShadow,
          headlineSmall: textStyleWithShadow,
          titleMedium: const TextStyle(color: Colors.black),
          bodyMedium: const TextStyle(color: Colors.white),
          bodyLarge: const TextStyle(color: Colors.white),
          bodySmall: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<WeatherProvider>(create: (_) => WeatherProvider(), lazy: false),
        ],
        builder: (context, _) {
          final city = Provider.of<WeatherProvider>(context).city;
          return WeatherPage(city: city);
        }
      ),
    );

  }

}

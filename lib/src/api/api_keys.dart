import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupInjection() {
  sl.registerSingleton<String>(dotenv.env['openWeatherAPIKey']!, instanceName: 'api_key');
}

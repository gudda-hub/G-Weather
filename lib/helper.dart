import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> loadEnv() async {
  await dotenv.load(fileName: '.env');
  Urls.apiUrl = dotenv.env['API_URL'] ?? "";
  Urls.appId = dotenv.env['APP_ID'] ?? "";
}

class Urls {
  static String apiUrl = '';
  static String appId = '';
}

extension CapitalizeString on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

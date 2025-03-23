import 'dart:developer';
import '../export.dart';
import 'package:get/get.dart' as gets;

final getWeatherDataProvider =
    FutureProvider.family.autoDispose<WeatherModel?, String>((ref, city) async {
  String url = "${Urls.apiUrl}$city&appid=${Urls.appId}";

  try {
    Dio dio = Dio();
    Response respond = await dio.get(url);
    log("data : ${respond.data}");
    if (respond.statusCode == 200) {
      WeatherModel weatherModel = WeatherModel.fromJson(respond.data);
      return weatherModel;
    } else {
      log("Else Log : ${respond.data}");
      gets.Get.snackbar("Error", respond.data['message'].toString());
    }
  } catch (e) {
    log("  catch Log : ${e.toString()}");
    gets.Get.snackbar("Error", "city not found");
  }
  return null;
});

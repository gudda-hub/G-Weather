class WeatherModel {
  final String city;
  final double temperature;
  final String condition;
  final String conditionDescription;
  final double windSpeed;
  final int humidity;
  final int clouds;

  WeatherModel({
    required this.conditionDescription,
    required this.city,
    required this.temperature,
    required this.condition,
    required this.windSpeed,
    required this.humidity,
    required this.clouds,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        city: json['name'],
        temperature: json['main']['temp'] - 273.15, // Convert Kelvin to Celsius
        condition: json['weather'][0]['main'],
        conditionDescription: json['weather'][0]['description'],
        windSpeed: json['wind']['speed'].toDouble(),
        humidity: json['main']['humidity'],
        clouds: json['clouds']['all']);
  }
}

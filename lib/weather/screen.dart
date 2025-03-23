import 'dart:ui';

import '../export.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final cityNameProvider = StateProvider<String>((ref) {
    return "Jaipur";
  });

  @override
  Widget build(BuildContext context) {
    String cityName = ref.watch(cityNameProvider);
    final weatherAsync = ref.watch(getWeatherDataProvider(cityName));

    return Scaffold(
      body: Stack(children: [
        SizedBox.expand(
            child: Image.asset("assets/bg.jpeg",
                fit: BoxFit.cover, filterQuality: FilterQuality.high)),
        Container(color: Colors.blue.withOpacity(.5)),
        SafeArea(
          child: weatherAsync.when(
            data: (weather) => weather != null
                ? ListView(
                    padding: const EdgeInsets.all(14.0),
                    children: [
                      Text(weather.city,
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      Text(
                          DateFormat('EEEE, d MMMM')
                              .format(DateTime.now())
                              .toString(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54)),
                      SizedBox(height: 20.0),
                      TextFormField(
                          controller: _cityController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              labelText: "Enter city name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    ref.read(cityNameProvider.notifier).state =
                                        _cityController.text.trim();
                                    _cityController.clear();
                                  },
                                  icon: Icon(Icons.search)))),
                      SizedBox(height: 40.0),
                      WeatherCard(weather)
                    ],
                  )
                : ErrorSection(),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (_, __) => Text("Something went wrong"),
          ),
        )
      ]),
    );
  }

  Center ErrorSection() {
    return Center(
        child: Column(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("City not found",
            style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w800,
                fontSize: 24)),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
              controller: _cityController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  labelText: "Enter city name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  suffixIcon: IconButton(
                      onPressed: () {
                        ref.read(cityNameProvider.notifier).state =
                            _cityController.text.trim();
                      },
                      icon: Icon(Icons.search)))),
        ),
      ],
    ));
  }
}

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  const WeatherCard(this.weather, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.cloud, size: 60, color: Colors.white60),
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Text("${weather.temperature.ceil()}°C",
                              style: TextStyle(
                                  letterSpacing: 2,
                                  fontSize: 80,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white))),
                      Text(weather.conditionDescription.capitalizeFirst(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: Colors.white54)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30.0),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildWheatherDetailCard('Humidity', '${weather.humidity}%',
                      Icons.water_drop_outlined, context),
                  _buildWheatherDetailCard(
                      'Wind', '${weather.windSpeed} km/h', Icons.air, context),
                  _buildWheatherDetailCard('Clouds', '${weather.clouds}%',
                      Icons.cloud_outlined, context),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWheatherDetailCard(
      String title, value, IconData icon, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: MediaQuery.of(context).size.width * .45,
          height: 140,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white70, size: 30),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.white70)),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

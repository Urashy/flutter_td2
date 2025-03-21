import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/openweathermap_api.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  final String locationName;
  final double latitude;
  final double longitude;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    final api = context.read<OpenWeatherMapApi>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.locationName)),
      body: FutureBuilder(
        future: api.getWeather(widget.latitude, widget.longitude),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Aucune donnée météo disponible.'));
          }

          final weatherData = snapshot.data;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Température: ${weatherData.temperature}°C',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Conditions: ${weatherData.description}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

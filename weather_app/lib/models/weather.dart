import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/openweathermap_api.dart';

class Weather {
  final String condition;
  final String description;
  final String icon;
  final double temperature;

  Weather({
    required this.condition,
    required this.description,
    required this.icon,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      condition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      temperature: json['main']['temp'].toDouble(),
    );
  }
}

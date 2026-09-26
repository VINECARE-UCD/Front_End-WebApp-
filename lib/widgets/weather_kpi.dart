import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherKpi extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherKpi({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<WeatherKpi> createState() => _WeatherKpiState();
}

class _WeatherKpiState extends State<WeatherKpi> {
  late Future<WeatherData> _weatherFuture;

  @override
  void initState() {
    super.initState();

    _weatherFuture = WeatherService.getCurrentWeather(
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherData>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Loading live weather...',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Live weather unavailable',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          );
        }

        final weather = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.divider,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LIVE WEATHER',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    weather.conditionIcon,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '💧 ${weather.humidity}%',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '💨 ${weather.windSpeed.toStringAsFixed(1)} km/h',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '${weather.conditionLabel} · Rain ${weather.precipitation.toStringAsFixed(1)} mm',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

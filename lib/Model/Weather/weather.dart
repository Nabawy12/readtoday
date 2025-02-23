import 'dart:convert';
import 'package:http/http.dart' as http;

// WeatherData class (updated to reflect new structure)
class WeatherData {
  final bool status;
  final String message;
  final WeatherDetails data;

  WeatherData({required this.status, required this.message, required this.data});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      status: json['status'],
      message: json['message'],
      data: WeatherDetails.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

// WeatherDetails class (new class added to reflect the 'data' part)
class WeatherDetails {
  final String description;
  final String name;
  final int cityId;
  final String icon;
  final String slug;
  final String hourlySlug;
  final Temperature temp;
  final String humidity;
  final String windSpeed;

  WeatherDetails({
    required this.description,
    required this.name,
    required this.cityId,
    required this.icon,
    required this.slug,
    required this.hourlySlug,
    required this.temp,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherDetails.fromJson(Map<String, dynamic> json) {
    return WeatherDetails(
      description: json['description'],
      name: json['name'],
      cityId: json['cityId'],
      icon: json['icon'],
      slug: json['slug'],
      hourlySlug: json['hourlySlug'],
      temp: Temperature.fromJson(json['temp']),
      humidity: json['humidity'],
      windSpeed: json['windSpeed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'name': name,
      'cityId': cityId,
      'icon': icon,
      'slug': slug,
      'hourlySlug': hourlySlug,
      'temp': temp.toJson(),
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }
}

// Temperature class (new class to reflect temperature details)
class Temperature {
  final String now;
  final String min;
  final String max;
  final String feelsLike;

  Temperature({
    required this.now,
    required this.min,
    required this.max,
    required this.feelsLike,
  });

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      now: json['now'],
      min: json['min'],
      max: json['max'],
      feelsLike: json['feelsLike'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'now': now,
      'min': min,
      'max': max,
      'feelsLike': feelsLike,
    };
  }
}

// WeatherApiService class (updated to reflect new JSON structure)
class WeatherApiService {
  Future<WeatherData> fetchWeather(String location) async {
    final url = Uri.parse('https://api-business.asharqbusiness.com/api/weather/'); // Your API URL

    try {
      final response = await http.get(url); // Making a GET request

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the data
        print("Response: ${response.body}"); // Debug: print the response body
        return WeatherData.fromJson(jsonDecode(response.body)); // Parse the JSON
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e"); // Debug: print error if any
      throw Exception('Failed to load weather data: $e');
    }
  }
}
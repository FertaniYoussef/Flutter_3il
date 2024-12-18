import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String apiKey =
      'a2274596744a1d9124d369b74370fe28'; // Replace with your OpenWeatherMap API key

  // Fetch weather data using the city name
  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return the parsed JSON data
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}

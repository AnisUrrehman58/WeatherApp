import 'dart:convert';
import 'package:whether_app/View/Service/WeatherApis/constant.dart';
import 'package:http/http.dart' as http;
import 'package:whether_app/View/Service/WeatherApis/weather_model.dart';

class WeatherApis {
  final String baseUrl = 'http://api.weatherapi.com/v1/current.json';

  Future<ApiResponse> getCurrentWeather(String location) async {
    String apiUrl = '$baseUrl?key=$apiKeys&q=$location';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load Weather');
      }
    } catch (e) {
      throw Exception('Failed to load Weather: $e');
    }
  }
}

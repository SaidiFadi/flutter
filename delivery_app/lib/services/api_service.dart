/*import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:your_app/config/app_config.dart';
import 'package:your_app/models/delivery.dart';

class ApiService {
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${AppConfig.apiUrl}/login'),
      body: {'username': username, 'password': password},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['token'];
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<List<Delivery>> getDeliveries() async {
    final token = await SecureStorage.readToken();
    final response = await http.get(
      Uri.parse('${AppConfig.apiUrl}/deliveries'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> deliveriesJson = json.decode(response.body);
      return deliveriesJson.map((json) => Delivery.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load deliveries');
    }
  }
}*/
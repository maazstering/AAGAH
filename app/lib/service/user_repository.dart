// lib/repositories/user_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/utils/constants.dart';

class UserRepository {
  final String baseUrl;

  UserRepository({this.baseUrl = BASE_URL});

  Future<Map<String, dynamic>> signup(String email, String password, String name, int age) async {
    final url = Uri.parse('$baseUrl/signup');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'age': age,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign up');
    }
  }
}

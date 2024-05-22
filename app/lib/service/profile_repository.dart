import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/utils/constants.dart';

class ProfileRepository {
  final String baseUrl;

  ProfileRepository({this.baseUrl = BASE_URL});

  Future<Map<String, dynamic>> getCurrentUser(String token) async {
    final url = Uri.parse('$baseUrl/currentUser');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch current user');
    }
  }

  Future<Map<String, dynamic>> getFriendInfo(String token, String friendId) async {
    final url = Uri.parse('$baseUrl/friendinfo/$friendId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch friend info');
    }
  }

  Future<Map<String, dynamic>> updateProfile(String token, String name, int age) async {
    final url = Uri.parse('$baseUrl/selfProfile');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'age': age,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<List<dynamic>> getUserPosts(String token, String userId) async {
    final url = Uri.parse('$baseUrl/$userId/posts');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user posts');
    }
  }

  Future<List<dynamic>> getCurrentUserPosts(String token) async {
    final url = Uri.parse('$baseUrl/selfProfile');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch current user posts');
    }
  }

  Future<Map<String, dynamic>> updateSelfProfile(
      String token, String name, int age, String email, String imagePath) async {
    final url = Uri.parse('$baseUrl/selfProfile');
    var request = http.MultipartRequest('PUT', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['age'] = age.toString()
      ..fields['email'] = email;

    if (imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      throw Exception('Failed to update self profile');
    }
  }

  Future<List<dynamic>> showUserPosts(String token) async {
    final url = Uri.parse('$baseUrl/showUserPosts');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user posts');
    }
  }
}

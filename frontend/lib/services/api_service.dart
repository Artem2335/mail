import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  static String? _token;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  static Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      await _saveToken(authResponse.token);
      return authResponse;
    } else {
      throw Exception('Registration failed');
    }
  }

  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      await _saveToken(authResponse.token);
      return authResponse;
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static String? getToken() => _token;

  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };
  }

  static Future<User> getProfile(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/$userId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  static Future<Message> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: _getHeaders(),
      body: jsonEncode({
        'receiver_id': receiverId,
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send message');
    }
  }

  static Future<List<Message>> getMessages(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/$userId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> messages = jsonDecode(response.body);
      return messages.map((msg) => Message.fromJson(msg)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  static Future<Message> uploadFile({
    required String receiverId,
    required String filePath,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload'),
    );

    request.headers.addAll({'Authorization': 'Bearer $_token'});
    request.fields['receiver_id'] = receiverId;
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to upload file');
    }
  }
}

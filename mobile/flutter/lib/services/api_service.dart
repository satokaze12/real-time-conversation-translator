import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api/v1';
  String? _token;

  ApiService({String? token}) : _token = token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _token = data['token'];
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _token = data['token'];
      return data;
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getConversations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(data['conversations'] ?? []);
    } else {
      throw Exception('Failed to fetch conversations: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getConversation(String conversationId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/conversations/$conversationId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch conversation: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createConversation(
    String targetUserId,
    String myLanguage,
    String theirLanguage,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/conversations'),
      headers: _getHeaders(),
      body: jsonEncode({
        'targetUserId': targetUserId,
        'myLanguage': myLanguage,
        'theirLanguage': theirLanguage,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create conversation: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> translateMessage(
    String text,
    String sourceLanguage,
    String targetLanguage,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages/translate'),
      headers: _getHeaders(),
      body: jsonEncode({
        'text': text,
        'sourceLanguage': sourceLanguage,
        'targetLanguage': targetLanguage,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to translate message: ${response.body}');
    }
  }
}

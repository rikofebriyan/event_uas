import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://103.160.63.165/api';

  // LOGIN USER
  static Future<String?> loginUser(
    String studentNumber,
    String password,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/login');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'student_number': studentNumber,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']['token'];
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  // REGISTER USER
  static Future<String?> registerUser(Map<String, dynamic> userData) async {
    try {
      final uri = Uri.parse('$baseUrl/register');
      final request = http.Request('POST', uri)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        })
        ..body = jsonEncode(userData);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return jsonDecode(response.body)['data']['token'];
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  // GET EVENTS
  static Future<List<dynamic>> getEvents(String token) async {
    final url = Uri.parse('$baseUrl/events');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📡 STATUS CODE: ${response.statusCode}');
    print('📥 RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']['events']; // 👈 ambil list dari dalam 'data'
    } else {
      throw Exception('Gagal mengambil data event');
    }
  }

  // CREATE EVENT (UPDATED ✅)
  static Future<bool> createEvent({
    required String token,
    required String title,
    required String description,
    required String startDate,
    required String endDate,
    required String time,
    required String location,
    required int maxAttendees,
    required String category,
    required int price,
  }) async {
    final url = Uri.parse('$baseUrl/events');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "title": title,
        "description": description,
        "start_date": startDate,
        "end_date": endDate,
        "time": time,
        "location": location,
        "max_attendees": maxAttendees,
        "category": category,
        "price": price,
      }),
    );

    print('📡 STATUS CODE: ${response.statusCode}');
    print('📥 RESPONSE BODY: ${response.body}');

    return response.statusCode == 201;
  }
}

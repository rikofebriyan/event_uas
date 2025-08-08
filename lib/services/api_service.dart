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
  static Future<Map<String, dynamic>> registerUser(
    Map<String, dynamic> userData,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/register');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(userData),
      );

      final decoded = jsonDecode(response.body);

      return {'status': response.statusCode, 'data': decoded};
    } catch (e) {
      return {
        'status': 500,
        'data': {'message': 'Gagal menghubungkan ke server.'},
      };
    }
  }

  // GET EVENTS DENGAN PARAM OPSIONAL
  static Future<List> getEvents(
    String token, {
    String? search,
    String? category,
    String? date,
  }) async {
    final queryParams = {
      if (search != null && search.isNotEmpty) 'search': search,
      if (category != null && category.isNotEmpty) 'category': category,
      if (date != null && date.isNotEmpty) 'date': date,
    };

    final uri = Uri.http('103.160.63.165', '/api/events', queryParams);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print("📡 GET URL: $uri");
    print("📥 STATUS: ${response.statusCode}");
    print("📥 BODY: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // Ambil dari path data.events
      if (decoded['success'] == true &&
          decoded['data'] != null &&
          decoded['data']['events'] != null) {
        return decoded['data']['events'] as List;
      }
      return [];
    } else {
      return [];
    }
  }

  // CREATE EVENT (UPDATED ✅)
  static Future<Map<String, dynamic>> createEvent({
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
        'Accept': 'application/json',
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

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'Event berhasil ditambahkan'};
    } else {
      try {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Terjadi kesalahan';
        return {'success': false, 'message': message};
      } catch (e) {
        return {
          'success': false,
          'message': 'Terjadi kesalahan tidak diketahui',
        };
      }
    }
  }
}

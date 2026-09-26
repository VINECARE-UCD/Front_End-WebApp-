import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

/// Base API service that connects to VineCare's AWS ALB backend
/// Microservices:
///   - Data Collection: /data/*  (port 8000 internally)
///   - Notifications:  /notifications/* (port 8001 internally)
///   - Phenology:      /phenology/* (port 8002 internally)
class ApiService {
  static const String _baseUrl = 'http://vine-care-frontend-alb';
  // Update above with the actual dualstack ALB DNS once confirmed, e.g.:
  // static const String _baseUrl = 'http://dualstack.vine-care-alb.eu-central-1.elb.amazonaws.com';

  static String? _token;

  static Future<String?> get token async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, String>> get _headers async {
    final t = await token;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (t != null) 'Authorization': 'Bearer $t',
    };
  }

  // ─── Auth ──────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/data/api/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode == 200 && data['token'] != null) {
      await setToken(data['token'] as String);
    }
    return data;
  }

  // ─── Data Collection (Blocks / Flights) ───────────────────────────────────

  static Future<List<dynamic>> getBlocks() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/data/api/blocks/'),
      headers: await _headers,
    );
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List<dynamic>;
    throw Exception('Failed to load blocks: ${resp.statusCode}');
  }

  static Future<Map<String, dynamic>> getBlock(String blockId) async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/data/api/blocks/$blockId/'),
      headers: await _headers,
    );
    if (resp.statusCode == 200) return jsonDecode(resp.body) as Map<String, dynamic>;
    throw Exception('Failed to load block: ${resp.statusCode}');
  }

  static Future<List<dynamic>> getFlights({String? blockId}) async {
    final uri = Uri.parse('$_baseUrl/data/api/flights/').replace(
      queryParameters: blockId != null ? {'block': blockId} : null,
    );
    final resp = await http.get(uri, headers: await _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List<dynamic>;
    throw Exception('Failed to load flights: ${resp.statusCode}');
  }

  static Future<Map<String, dynamic>> getDashboardStats() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/data/api/dashboard/'),
      headers: await _headers,
    );
    if (resp.statusCode == 200) return jsonDecode(resp.body) as Map<String, dynamic>;
    throw Exception('Failed to load dashboard: ${resp.statusCode}');
  }

  // ─── Drone Image Upload ────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> uploadFlightImages({
    required String blockId,
    required List<String> filePaths,
    required double altitude,
    required String flightDate,
    String? notes,
    void Function(int sent, int total)? onProgress,
  }) async {
    final dio = Dio();
    final t = await token;
    if (t != null) {
      dio.options.headers['Authorization'] = 'Bearer $t';
    }

    final formData = FormData();
    formData.fields
      ..add(MapEntry('block_id', blockId))
      ..add(MapEntry('altitude', altitude.toString()))
      ..add(MapEntry('flight_date', flightDate));
    if (notes != null && notes.isNotEmpty) {
      formData.fields.add(MapEntry('notes', notes));
    }
    for (final path in filePaths) {
      formData.files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(path),
      ));
    }

    final resp = await dio.post(
      '$_baseUrl/data/api/flights/upload/',
      data: formData,
      onSendProgress: onProgress,
    );
    return resp.data as Map<String, dynamic>;
  }

  // ─── Phenology ─────────────────────────────────────────────────────────────

  static Future<List<dynamic>> getPhenologyStages({String? blockId}) async {
    final uri = Uri.parse('$_baseUrl/phenology/api/stages/').replace(
      queryParameters: blockId != null ? {'block': blockId} : null,
    );
    final resp = await http.get(uri, headers: await _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List<dynamic>;
    throw Exception('Failed to load phenology: ${resp.statusCode}');
  }

  static Future<Map<String, dynamic>> getCurrentPhenology() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/phenology/api/current/'),
      headers: await _headers,
    );
    if (resp.statusCode == 200) return jsonDecode(resp.body) as Map<String, dynamic>;
    throw Exception('Failed to load current phenology: ${resp.statusCode}');
  }

  // ─── Notifications ─────────────────────────────────────────────────────────

  static Future<List<dynamic>> getNotifications({String? type}) async {
    final uri = Uri.parse('$_baseUrl/notifications/api/list/').replace(
      queryParameters: type != null && type != 'all' ? {'type': type} : null,
    );
    final resp = await http.get(uri, headers: await _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List<dynamic>;
    throw Exception('Failed to load notifications: ${resp.statusCode}');
  }

  static Future<void> markNotificationRead(String id) async {
    await http.patch(
      Uri.parse('$_baseUrl/notifications/api/list/$id/read/'),
      headers: await _headers,
    );
  }

  // ─── Health Check ──────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> healthCheck() async {
    final results = <String, dynamic>{};
    for (final entry in {
      'data_collection': '$_baseUrl/data/api/health/',
      'notifications': '$_baseUrl/notifications/api/health/',
      'phenology': '$_baseUrl/phenology/api/health/',
    }.entries) {
      try {
        final resp = await http.get(Uri.parse(entry.value)).timeout(
          const Duration(seconds: 5),
        );
        results[entry.key] = resp.statusCode == 200 ? 'ok' : 'degraded';
      } catch (_) {
        results[entry.key] = 'unreachable';
      }
    }
    return results;
  }
}

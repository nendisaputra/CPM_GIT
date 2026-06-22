import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  // 🔥 GANTI BASE_URL SESUAI ENVIRONMENT
  // Emulator Android  : http://10.0.2.2:8000/api
  // HP fisik          : http://192.168.x.x:8000/api
  // Web / Desktop     : http://127.0.0.1:8000/api
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // <-- ubah sesuai kebutuhan

  // ─── SESSION ──────────────────────────────────────────────
  static Future<void> saveUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', id);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_data');
    if (data == null) return null;
    return jsonDecode(data);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ─── AUTH ──────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server.'};
    }
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
    String plateNumber,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'plate_number': plateNumber,
        }),
      ).timeout(const Duration(seconds: 10));
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server.'};
    }
  }

  // ─── FLOOR & SLOT ──────────────────────────────────────────
  static Future<List<dynamic>> getFloors() async {
    try {
      print('📡 GET /floor');
      final response = await http.get(Uri.parse('$baseUrl/floor')).timeout(const Duration(seconds: 30));
      print('📡 Response status: ${response.statusCode}');
      final data = jsonDecode(response.body);
      return data['success'] == true ? data['floors'] : [];
    } catch (e) {
      print('❌ getFloors error: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getSlotsByFloor(int floorId) async {
    try {
      print('📡 GET /floor/$floorId');
      final response = await http.get(Uri.parse('$baseUrl/floor/$floorId')).timeout(const Duration(seconds: 30));
      print('📡 Response status: ${response.statusCode}');
      final data = jsonDecode(response.body);
      print('📡 Data slots: ${data['slots']?.length ?? 0} slot');
      return data['success'] == true ? data['slots'] : [];
    } catch (e) {
      print('❌ getSlotsByFloor error: $e');
      return [];
    }
  }

  // ─── BOOKING ───────────────────────────────────────────────
  static Future<Map<String, dynamic>> createBooking(int userId, int slotId, int totalPayment) async {
    try {
      print('📡 POST /booking');
      final response = await http.post(
        Uri.parse('$baseUrl/booking'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'slot_id': slotId,
          'total_payment': totalPayment,
        }),
      ).timeout(const Duration(seconds: 30));
      print('📡 Response status: ${response.statusCode}');
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      print('❌ createBooking error: $e');
      return {'success': false, 'message': 'Gagal membuat booking: $e'};
    }
  }

  // UPLOAD DP (Support Web & Mobile)
  static Future<Map<String, dynamic>> uploadDp(
    int bookingId,
    int amount,
    File? proofFile, {
    Uint8List? proofBytes,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/booking/$bookingId/upload-dp'),
      );
      request.fields['amount'] = amount.toString();

      if (kIsWeb && proofBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'proof',
          proofBytes,
          filename: 'bukti_dp_$bookingId.png',
        ));
      } else if (proofFile != null) {
        request.files.add(await http.MultipartFile.fromPath('proof', proofFile.path));
      } else {
        return {'success': false, 'message': 'Bukti pembayaran tidak tersedia'};
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      return {'success': false, 'message': 'Gagal upload DP: $e'};
    }
  }

  static Future<List<dynamic>> getMyBookings(int userId) async {
    try {
      print('📡 GET /booking/user/$userId');
      final response = await http.get(Uri.parse('$baseUrl/booking/user/$userId')).timeout(const Duration(seconds: 30));
      print('📡 Response status: ${response.statusCode}');
      final data = jsonDecode(response.body);
      return data['success'] == true ? data['bookings'] : [];
    } catch (e) {
      print('❌ getMyBookings error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> checkIn(String bookingCode) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/checkin/$bookingCode')).timeout(const Duration(seconds: 30));
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      return {'success': false, 'message': 'Gagal check-in: $e'};
    }
  }

  static Future<Map<String, dynamic>> checkOut(String bookingCode) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/checkout/$bookingCode')).timeout(const Duration(seconds: 30));
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      return {'success': false, 'message': 'Gagal check-out: $e'};
    }
  }

  // ─── CHECKOUT PROCESS & PAYMENT CONFIRMATION ──────────────
  static Future<Map<String, dynamic>> processCheckout(String bookingCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkout-process/$bookingCode'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      return {'success': false, 'message': 'Gagal proses check-out: $e'};
    }
  }

  static Future<Map<String, dynamic>> confirmFinalPayment(int paymentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/confirm-payment/$paymentId'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      return {'success': false, 'message': 'Gagal konfirmasi pembayaran: $e'};
    }
  }

  // ─── CANCEL BOOKING (untuk expired) ──────────────────────
  static Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    try {
      print('📡 POST /booking/cancel/$bookingId');
      final response = await http.post(
        Uri.parse('$baseUrl/booking/cancel/$bookingId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));
      print('📡 Response status: ${response.statusCode}');
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      print('❌ cancelBooking error: $e');
      return {'success': false, 'message': 'Gagal batalkan booking: $e'};
    }
  }

  // Tambahkan di ApiService
static Future<void> saveLastEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_email', email);
}

static Future<String?> getLastEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('last_email');
}
}
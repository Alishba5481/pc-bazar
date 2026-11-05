import 'dart:convert';
import 'package:http/http.dart' as http;

class FraudDetectionService {
  static const String apiUrl = "http://localhost:5000/check_fraud";


  static Future<Map<String, dynamic>> checkFraud({
    required String title,
    required String description,
    required String category,
    required double price,
  }) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "category": category,
        "price": price,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Fraud detection failed");
    }
  }
}

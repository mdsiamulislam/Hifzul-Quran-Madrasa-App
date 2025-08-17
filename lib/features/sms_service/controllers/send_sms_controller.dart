import 'dart:convert';
import 'package:hifzul_quran_madrasa/core/constents/string_constents/api_endpoints.dart';
import 'package:http/http.dart' as http;

class SMSSender {
  Future<void> sendSMS({required String numbers, required String message}) async {
    final response = await http.post(
      Uri.parse(APIEndpoints.smsSend),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "ApiKey": "",
        "SenderID": "8809617611819",
        "Numbers": numbers,
        "Message": message,
        "IsUnicode": 1,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final errorCode = data['ErrorCode']?.toString();

      switch (errorCode) {
        case "1":
          return;
        case "2":
          throw Exception("Invalid or missing ApiKey.");
        case "3":
          throw Exception("SenderID not found or invalid.");
        case "4":
          throw Exception("Numbers not found.");
        case "5":
          throw Exception("Invalid mobile number.");
        case "6":
          throw Exception("SMS body is empty or missing.");
        case "7":
          throw Exception("Invalid IsUnicode value (only 1 or 2 allowed).");
        case "10":
          throw Exception("Not enough balance.");
        case "101":
          throw Exception("Not enough balance in administrator account.");
        case "405":
          throw Exception("Method not allowed.");
        default:
          throw Exception("Unknown error: ${data['Error']}");
      }
    } else {
      throw Exception("Failed to send SMS (HTTP ${response.statusCode})");
    }
  }
}
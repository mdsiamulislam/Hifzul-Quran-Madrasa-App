import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constents/string_constents/api_endpoints.dart';

class SMSBalanceCheck {

  Future<int> getBalance() async {

    final response = await http.get(
      Uri.parse("${APIEndpoints.smsBalance}?ApiKey=NDkxNjUzNDgxNDcxNzU1MzIxMDY3NDMxNzcxMTk"),
    );
    print("SMS Balance Check Response: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final errorCode = data['ErrorCode']?.toString();

      if (errorCode == "11") {
        double balance = double.tryParse(data['balance'].toString()) ?? 0.0;
        double nonMaskedRate = double.tryParse(data['NonMaskingRate'].toString()) ?? 0.0;

        int remainingBalance = 0;
        if (nonMaskedRate > 0) {
          remainingBalance = (balance / nonMaskedRate).floor(); // safer than toInt()
        }
        return remainingBalance;

      } else if (errorCode == "2") {
        throw Exception("Invalid or missing ApiKey.");
      } else if (errorCode == "3") {
        throw Exception("SenderID not found or invalid.");
      } else if (errorCode == "4") {
        throw Exception("Numbers not found.");
      } else if (errorCode == "5") {
        throw Exception("Invalid mobile number.");
      } else if (errorCode == "6") {
        throw Exception("SMS body is empty or missing.");
      } else if (errorCode == "7") {
        throw Exception("Invalid IsUnicode value (only 1 or 2 allowed).");
      } else if (errorCode == "10") {
        throw Exception("Not enough balance.");
      } else if (errorCode == "101") {
        throw Exception("Not enough balance in administrator account.");
      } else if (errorCode == "405") {
        throw Exception("Method not allowed.");
      } else {
        throw Exception("Unknown error: ${data['Error']}");
      }
    } else {
      throw Exception('Failed to fetch balance');
    }
  }

}
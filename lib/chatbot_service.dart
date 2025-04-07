import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  //static const String apiUrl = "http://localhost:8000/chatbot";
  static const String apiUrl = "http://10.0.2.2:8000/chatbot";
  //static const String apiUrl = "http:// 192.168.100.18:8000/chatbot";



  static Future<Map<String, dynamic>> sendMessage(String user, String message) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user": user, "message": message}),
      );

      // Debugging: Print raw API response
      print("Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        // Ensure response body does not contain `NaN` before decoding
        String cleanedBody = response.body.replaceAll('NaN', 'null');


        var decodedBody = jsonDecode(cleanedBody);

        // Ensure `remedies` exist and are valid
        if (decodedBody["remedies"] != null && decodedBody["remedies"] is List) {
          for (var remedy in decodedBody["remedies"]) {
            if (remedy is Map) {
              remedy["name"] = _sanitizeString(remedy["name"], "Unknown Remedy");
              remedy["remedy"] = _sanitizeString(remedy["remedy"], "No details available");
              remedy["yogasan"] = _sanitizeString(remedy["yogasan"], "");
            }
          }
        }

        // Debugging: Print final processed response

        return {
          "response": decodedBody["response"] ?? "No response available",
          "remedies": decodedBody["remedies"] ?? []
        };
      } else {
        print("API Error: ${response.statusCode}, Response: ${response.body}");
        return {
          "response": "API Error: ${response.statusCode}",
          "remedies": []
        };
      }
    } catch (e) {
      print("Chatbot API Error: $e");
      return {
        "response": "Error: Unable to connect to chatbot.",
        "remedies": []
      };
    }
  }

  // Helper function to sanitize string values and replace invalid ones
  static String _sanitizeString(dynamic value, String defaultValue) {
    if (value == null || value.toString().toLowerCase() == "nan") {
      return defaultValue;
    }
    return value.toString();
  }
}

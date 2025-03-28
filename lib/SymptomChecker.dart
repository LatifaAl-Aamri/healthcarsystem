import 'dart:convert';
import 'package:flutter/services.dart';

class SymptomChecker {
  List<dynamic> _data = [];

  Future<void> loadData() async {
    String jsonString = await rootBundle.loadString('assets/medical_conditions.json');
    _data = json.decode(jsonString);
  }

  String diagnose(String userInput) {
    List<String> words = userInput.toLowerCase().split(" ");
    for (var record in _data) {
      List<String> symptoms = List<String>.from(record["symptoms"]);
      if (symptoms.any((symptom) => words.contains(symptom))) {
        return "Condition: ${record["condition"]}\nRemedy: ${record["remedy"]}";
      }
    }
    return "No match found. Try describing your symptoms differently.";
  }
}

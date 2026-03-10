import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataService {
  static Box get _box => Hive.box('studentBox');

  // New: Batch sync function
  static Future<void> syncOfflineData() async {
    // Only keeping empty method since auto-sync is no longer required but the method might be called
    debugPrint("App is in offline mode only. Supabase sync disabled.");
  }

  // Updated: Save with email as the key for easy identification
  static Future<void> saveStudentData(Map<String, dynamic> data) async {
    await _box.put(data['email'], data); // Save to Hive immediately
    debugPrint("Student data saved to Hive locally.");
  }
}

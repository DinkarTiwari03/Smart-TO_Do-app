import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/notification_settings.dart';

class NotificationSettingsRepository {
  static const String _storageKey = 'notification_settings_v1';

  Future<NotificationSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) {
        return const NotificationSettings();
      }
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return NotificationSettings.fromJson(map);
    } catch (_) {
      return const NotificationSettings();
    }
  }

  Future<void> saveSettings(NotificationSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(settings.toJson()));
    } catch (_) {
      // Ignore in environments without platform channel (e.g. unit tests)
    }
  }
}

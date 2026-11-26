class AppConstants {
  AppConstants._();

  static const String appName = 'Smart Professor Assistant';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Academic Productivity & Research Workflow Suite';

  // Network Defaults
  static const String defaultBaseUrl = 'https://api.smartprofessor.local/v1';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Database
  static const String databaseName = 'smart_professor_assistant.db';
  static const int databaseSchemaVersion = 3;

  // Storage Keys
  static const String themePreferenceKey = 'app_theme_mode';
  static const String userTokenKey = 'auth_user_token';
}

class AppConstants {
  AppConstants._();

  // App information
  static const String appName = 'AgriCentre';
  static const String appVersion = '1.0.0';

  // Application timing
  static const Duration splashDuration = Duration(seconds: 2);

  // Sensor monitoring
  static const int sensorUpdateIntervalSeconds = 5;

  // Quality monitoring
  static const double qualityScoreExcellent = 90.0;
  static const double qualityScoreGood = 75.0;
  static const double qualityScoreWarning = 50.0;

  // Transportation monitoring
  static const double defaultTemperatureMin = 2.0;
  static const double defaultTemperatureMax = 30.0;

  static const double defaultHumidityMin = 30.0;
  static const double defaultHumidityMax = 80.0;

   // Local storage keys
  static const String isLoggedInKey = 'is_logged_in';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String userRoleKey = 'user_role';

  // User roles
  static const String farmerRole = 'Farmer';
  static const String transporterRole = 'Transporter';
  static const String buyerRole = 'Buyer / Customer';

  // Pagination
  static const int defaultPageSize = 20;
}
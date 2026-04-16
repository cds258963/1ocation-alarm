class AppConstants {
  // 应用信息
  static const String appName = '位置闹钟';
  static const String appVersion = '1.0.0';

  // 数据库
  static const String databaseName = 'location_alarm.db';
  static const int databaseVersion = 1;

  // 地理围栏
  static const double minRadius = 250.0; // 米
  static const double maxRadius = 3000.0; // 米
  static const List<double> radiusOptions = [250, 500, 1000, 2000, 3000];

  // 定位模式
  static const int powerSavingInterval = 300000; // 5 分钟
  static const int balancedInterval = 60000; // 1 分钟
  static const int highAccuracyInterval = 30000; // 30 秒

  // 通知
  static const String notificationChannelId = 'alarm_channel';
  static const String notificationChannelName = '闹钟提醒';

  // 存储
  static const String prefsKeyAlarms = 'alarms';
  static const String prefsKeySettings = 'settings';
}

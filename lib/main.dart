import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'core/theme/app_theme.dart';
import 'di/injection_container.dart' as di;
import 'features/alarm/presentation/providers/alarm_provider.dart';
import 'features/map/presentation/providers/map_provider.dart';
import 'features/notification/presentation/services/notification_service.dart';
import 'features/alarm/presentation/screens/alarm_list_screen.dart';
import 'features/geofence/presentation/services/geofence_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化依赖注入
  await di.init();

  // 初始化通知
  await NotificationService.instance.initialize();

  // 初始化地理围栏
  try {
    await GeofenceManager.instance.initialize();
  } catch (e) {
    print('地理围栏初始化失败：$e');
  }

  runApp(const LocationAlarmApp());
}

class LocationAlarmApp extends StatelessWidget {
  const LocationAlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlarmProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
      ],
      child: MaterialApp(
        title: '位置闹钟',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AlarmListScreen(),
      ),
    );
  }
}

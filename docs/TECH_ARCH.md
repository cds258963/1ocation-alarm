# 🏗️ 技术架构文档

## 整体架构

采用 **Clean Architecture + Provider 状态管理**

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (Screens, Widgets, Providers, State)   │
├─────────────────────────────────────────┤
│             Domain Layer                │
│     (Use Cases, Entities, Interfaces)   │
├─────────────────────────────────────────┤
│              Data Layer                 │
│  (Repositories, Data Sources, Models)   │
└─────────────────────────────────────────┘
```

---

## 目录结构

```
lib/
├── main.dart                        # 应用入口
├── app.dart                         # 应用配置
│
├── core/                            # 核心层
│   ├── constants/
│   │   ├── app_constants.dart       # 应用常量
│   │   └── api_constants.dart       # API 常量
│   ├── errors/
│   │   ├── exceptions.dart          # 自定义异常
│   │   └── failures.dart            # 失败处理
│   ├── utils/
│   │   ├── logger.dart              # 日志工具
│   │   ├── permissions.dart         # 权限工具
│   │   └── helpers.dart             # 辅助函数
│   └── theme/
│       ├── app_theme.dart           # 主题配置
│       └── app_colors.dart          # 颜色配置
│
├── features/                        # 功能模块
│   ├── alarm/                       # 闹钟功能
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── alarm_local_datasource.dart
│   │   │   │   └── geofence_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── alarm_model.dart
│   │   │   │   └── geofence_model.dart
│   │   │   └── repositories/
│   │   │       └── alarm_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── alarm_entity.dart
│   │   │   │   └── geofence_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── alarm_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_alarm.dart
│   │   │       ├── delete_alarm.dart
│   │   │       ├── update_alarm.dart
│   │   │       └── get_alarms.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── alarm_provider.dart
│   │       ├── screens/
│   │       │   ├── alarm_list_screen.dart
│   │       │   ├── alarm_detail_screen.dart
│   │       │   └── alarm_setup_screen.dart
│   │       └── widgets/
│   │           ├── alarm_card.dart
│   │           └── radius_selector.dart
│   │
│   ├── map/                         # 地图功能
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       └── map_datasource.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── location_entity.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── map_provider.dart
│   │       ├── screens/
│   │       │   └── map_screen.dart
│   │       └── widgets/
│   │           ├── map_view.dart
│   │           └── location_marker.dart
│   │
│   ├── geofence/                    # 地理围栏功能
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       └── geofence_local_datasource.dart
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── start_monitoring.dart
│   │   │       └── stop_monitoring.dart
│   │   └── presentation/
│   │       └── services/
│   │           └── geofence_service.dart
│   │
│   └── notification/                # 通知功能
│       ├── data/
│       │   └── datasources/
│       │       └── notification_datasource.dart
│       └── presentation/
│           └── services/
│               └── notification_service.dart
│
└── di/                              # 依赖注入
    └── injection_container.dart
```

---

## 核心模块设计

### 1. 闹钟数据模型

```dart
// lib/features/alarm/domain/entities/alarm_entity.dart
class AlarmEntity {
  final String id;
  final String name;
  final LocationEntity location;
  final double radius; // 米
  final bool triggerOnEnter;
  final bool triggerOnExit;
  final TimeRange? timeRange;
  final WeekDays? weekDays;
  final NotificationSettings notificationSettings;
  final MonitoringMode monitoringMode;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  AlarmEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.radius,
    this.triggerOnEnter = true,
    this.triggerOnExit = false,
    this.timeRange,
    this.weekDays,
    required this.notificationSettings,
    this.monitoringMode = MonitoringMode.balanced,
    this.isEnabled = true,
    required this.createdAt,
    this.updatedAt,
  });
}

enum MonitoringMode {
  powerSaving,    // 5 分钟
  balanced,       // 1 分钟
  highAccuracy,   // 30 秒
}
```

### 2. 位置实体

```dart
// lib/features/map/domain/entities/location_entity.dart
class LocationEntity {
  final double latitude;
  final double longitude;
  final String? address;
  final String? name;
  
  LocationEntity({
    required this.latitude,
    required this.longitude,
    this.address,
    this.name,
  });
}
```

### 3. 地理围栏服务

```dart
// lib/features/geofence/presentation/services/geofence_service.dart
class GeofenceService {
  final Geofencing _geofencing;
  final NotificationService _notificationService;
  
  // 创建围栏
  Future<void> createGeofence(AlarmEntity alarm) async {
    await _geofencing.addGeofence(
      id: alarm.id,
      latitude: alarm.location.latitude,
      longitude: alarm.location.longitude,
      radius: alarm.radius,
      transitionTypes: _buildTransitionTypes(alarm),
    );
  }
  
  // 开始监控
  Future<void> startMonitoring() async {
    await _geofencing.startMonitoring();
  }
  
  // 停止监控
  Future<void> stopMonitoring() async {
    await _geofencing.stopMonitoring();
  }
  
  // 监听事件
  Stream<GeofenceEvent> listenToEvents() {
    return _geofencing.onGeofenceEvent.map((event) {
      return _handleGeofenceEvent(event);
    });
  }
  
  TransitionTypes _buildTransitionTypes(AlarmEntity alarm) {
    int types = 0;
    if (alarm.triggerOnEnter) types |= TransitionTypes.enter;
    if (alarm.triggerOnExit) types |= TransitionTypes.exit;
    return types;
  }
}
```

### 4. 通知服务

```dart
// lib/features/notification/presentation/services/notification_service.dart
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications;
  
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );
  }
  
  Future<void> showAlarmTriggered(AlarmEntity alarm, bool isEnter) async {
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      '闹钟提醒',
      channelDescription: '地理围栏触发提醒',
      importance: Importance.high,
      priority: Priority.high,
      fullScreenIntent: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    await _notifications.show(
      alarm.id.hashCode,
      isEnter ? '到达提醒' : '离开提醒',
      '您已${isEnter ? '到达' : '离开'} ${alarm.name}',
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: alarm.id,
    );
  }
}
```

### 5. 本地数据库

```dart
// lib/features/alarm/data/datasources/alarm_local_datasource.dart
class AlarmLocalDataSource {
  final Database _database;
  
  // 插入闹钟
  Future<int> insert(AlarmModel alarm) async {
    return await _database.insert('alarms', alarm.toMap());
  }
  
  // 查询所有闹钟
  Future<List<AlarmModel>> getAll() async {
    final maps = await _database.query('alarms');
    return maps.map((map) => AlarmModel.fromMap(map)).toList();
  }
  
  // 更新闹钟
  Future<int> update(AlarmModel alarm) async {
    return await _database.update(
      'alarms',
      alarm.toMap(),
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }
  
  // 删除闹钟
  Future<int> delete(String id) async {
    return await _database.delete(
      'alarms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// 数据库初始化
Future<Database> initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'location_alarm.db');
  
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE alarms (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          address TEXT,
          radius REAL NOT NULL,
          trigger_on_enter INTEGER DEFAULT 1,
          trigger_on_exit INTEGER DEFAULT 0,
          start_time TEXT,
          end_time TEXT,
          week_days TEXT,
          notification_sound TEXT,
          notification_vibrate INTEGER DEFAULT 1,
          repeat_count INTEGER DEFAULT 1,
          monitoring_mode TEXT DEFAULT 'balanced',
          is_enabled INTEGER DEFAULT 1,
          created_at TEXT NOT NULL,
          updated_at TEXT
        )
      ''');
    },
  );
}
```

---

## 状态管理 (Provider)

### 闹钟 Provider

```dart
// lib/features/alarm/presentation/providers/alarm_provider.dart
class AlarmProvider extends StateNotifier<List<AlarmEntity>> {
  final GetAlarmsUseCase _getAlarms;
  final CreateAlarmUseCase _createAlarm;
  final UpdateAlarmUseCase _updateAlarm;
  final DeleteAlarmUseCase _deleteAlarm;
  
  AlarmProvider({
    required GetAlarmsUseCase getAlarms,
    required CreateAlarmUseCase createAlarm,
    required UpdateAlarmUseCase updateAlarm,
    required DeleteAlarmUseCase deleteAlarm,
  })  : _getAlarms = getAlarms,
        _createAlarm = createAlarm,
        _updateAlarm = updateAlarm,
        _deleteAlarm = deleteAlarm,
        super([]);
  
  Future<void> loadAlarms() async {
    final alarms = await _getAlarms();
    state = alarms;
  }
  
  Future<void> createAlarm(AlarmEntity alarm) async {
    await _createAlarm(alarm);
    state = [...state, alarm];
  }
  
  Future<void> updateAlarm(AlarmEntity alarm) async {
    await _updateAlarm(alarm);
    state = state.map((a) => a.id == alarm.id ? alarm : a).toList();
  }
  
  Future<void> deleteAlarm(String id) async {
    await _deleteAlarm(id);
    state = state.where((a) => a.id != id).toList();
  }
}
```

---

## 权限处理

```dart
// lib/core/utils/permissions.dart
class PermissionHandler {
  // 请求定位权限
  Future<bool> requestLocationPermission() async {
    // Android 13+ 需要请求通知权限
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }
    
    // 请求精确定位
    var locationStatus = await Permission.locationWhenInUse.status;
    if (!locationStatus.isGranted) {
      locationStatus = await Permission.locationWhenInUse.request();
    }
    
    // 请求后台定位（关键！）
    var backgroundStatus = await Permission.locationAlways.status;
    if (!backgroundStatus.isGranted) {
      backgroundStatus = await Permission.locationAlways.request();
    }
    
    return backgroundStatus.isGranted;
  }
  
  // 检查电池优化
  Future<bool> isBatteryOptimizationEnabled() async {
    // 使用 flutter_battery 包检测
    return await Battery.isBatteryOptimizationEnabled;
  }
  
  // 引导用户关闭电池优化
  Future<void> requestIgnoreBatteryOptimization() async {
    // 跳转到系统设置页
    await Battery.requestIgnoreBatteryOptimization;
  }
}
```

---

## 后台保活方案

### Android 前台服务

```kotlin
// android/app/src/main/kotlin/.../LocationAlarmService.kt
class LocationAlarmService : Service() {
    override fun onCreate() {
        super.onCreate()
        
        // 创建通知渠道
        createNotificationChannel()
        
        // 启动前台服务
        val notification = createNotification()
        startForeground(1, notification)
        
        // 启动地理围栏监控
        startGeofenceMonitoring()
    }
    
    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, "monitoring_channel")
            .setContentTitle("位置闹钟")
            .setContentText("正在监控位置...")
            .setSmallIcon(R.drawable.ic_notification)
            .setOngoing(true)
            .build()
    }
}
```

---

## 依赖注入

```dart
// lib/di/injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // Features - Alarm
  sl.registerLazySingleton(() => CreateAlarmUseCase(sl()));
  sl.registerLazySingleton(() => GetAlarmsUseCase(sl()));
  
  sl.registerLazySingleton<AlarmRepository>(
    () => AlarmRepositoryImpl(sl(), sl()),
  );
  
  sl.registerLazySingleton<AlarmLocalDataSource>(
    () => AlarmLocalDataSourceImpl(sl()),
  );
  
  // Features - Geofence
  sl.registerLazySingleton(() => GeofenceService(sl(), sl()));
  
  // Features - Notification
  sl.registerLazySingleton(() => NotificationService());
  
  // Core
  sl.registerLazySingleton(() => PermissionHandler());
  
  // External
  final database = await initDatabase();
  sl.registerLazySingleton(() => database);
}
```

---

## 第三方依赖

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 地图
  amap_flutter_map: ^10.0.0
  amap_flutter_location: ^10.0.0
  
  # 定位与地理围栏
  location: ^5.0.0
  geofencing: ^0.1.0
  
  # 通知
  flutter_local_notifications: ^16.0.0
  
  # 数据库
  sqflite: ^2.3.0
  path_provider: ^2.1.0
  
  # 状态管理
  provider: ^6.1.0
  # 或 Riverpod
  # flutter_riverpod: ^2.4.0
  
  # 权限
  permission_handler: ^11.0.0
  
  # 依赖注入
  get_it: ^7.6.0
  
  # 其他工具
  intl: ^0.18.0          # 日期格式化
  uuid: ^4.0.0           # 生成唯一 ID
  shared_preferences: ^2.2.0  # 轻量存储
```

---

## 测试策略

### 单元测试
```dart
test('CreateAlarmUseCase should create alarm', () async {
  final mockRepo = MockAlarmRepository();
  final usecase = CreateAlarmUseCase(mockRepo);
  
  when(mockRepo.create(any)).thenAnswer((_) async => true);
  
  final result = await usecase(testAlarm);
  
  expect(result.isSuccess, true);
  verify(mockRepo.create(testAlarm)).called(1);
});
```

### Widget 测试
```dart
testWidgets('AlarmCard displays alarm name', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: AlarmCard(alarm: testAlarm),
    ),
  );
  
  expect(find.text(testAlarm.name), findsOneWidget);
});
```

---

## 性能优化

1. **地图优化**
   - 使用缓存瓦片
   - 限制标记点数量
   - 懒加载地图资源

2. **定位优化**
   - 根据模式调整频率
   - 使用融合定位（GPS + 基站 + WiFi）
   - 静止时降低频率

3. **数据库优化**
   - 使用索引
   - 批量操作
   - 异步查询

4. **内存优化**
   - 及时释放监听器
   - 图片缓存
   - 避免内存泄漏

---

## 安全考虑

1. **数据存储**
   - 敏感数据加密存储
   - 不使用明文存储位置

2. **权限最小化**
   - 仅请求必要权限
   - 提供权限说明

3. **隐私保护**
   - 不上传用户位置
   - 提供数据导出/删除功能

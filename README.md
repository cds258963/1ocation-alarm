# 📍 位置闹钟 (Location Alarm)

基于 Flutter 的地理围栏提醒应用，支持 Android 优先，保留 iOS 扩展性。

---

## 🎯 项目目标

在地图上设置位置，当手机进入/离开该区域时自动提醒。

**核心功能：**
- 地图选点设置闹钟
- 自定义提醒半径（250m - 3000m）
- 进入/离开区域触发提醒
- 后台位置监控
- 推送通知 + 语音提醒

---

## 🛠️ 技术栈

| 组件 | 技术选型 |
|------|----------|
| 框架 | Flutter 3.x (Dart) |
| 地图 | 高德地图 Flutter SDK (`amap_flutter_map`) |
| 定位 | `location` 插件 + 后台定位服务 |
| 地理围栏 | `geofencing` 插件 |
| 通知 | `flutter_local_notifications` |
| 数据库 | `sqflite` (本地存储闹钟配置) |
| 状态管理 | Provider / Riverpod |

---

## 📦 环境要求

### 开发环境
- Flutter SDK 3.0+
- Android Studio / VS Code
- Android SDK 21+
- JDK 11+

### 高德地图配置
1. 注册高德开放平台账号：https://lbs.amap.com/
2. 创建应用，获取 API Key：
   - **Android Key**：包名_签名 (如：com.example.location_alarm_XXX)
   - **iOS Key**：Bundle ID_签名 (后期扩展用)

---

## 🚀 快速开始

### 1. 安装 Flutter (Linux)

```bash
# 安装依赖
sudo apt update
sudo apt install -y git curl unzip wget libgtk-3-dev clang cmake ninja-build pkg-config

# 方式一：Snap 安装（推荐）
sudo snap install flutter --classic

# 方式二：手动安装
cd ~
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 验证安装
flutter doctor
```

### 2. 创建项目

```bash
flutter create --org com.example --project-name location_alarm
cd location_alarm
```

### 3. 添加依赖

`pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 高德地图
  amap_flutter_map: ^10.0.0
  amap_flutter_location: ^10.0.0
  
  # 定位与地理围栏
  location: ^5.0.0
  geofencing: ^0.1.0
  
  # 通知
  flutter_local_notifications: ^16.0.0
  
  # 数据存储
  sqflite: ^2.3.0
  path_provider: ^2.1.0
  
  # 状态管理
  provider: ^6.1.0
  
  # 权限处理
  permission_handler: ^11.0.0
```

### 4. 配置高德地图 Key

**Android**: `android/app/src/main/AndroidManifest.xml`
```xml
<application>
    <!-- 高德地图 API Key -->
    <meta-data
        android:name="com.amap.api.v2.apikey"
        android:value="你的 Android Key" />
    
    <!-- 必要权限 -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
</application>
```

---

## 📁 项目结构

```
lib/
├── main.dart                    # 入口 + 初始化
├── config/
│   ├── api_keys.dart           # 高德 Key 配置
│   └── constants.dart          # 常量定义
├── models/
│   ├── alarm.dart              # 闹钟数据模型
│   └── geofence.dart           # 地理围栏模型
├── services/
│   ├── location_service.dart   # 定位服务
│   ├── geofence_service.dart   # 地理围栏管理
│   ├── notification_service.dart # 通知服务
│   └── database_service.dart   # 本地数据库
├── providers/
│   ├── alarm_provider.dart     # 闹钟状态管理
│   └── location_provider.dart  # 位置状态管理
├── screens/
│   ├── home_screen.dart        # 主页（地图选点）
│   ├── alarm_list_screen.dart  # 闹钟列表
│   ├── alarm_detail_screen.dart # 闹钟详情
│   └── settings_screen.dart    # 设置页
├── widgets/
│   ├── map_picker.dart         # 地图选点组件
│   ├── alarm_card.dart         # 闹钟卡片
│   └── radius_slider.dart      # 半径选择器
└── utils/
    ├── permissions.dart        # 权限请求
    └── helpers.dart            # 工具函数
```

---

## 🔑 核心功能实现

### 1. 初始化高德地图

```dart
// lib/main.dart
import 'package:amap_flutter_map/amap_flutter_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 设置高德地图 API Key
  await AmapFlutterMap.getInstance().init(
    iosApiKey: '你的 iOS Key',     // 后期扩展
    androidApiKey: '你的 Android Key',
  );
  
  runApp(const LocationAlarmApp());
}
```

### 2. 创建地理围栏

```dart
// lib/services/geofence_service.dart
import 'package:geofencing/geofencing.dart';

class GeofenceService {
  final Geofencing _geofencing = Geofencing();
  
  Future<void> createGeofence({
    required String id,
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    await _geofencing.addGeofence(
      id: id,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      onEnter: () => _onEnter(id),
      onExit: () => _onExit(id),
    );
  }
  
  void _onEnter(String id) {
    // 触发进入提醒
    NotificationService.showNotification(
      title: '到达目的地',
      body: '您已进入闹钟区域',
    );
  }
  
  void _onExit(String id) {
    // 触发离开提醒
    NotificationService.showNotification(
      title: '离开提醒',
      body: '您已离开闹钟区域',
    );
  }
}
```

### 3. 后台定位配置

```dart
// Android: android/app/src/main/AndroidManifest.xml
<application>
    <!-- 前台服务通知 -->
    <service
        android:name="id.flutter.geofencing.GeofencingPlugin"
        android:enabled="true"
        android:exported="true"
        android:foregroundServiceType="location" />
</application>
```

---

## 📝 开发清单

- [ ] 环境搭建（Flutter + Android Studio）
- [ ] 高德地图 Key 申请
- [ ] 项目初始化
- [ ] 地图选点功能
- [ ] 闹钟创建/编辑/删除
- [ ] 地理围栏后台监控
- [ ] 推送通知
- [ ] 本地数据库存储
- [ ] 权限处理（定位、后台运行）
- [ ] 电池优化适配
- [ ] UI/UX 优化
- [ ] 测试与发布

---

## 🔗 参考资源

- Flutter 官网：https://flutter.dev
- 高德开放平台：https://lbs.amap.com/
- Flutter 高德插件：https://pub.dev/packages/amap_flutter_map
- 地理围栏插件：https://pub.dev/packages/geofencing

---

**下一步：** 安装 Flutter 环境，创建项目仓库

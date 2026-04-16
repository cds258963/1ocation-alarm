# 🚀 快速开始指南

## 环境要求

- Flutter SDK 3.0+
- Android Studio / VS Code
- Android SDK 21+
- JDK 11+

---

## 1. 安装 Flutter

### Linux (Ubuntu/Debian)

```bash
# 安装依赖
sudo apt update
sudo apt install -y git curl unzip wget libgtk-3-dev clang cmake ninja-build pkg-config

# 下载 Flutter
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# 配置 PATH
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 验证安装
flutter --version

# 预下载资源
flutter precache

# 检查环境
flutter doctor
```

### macOS

```bash
# 使用 Homebrew
brew install --cask flutter

# 或使用手动安装
cd ~
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

flutter doctor
```

### Windows

1. 下载 Flutter SDK: https://docs.flutter.dev/get-started/install/windows
2. 解压到 `C:\src\flutter`
3. 添加 `C:\src\flutter\bin` 到 PATH
4. 运行 `flutter doctor`

---

## 2. 安装 Android Studio

1. 下载：https://developer.android.com/studio
2. 安装后打开，完成初始化
3. 安装 Flutter 和 Dart 插件
4. 创建 Android 模拟器（AVD）

---

## 3. 配置项目

```bash
# 进入项目目录
cd location-alarm

# 安装依赖
flutter pub get

# 检查环境
flutter doctor
```

---

## 4. 申请高德地图 Key

1. 访问高德开放平台：https://lbs.amap.com/
2. 注册/登录开发者账号
3. 进入"应用管理" → "我的应用"
4. 创建新应用
5. 添加 Key：
   - 服务平台：Android 平台
   - 包名：`com.example.location_alarm`
   - 签名 SHA1：见下方获取方法

### 获取 SHA1 签名

```bash
cd android
./gradlew signingReport
```

或使用 keytool：

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

---

## 5. 配置高德 Key

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<application>
    <!-- 取消注释并替换为你的 Key -->
    <meta-data
        android:name="com.amap.api.v2.apikey"
        android:value="你的 Android Key" />
</application>
```

编辑 `lib/main.dart`：

```dart
// 取消注释并配置
await AmapFlutterMap.getInstance().init(
  iosApiKey: '你的 iOS Key',     // 可选，后期扩展
  androidApiKey: '你的 Android Key',
);
```

---

## 6. 运行应用

### 连接设备或启动模拟器

```bash
# 查看可用设备
flutter devices

# 启动模拟器（如果有）
flutter emulators
```

### 运行

```bash
# 运行在连接的设备上
flutter run

# 指定设备
flutter run -d <device_id>

# 发布模式
flutter run --release
```

---

## 7. 构建 APK

```bash
# 调试 APK
flutter build apk

# 发布 APK
flutter build apk --release

# 输出路径
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 常见问题

### Flutter Doctor 报错

**Android license status unknown**
```bash
flutter doctor --android-licenses
```

**Missing Android SDK**
```bash
# 在 Android Studio 中安装 SDK
Tools → SDK Manager → Android SDK
```

### 依赖安装失败

```bash
# 清理缓存
flutter clean
flutter pub cache repair
flutter pub get
```

### 构建失败

```bash
# 清理并重新构建
cd android
./gradlew clean
cd ..
flutter build apk
```

---

## 下一步

1. ✅ 运行应用查看基础 UI
2. 📝 配置高德地图 Key
3. 🗺️ 测试地图功能
4. 📍 测试地理围栏
5. 🔔 测试通知提醒

---

**开发愉快！** 🎉

如有问题，请查看：
- Flutter 官方文档：https://flutter.dev/docs
- 高德地图文档：https://lbs.amap.com/api/android-location-sdk/guide-summary-20170607

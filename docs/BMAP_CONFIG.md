# 🗺️ 百度地图配置指南

## 1. 申请百度地图 AK

### 步骤

1. **访问百度地图开放平台**
   - 网址：https://lbsyun.baidu.com/

2. **登录/注册账号**
   - 使用百度账号登录
   - 没有账号需要先注册

3. **进入控制台**
   - 点击顶部导航栏的 **控制台**
   - 或访问：https://lbsyun.baidu.com/console

4. **创建应用**
   - 点击 **应用管理** → **我的应用**
   - 点击 **创建应用**
   - 填写：
     - 应用名称：位置闹钟
     - 应用类型：其他
     - 备注：（可选）

5. **创建 AK**
   - 在应用下点击 **添加 Key**
   - 填写：
     - Key 名称：Android
     - 服务平台：Android SDK
     - 包名：`com.example.location_alarm`
     - SHA1 签名：（见下方获取方法）
   - 点击 **提交**

6. **复制 AK**
   - 创建成功后会显示 AK（Access Key）
   - 复制保存（32 位字符串）

---

## 2. 获取 SHA1 签名

### 方法一：使用 Gradle（推荐）

```bash
cd android
./gradlew signingReport
```

在输出中找到：
```
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

### 方法二：使用 keytool

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

---

## 3. 配置到项目中

### 编辑 AndroidManifest.xml

文件路径：`android/app/src/main/AndroidManifest.xml`

找到以下代码，取消注释并替换为你的 AK：

```xml
<application>
    <!-- 百度地图 API Key -->
    <meta-data
        android:name="com.baidu.lbsapi.API_KEY"
        android:value="你的 32 位 AK" />
</application>
```

### 编辑 main.dart

文件路径：`lib/main.dart`

找到以下代码，取消注释并替换为你的 AK：

```dart
void main() async {
  // ...
  
  // 初始化百度地图
  await BMapSDK.init('你的百度地图 AK');
  
  // ...
}
```

### 编辑 bmap_screen.dart

文件路径：`lib/features/map/presentation/screens/bmap_screen.dart`

找到以下代码，取消注释并替换占位区域：

```dart
// 百度地图组件
BMapp(
  apiKey: '你的百度地图 AK',
  center: const LatLng(39.9042, 116.4074),
  zoom: 15.0,
  onMapCreated: (controller) {
    // 地图创建完成
  },
  onTap: (latLng) {
    // 点击地图选点
    context.read<MapProvider>().updateLocation(
      latLng.latitude,
      latLng.longitude,
    );
  },
)
```

---

## 4. 安装依赖

```bash
cd location-alarm
flutter pub get
```

---

## 5. 运行测试

```bash
flutter run
```

---

## 📋 配置检查清单

- [ ] 已申请百度地图 AK
- [ ] 已获取 SHA1 签名
- [ ] 已在 AndroidManifest.xml 配置 AK
- [ ] 已安装依赖（flutter pub get）
- [ ] 地图可以正常显示
- [ ] 点击地图可以选点
- [ ] 定位功能正常

---

## 🔧 常见问题

### Q: 地图不显示
**A:** 检查 AK 是否正确，确保包名和 SHA1 匹配

### Q: 提示"AK 不存在"
**A:** 确认 AK 已复制完整，没有多余空格

### Q: 定位失败
**A:** 检查是否已授予定位权限

### Q: SHA1 签名错误
**A:** 确保使用正确的签名（debug 版本使用 debug.keystore）

---

## 📚 参考文档

- 百度地图 Flutter SDK：https://lbsyun.baidu.com/index.php?title=flutter-SDK
- API 文档：https://lbsyun.baidu.com/index.php?title=android-locsdk/guide-and-openservice-20170717
- 常见问题：https://lbsyun.baidu.com/index.php?title=faq/android-locsdk

---

**配置完成后即可使用百度地图！** 🎉

# ⚡ 快速配置指南

## 5 分钟开始开发

### 步骤 1：安装 Flutter (如果未安装)

```bash
# Linux
cd ~
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 验证
flutter --version
```

### 步骤 2：克隆项目

```bash
git clone git@github.com:cds258963/1ocation-alarm.git
cd location-alarm
```

### 步骤 3：安装依赖

```bash
flutter pub get
```

### 步骤 4：申请高德地图 Key

1. 访问：https://lbs.amap.com/
2. 登录/注册开发者账号
3. 进入 **控制台** → **应用管理** → **我的应用**
4. 点击 **创建新应用**
   - 应用名称：位置闹钟
   - 应用类型：其他
5. 添加 Key：
   - 服务平台：**Android 平台**
   - 包名：`com.example.location_alarm`
   - SHA1 签名：运行以下命令获取
   ```bash
   cd android
   ./gradlew signingReport
   ```
   找到 `SHA1` 字段，复制值

6. 提交后获得 **Key (32 位字符串)**

### 步骤 5：配置 Key

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<application>
    <!-- 找到这行，取消注释并替换为你的 Key -->
    <meta-data
        android:name="com.amap.api.v2.apikey"
        android:value="你的 32 位 Key" />
</application>
```

### 步骤 6：运行应用

```bash
# 连接设备或启动模拟器
flutter devices

# 运行
flutter run
```

---

## 🎉 完成！

现在你可以：
- ✅ 查看闹钟列表
- ✅ 创建新闹钟
- ✅ 设置地理围栏
- ✅ 接收通知提醒

---

## 常见问题

### Q: `flutter: command not found`
**A:** 确保已将 Flutter 添加到 PATH，重新打开终端或运行 `source ~/.bashrc`

### Q: `No devices found`
**A:** 
- 连接 Android 设备并开启 USB 调试
- 或创建模拟器：`flutter emulators`

### Q: 构建失败
**A:** 
```bash
flutter clean
flutter pub get
flutter run
```

### Q: 地图不显示
**A:** 检查高德 Key 是否正确配置，确保包名和签名匹配

---

## 下一步

1. 📱 在真机上测试地理围栏
2. 🎨 自定义 UI 和主题
3. 🔔 测试通知功能
4. 📦 构建发布版本：`flutter build apk --release`

---

**祝你开发愉快！** 🚀

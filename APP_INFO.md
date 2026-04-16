# 📱 应用配置信息

## 包名和签名

### 包名 (Package Name)
```
com.example.location_alarm
```

### SHA1 签名

**调试版本 (Debug)**

在项目中运行以下命令获取：

```bash
cd android
./gradlew signingReport
```

或者使用 keytool：

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

输出示例：
```
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

---

## 📋 配置百度地图 AK

### 1. 访问百度地图开放平台
https://lbsyun.baidu.com/

### 2. 创建应用
- 应用名称：位置闹钟
- 应用类型：其他

### 3. 添加 Key
- **Key 名称**: Android
- **服务平台**: Android SDK
- **包名**: `com.example.location_alarm`
- **SHA1**: （运行上方命令获取）

### 4. 配置到项目

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<application>
    <meta-data
        android:name="com.baidu.lbsapi.API_KEY"
        android:value="你的 AK" />
</application>
```

---

## 🔧 获取 SHA1 的两种方式

### 方式一：使用 Gradle（推荐）

```bash
cd /home/cds/.openclaw/workspace/projects/location-alarm/android
./gradlew signingReport
```

在输出中找到类似内容：
```
> Task :app:signingReport

Variant: debug
Config: debug
Store: /home/cds/.android/debug.keystore
Alias: androiddebugkey
MD5: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA-256: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
Valid until: 星期六，四月 15, 2056
```

复制 **SHA1** 行的值（去掉冒号）即可。

### 方式二：使用 keytool

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

输出：
```
Alias name: androiddebugkey
Creation date: Apr 16, 2026
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: CN=Android Debug, O=Android, C=US
Issuer: CN=Android Debug, O=Android, C=US
Serial number: xxxxxxxx
Valid from: Thu Apr 16 00:00:00 CST 2026 to: Sat Apr 15 00:00:00 CST 2056
Certificate fingerprints:
	 MD5:  XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
	 SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
	 SHA256: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

---

## 📝 注意事项

1. **调试版本 vs 发布版本**
   - 调试版使用 `debug.keystore`
   - 发布版需要使用自己的签名文件
   - 百度地图 AK 需要分别配置两个 SHA1

2. **SHA1 格式**
   - Gradle 输出带冒号：`XX:XX:XX:XX...`
   - 百度地图控制台输入时**去掉冒号**：`XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`

3. **包名必须匹配**
   - `AndroidManifest.xml` 中的 `package`
   - `build.gradle` 中的 `applicationId`
   - 百度地图控制台填写的包名
   - 三者必须完全一致

---

## 🔗 相关文档

- [百度地图配置指南](docs/BMAP_CONFIG.md)
- [快速开始](QUICK_START.md)
- [环境配置](SETUP_GUIDE.md)

---

**配置完成后即可使用百度地图！** 🎉

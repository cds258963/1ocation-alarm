# 📍 位置闹钟 (Location Alarm)

一款基于地理围栏的 Flutter 位置提醒应用，当到达或离开指定地点时自动通知。

**Android 优先 · 保留 iOS 扩展性**

---

## ✨ 功能特性

- 🗺️ **地图选点** - 在地图上选择提醒位置
- 🎯 **自定义半径** - 250m ~ 3000m 可调
- 🔔 **智能提醒** - 进入/离开区域自动通知
- ⏰ **周期设置** - 支持时间段和日期设置
- 🔋 **省电优化** - 三种监控模式可选
- 📱 **后台监控** - 持续位置追踪

---

## 📸 应用截图

> 待添加实际运行截图

---

## 🚀 快速开始

### 环境要求
- Flutter SDK 3.0+
- Android SDK 21+
- JDK 11+

### 安装步骤

```bash
# 1. 克隆项目
git clone git@github.com:cds258963/1ocation-alarm.git
cd location-alarm

# 2. 安装依赖
flutter pub get

# 3. 配置百度地图 Key（必需）
# 编辑 android/app/src/main/AndroidManifest.xml
# 添加你的百度地图 AK
# 详细配置：docs/BMAP_CONFIG.md

# 4. 运行应用
flutter run
```

**详细指南：** [QUICK_START.md](QUICK_START.md)

---

## 🛠️ 技术栈

| 组件 | 技术 |
|------|------|
| 框架 | Flutter 3.x |
| 地图 | **百度地图 SDK** |
| 状态管理 | Provider |
| 架构 | Clean Architecture |
| 数据库 | SQLite (sqflite) |
| 定位 | location 插件 |
| 通知 | flutter_local_notifications |

---

## 📁 项目结构

```
lib/
├── main.dart                    # 应用入口
├── core/                        # 核心层
│   ├── constants/               # 常量定义
│   └── theme/                   # 主题配置
├── di/                          # 依赖注入
└── features/                    # 功能模块
    ├── alarm/                   # 闹钟功能
    ├── geofence/                # 地理围栏
    ├── map/                     # 地图功能
    ├── notification/            # 通知功能
    └── settings/                # 设置功能
```

---

## 📋 开发计划

- [x] 项目架构搭建
- [x] 闹钟 CRUD 功能
- [x] UI 页面实现
- [x] 地理围栏服务
- [x] 通知系统
- [ ] 高德地图集成（需配置 Key）
- [ ] POI 搜索
- [ ] 语音播报
- [ ] 数据统计
- [ ] iOS 版本

**详细计划：** [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md)

---

## 📖 文档

| 文档 | 说明 |
|------|------|
| [QUICK_START.md](QUICK_START.md) | 5 分钟快速开始 |
| [SETUP_GUIDE.md](SETUP_GUIDE.md) | 详细环境配置 |
| [FEATURES.md](docs/FEATURES.md) | 功能规格说明 |
| [UI_DESIGN.md](docs/UI_DESIGN.md) | UI 设计文档 |
| [TECH_ARCH.md](docs/TECH_ARCH.md) | 技术架构文档 |
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | 项目完成总结 |

---

## 🔧 配置百度地图 Key

### 1. 获取 AK

1. 访问 [百度地图开放平台](https://lbsyun.baidu.com/)
2. 登录 → 控制台 → 创建应用
3. 添加 Key：Android SDK
4. 包名：`com.example.location_alarm`
5. SHA1 签名：`./gradlew signingReport`

### 2. 配置 AK

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<meta-data
    android:name="com.baidu.lbsapi.API_KEY"
    android:value="你的 AK" />
```

**详细配置：** [docs/BMAP_CONFIG.md](docs/BMAP_CONFIG.md)

---

## 📦 构建发布

```bash
# 调试版本
flutter build apk

# 发布版本
flutter build apk --release

# 输出路径
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📄 许可证

MIT License

---

## 📞 联系方式

- **GitHub:** https://github.com/cds258963/1ocation-alarm
- **问题反馈:** [创建 Issue](https://github.com/cds258963/1ocation-alarm/issues)

---

**Made with ❤️ using Flutter**

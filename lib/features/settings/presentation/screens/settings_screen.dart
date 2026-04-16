import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          // 通知设置
          _buildSectionHeader('通知设置'),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('允许通知'),
            subtitle: const Text('接收地理围栏触发提醒'),
            trailing: Switch(
              value: true, // TODO: 从设置读取
              onChanged: (value) {
                // TODO: 保存设置
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('通知铃声'),
            subtitle: const Text('系统默认'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 选择铃声
            },
          ),
          ListTile(
            leading: const Icon(Icons.vibration),
            title: const Text('振动'),
            subtitle: const Text('提醒时振动'),
            trailing: Switch(
              value: true, // TODO: 从设置读取
              onChanged: (value) {
                // TODO: 保存设置
              },
            ),
          ),
          const Divider(),

          // 定位设置
          _buildSectionHeader('定位设置'),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('后台定位'),
            subtitle: const Text('允许后台持续获取位置'),
            trailing: Switch(
              value: true, // TODO: 从设置读取
              onChanged: (value) {
                _requestBackgroundLocation();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.my_location),
            title: const Text('定位精度'),
            subtitle: const Text('高精度模式'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showLocationAccuracyDialog(context);
            },
          ),
          const Divider(),

          // 电池优化
          _buildSectionHeader('电池优化'),
          ListTile(
            leading: const Icon(Icons.battery_full),
            title: const Text('电池优化白名单'),
            subtitle: const Text('避免后台服务被系统关闭'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _requestIgnoreBatteryOptimization(context);
            },
          ),
          const Divider(),

          // 关于
          _buildSectionHeader('关于'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('应用版本'),
            subtitle: const Text('v1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('用户协议'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 显示用户协议
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('隐私政策'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 显示隐私政策
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> _requestBackgroundLocation() async {
    final status = await Permission.locationAlways.status;
    if (!status.isGranted) {
      await Permission.locationAlways.request();
    }
  }

  Future<void> _requestIgnoreBatteryOptimization(BuildContext context) async {
    // TODO: 使用 flutter_battery 包请求忽略电池优化
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('请在系统设置中允许应用自启动和后台运行'),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showLocationAccuracyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('定位精度'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('省电模式'),
              subtitle: const Text('5 分钟定位一次'),
              value: 'power_saving',
              groupValue: 'balanced', // TODO: 从设置读取
              onChanged: (value) {
                Navigator.pop(context);
                // TODO: 保存设置
              },
            ),
            RadioListTile<String>(
              title: const Text('平衡模式'),
              subtitle: const Text('1 分钟定位一次，推荐'),
              value: 'balanced',
              groupValue: 'balanced',
              onChanged: (value) {
                Navigator.pop(context);
                // TODO: 保存设置
              },
            ),
            RadioListTile<String>(
              title: const Text('高精度模式'),
              subtitle: const Text('30 秒定位一次'),
              value: 'high_accuracy',
              groupValue: 'balanced',
              onChanged: (value) {
                Navigator.pop(context);
                // TODO: 保存设置
              },
            ),
          ],
        ),
      ),
    );
  }
}

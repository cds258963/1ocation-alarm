import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/alarm_entity.dart';
import '../providers/alarm_provider.dart';
import '../widgets/radius_selector.dart';
import '../widgets/time_range_picker.dart';

class AlarmSetupScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String? address;

  const AlarmSetupScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  @override
  State<AlarmSetupScreen> createState() => _AlarmSetupScreenState();
}

class _AlarmSetupScreenState extends State<AlarmSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: '新闹钟');

  double _radius = 500;
  bool _triggerOnEnter = true;
  bool _triggerOnExit = false;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  MonitoringMode _monitoringMode = MonitoringMode.balanced;
  bool _vibration = true;
  int _repeatCount = 1;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置闹钟'),
        actions: [
          TextButton(
            onPressed: _saveAlarm,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 位置信息
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          '位置信息',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.address ?? '纬度：${widget.latitude}, 经度：${widget.longitude}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('返回地图重新选择'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 闹钟名称
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '闹钟名称',
                prefixIcon: Icon(Icons.alarm),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入闹钟名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 提醒半径
            const Text('提醒半径', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            RadiusSelector(
              initialRadius: _radius,
              onRadiusChanged: (value) {
                setState(() => _radius = value);
              },
            ),
            const SizedBox(height: 24),

            // 触发条件
            const Text('触发条件', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('进入区域时提醒'),
              subtitle: const Text('当进入设定范围时触发提醒'),
              value: _triggerOnEnter,
              onChanged: (value) {
                setState(() => _triggerOnEnter = value ?? true);
              },
            ),
            CheckboxListTile(
              title: const Text('离开区域时提醒'),
              subtitle: const Text('当离开设定范围时触发提醒'),
              value: _triggerOnExit,
              onChanged: (value) {
                setState(() => _triggerOnExit = value ?? false);
              },
            ),
            const SizedBox(height: 24),

            // 生效时间
            const Text('生效时间（可选）', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TimeRangePicker(
              startTime: _startTime,
              endTime: _endTime,
              onTimeRangeChanged: (start, end) {
                setState(() {
                  _startTime = start;
                  _endTime = end;
                });
              },
            ),
            const SizedBox(height: 24),

            // 监控模式
            const Text('监控模式', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  RadioListTile<MonitoringMode>(
                    title: const Text('省电模式'),
                    subtitle: const Text('5 分钟定位一次，耗电最低'),
                    value: MonitoringMode.powerSaving,
                    groupValue: _monitoringMode,
                    onChanged: (value) {
                      setState(() => _monitoringMode = value!);
                    },
                  ),
                  RadioListTile<MonitoringMode>(
                    title: const Text('平衡模式'),
                    subtitle: const Text('1 分钟定位一次，推荐'),
                    value: MonitoringMode.balanced,
                    groupValue: _monitoringMode,
                    onChanged: (value) {
                      setState(() => _monitoringMode = value!);
                    },
                  ),
                  RadioListTile<MonitoringMode>(
                    title: const Text('高精度模式'),
                    subtitle: const Text('30 秒定位一次，最精确但耗电'),
                    value: MonitoringMode.highAccuracy,
                    groupValue: _monitoringMode,
                    onChanged: (value) {
                      setState(() => _monitoringMode = value!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 提醒设置
            const Text('提醒设置', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('振动'),
              value: _vibration,
              onChanged: (value) {
                setState(() => _vibration = value);
              },
            ),
            ListTile(
              title: const Text('重复提醒次数'),
              trailing: DropdownButton<int>(
                value: _repeatCount,
                items: List.generate(9, (i) => i + 1)
                    .map((i) => DropdownMenuItem(value: i, child: Text('$i 次')))
                    .toList(),
                onChanged: (value) {
                  setState(() => _repeatCount = value!);
                },
              ),
            ),
            const SizedBox(height: 32),

            // 保存提示
            Center(
              child: Text(
                '配置完成后点击右上方保存',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAlarm() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_triggerOnEnter && !_triggerOnExit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少选择一个触发条件')),
      );
      return;
    }

    final provider = context.read<AlarmProvider>();

    final alarm = AlarmEntity(
      id: '', // 将由 UseCase 生成
      name: _nameController.text,
      latitude: widget.latitude,
      longitude: widget.longitude,
      address: widget.address,
      radius: _radius,
      triggerOnEnter: _triggerOnEnter,
      triggerOnExit: _triggerOnExit,
      startTime: _startTime,
      endTime: _endTime,
      monitoringMode: _monitoringMode,
      vibration: _vibration,
      repeatCount: _repeatCount,
      isEnabled: true,
      createdAt: DateTime.now(),
    );

    await provider.addAlarm(alarm);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('闹钟创建成功')),
      );
      Navigator.pop(context);
    }
  }
}

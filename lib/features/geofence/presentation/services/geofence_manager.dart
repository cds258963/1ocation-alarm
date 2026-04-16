import 'package:location/location.dart';
import '../../../alarm/domain/entities/alarm_entity.dart';
import '../../../notification/presentation/services/notification_service.dart';

class GeofenceManager {
  static final GeofenceManager instance = GeofenceManager._();
  GeofenceManager._();

  final Location _location = Location();
  bool _isMonitoring = false;
  final List<AlarmEntity> _activeAlarms = [];

  bool get isMonitoring => _isMonitoring;
  List<AlarmEntity> get activeAlarms => _activeAlarms;

  Future<void> initialize() async {
    // 请求权限
    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }

    if (permission != PermissionStatus.granted) {
      throw Exception('需要定位权限才能使用地理围栏功能');
    }

    // 配置定位
    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 60000, // 1 分钟
    );
  }

  Future<void> startMonitoring(List<AlarmEntity> alarms) async {
    if (_isMonitoring) return;

    _activeAlarms.clear();
    _activeAlarms.addAll(alarms.where((a) => a.isEnabled));

    // 启动位置监听
    _location.onLocationChanged().listen((LocationData location) {
      if (location.latitude == null || location.longitude == null) return;

      _checkGeofences(location.latitude!, location.longitude!);
    });

    _isMonitoring = true;
    print('地理围栏监控已启动，监控 ${_activeAlarms.length} 个闹钟');
  }

  Future<void> stopMonitoring() async {
    if (!_isMonitoring) return;

    await _location.disableService();
    _activeAlarms.clear();
    _isMonitoring = false;
    print('地理围栏监控已停止');
  }

  void _checkGeofences(double latitude, double longitude) {
    for (final alarm in _activeAlarms) {
      final distance = _calculateDistance(
        latitude,
        longitude,
        alarm.latitude,
        alarm.longitude,
      );

      // 如果在范围内
      if (distance <= alarm.radius) {
        if (alarm.triggerOnEnter) {
          _triggerAlarm(alarm, true);
        }
      }
    }
  }

  void _triggerAlarm(AlarmEntity alarm, bool isEnter) {
    NotificationService.instance.showAlarmTriggered(
      title: isEnter ? '到达提醒' : '离开提醒',
      body: '您已${isEnter ? '到达' : '离开'} ${alarm.name}',
      payload: alarm.id,
    );

    print('触发闹钟：${alarm.name} (${isEnter ? '进入' : '离开'})');
  }

  // 计算两点间距离（Haversine 公式）
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // 米

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = (dLat / 2).sin() * (dLat / 2).sin() +
        _toRadians(lat1).cos() *
            _toRadians(lat2).cos() *
            (dLon / 2).sin() *
            (dLon / 2).sin();

    final c = 2 * (a.sqrt().asin());
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  Future<void> updateAlarms(List<AlarmEntity> alarms) async {
    _activeAlarms.clear();
    _activeAlarms.addAll(alarms.where((a) => a.isEnabled));
    print('更新闹钟列表，当前活跃：${_activeAlarms.length}');
  }
}

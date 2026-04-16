import '../../domain/entities/alarm_entity.dart';

class AlarmModel extends AlarmEntity {
  const AlarmModel({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    super.address,
    required super.radius,
    super.triggerOnEnter = true,
    super.triggerOnExit = false,
    super.startTime,
    super.endTime,
    super.weekDays,
    super.notificationSound = 'default',
    super.vibration = true,
    super.repeatCount = 1,
    super.monitoringMode = MonitoringMode.balanced,
    super.isEnabled = true,
    required super.createdAt,
    super.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'radius': radius,
      'trigger_on_enter': triggerOnEnter ? 1 : 0,
      'trigger_on_exit': triggerOnExit ? 1 : 0,
      'start_time': _timeToString(startTime),
      'end_time': _timeToString(endTime),
      'week_days': weekDays?.join(','),
      'notification_sound': notificationSound,
      'vibration': vibration ? 1 : 0,
      'repeat_count': repeatCount,
      'monitoring_mode': monitoringMode.index,
      'is_enabled': isEnabled ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['id'] as String,
      name: map['name'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      address: map['address'] as String?,
      radius: (map['radius'] as num).toDouble(),
      triggerOnEnter: map['trigger_on_enter'] == 1,
      triggerOnExit: map['trigger_on_exit'] == 1,
      startTime: _stringToTime(map['start_time'] as String?),
      endTime: _stringToTime(map['end_time'] as String?),
      weekDays: (map['week_days'] as String?)?.split(',').map(int.parse).toList(),
      notificationSound: map['notification_sound'] as String? ?? 'default',
      vibration: map['vibration'] == 1,
      repeatCount: map['repeat_count'] as int? ?? 1,
      monitoringMode: MonitoringMode.values[map['monitoring_mode'] as int? ?? 1],
      isEnabled: map['is_enabled'] == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : null,
    );
  }

  static String? _timeToString(TimeOfDay? time) {
    if (time == null) return null;
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay? _stringToTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  AlarmEntity toEntity() {
    return AlarmEntity(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      address: address,
      radius: radius,
      triggerOnEnter: triggerOnEnter,
      triggerOnExit: triggerOnExit,
      startTime: startTime,
      endTime: endTime,
      weekDays: weekDays,
      notificationSound: notificationSound,
      vibration: vibration,
      repeatCount: repeatCount,
      monitoringMode: monitoringMode,
      isEnabled: isEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

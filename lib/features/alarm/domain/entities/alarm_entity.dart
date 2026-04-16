import 'package:equatable/equatable.dart';

class AlarmEntity extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final double radius;
  final bool triggerOnEnter;
  final bool triggerOnExit;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final List<int>? weekDays; // 1=周一，7=周日
  final String notificationSound;
  final bool vibration;
  final int repeatCount;
  final MonitoringMode monitoringMode;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AlarmEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.radius,
    this.triggerOnEnter = true,
    this.triggerOnExit = false,
    this.startTime,
    this.endTime,
    this.weekDays,
    this.notificationSound = 'default',
    this.vibration = true,
    this.repeatCount = 1,
    this.monitoringMode = MonitoringMode.balanced,
    this.isEnabled = true,
    required this.createdAt,
    this.updatedAt,
  });

  AlarmEntity copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    double? radius,
    bool? triggerOnEnter,
    bool? triggerOnExit,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    List<int>? weekDays,
    String? notificationSound,
    bool? vibration,
    int? repeatCount,
    MonitoringMode? monitoringMode,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AlarmEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      radius: radius ?? this.radius,
      triggerOnEnter: triggerOnEnter ?? this.triggerOnEnter,
      triggerOnExit: triggerOnExit ?? this.triggerOnExit,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      weekDays: weekDays ?? this.weekDays,
      notificationSound: notificationSound ?? this.notificationSound,
      vibration: vibration ?? this.vibration,
      repeatCount: repeatCount ?? this.repeatCount,
      monitoringMode: monitoringMode ?? this.monitoringMode,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
        address,
        radius,
        triggerOnEnter,
        triggerOnExit,
        startTime,
        endTime,
        weekDays,
        notificationSound,
        vibration,
        repeatCount,
        monitoringMode,
        isEnabled,
        createdAt,
        updatedAt,
      ];
}

enum MonitoringMode {
  powerSaving,
  balanced,
  highAccuracy,
}

extension MonitoringModeExtension on MonitoringMode {
  String get name {
    switch (this) {
      case MonitoringMode.powerSaving:
        return '省电模式';
      case MonitoringMode.balanced:
        return '平衡模式';
      case MonitoringMode.highAccuracy:
        return '高精度模式';
    }
  }

  int get intervalSeconds {
    switch (this) {
      case MonitoringMode.powerSaving:
        return 300;
      case MonitoringMode.balanced:
        return 60;
      case MonitoringMode.highAccuracy:
        return 30;
    }
  }
}

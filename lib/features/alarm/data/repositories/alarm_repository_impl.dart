import '../../domain/entities/alarm_entity.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../datasources/alarm_database.dart';
import '../models/alarm_model.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmDatabase database;

  AlarmRepositoryImpl(this.database);

  @override
  Future<List<AlarmEntity>> getAll() async {
    final models = await database.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AlarmEntity?> getById(String id) async {
    final model = await database.getById(id);
    return model?.toEntity();
  }

  @override
  Future<void> create(AlarmEntity alarm) async {
    final model = AlarmModel(
      id: alarm.id,
      name: alarm.name,
      latitude: alarm.latitude,
      longitude: alarm.longitude,
      address: alarm.address,
      radius: alarm.radius,
      triggerOnEnter: alarm.triggerOnEnter,
      triggerOnExit: alarm.triggerOnExit,
      startTime: alarm.startTime,
      endTime: alarm.endTime,
      weekDays: alarm.weekDays,
      notificationSound: alarm.notificationSound,
      vibration: alarm.vibration,
      repeatCount: alarm.repeatCount,
      monitoringMode: alarm.monitoringMode,
      isEnabled: alarm.isEnabled,
      createdAt: alarm.createdAt,
      updatedAt: alarm.updatedAt,
    );
    await database.insert(model);
  }

  @override
  Future<void> update(AlarmEntity alarm) async {
    final model = AlarmModel(
      id: alarm.id,
      name: alarm.name,
      latitude: alarm.latitude,
      longitude: alarm.longitude,
      address: alarm.address,
      radius: alarm.radius,
      triggerOnEnter: alarm.triggerOnEnter,
      triggerOnExit: alarm.triggerOnExit,
      startTime: alarm.startTime,
      endTime: alarm.endTime,
      weekDays: alarm.weekDays,
      notificationSound: alarm.notificationSound,
      vibration: alarm.vibration,
      repeatCount: alarm.repeatCount,
      monitoringMode: alarm.monitoringMode,
      isEnabled: alarm.isEnabled,
      createdAt: alarm.createdAt,
      updatedAt: DateTime.now(),
    );
    await database.update(model);
  }

  @override
  Future<void> delete(String id) async {
    await database.delete(id);
  }

  @override
  Future<void> toggleEnabled(String id, bool isEnabled) async {
    final alarm = await getById(id);
    if (alarm != null) {
      final updated = alarm.copyWith(isEnabled: isEnabled, updatedAt: DateTime.now());
      await update(updated);
    }
  }
}

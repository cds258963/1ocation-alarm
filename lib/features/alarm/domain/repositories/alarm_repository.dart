import '../entities/alarm_entity.dart';

abstract class AlarmRepository {
  Future<List<AlarmEntity>> getAll();
  Future<AlarmEntity?> getById(String id);
  Future<void> create(AlarmEntity alarm);
  Future<void> update(AlarmEntity alarm);
  Future<void> delete(String id);
  Future<void> toggleEnabled(String id, bool isEnabled);
}

import 'package:uuid/uuid.dart';
import '../entities/alarm_entity.dart';
import '../repositories/alarm_repository.dart';

class CreateAlarmUseCase {
  final AlarmRepository repository;
  final Uuid _uuid = const Uuid();

  CreateAlarmUseCase(this.repository);

  Future<void> call(AlarmEntity alarm) async {
    final newAlarm = alarm.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
    );
    await repository.create(newAlarm);
  }
}

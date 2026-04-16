import '../entities/alarm_entity.dart';
import '../repositories/alarm_repository.dart';

class UpdateAlarmUseCase {
  final AlarmRepository repository;

  UpdateAlarmUseCase(this.repository);

  Future<void> call(AlarmEntity alarm) async {
    final updated = alarm.copyWith(
      updatedAt: DateTime.now(),
    );
    await repository.update(updated);
  }
}

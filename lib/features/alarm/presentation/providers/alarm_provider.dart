import 'package:flutter/material.dart';
import '../../domain/entities/alarm_entity.dart';
import '../../domain/usecases/get_alarms.dart';
import '../../domain/usecases/create_alarm.dart';
import '../../domain/usecases/update_alarm.dart';
import '../../domain/usecases/delete_alarm.dart';

class AlarmProvider extends ChangeNotifier {
  final GetAlarmsUseCase getAlarms;
  final CreateAlarmUseCase createAlarm;
  final UpdateAlarmUseCase updateAlarm;
  final DeleteAlarmUseCase deleteAlarm;

  List<AlarmEntity> _alarms = [];
  bool _isLoading = false;
  String? _error;

  AlarmProvider({
    required this.getAlarms,
    required this.createAlarm,
    required this.updateAlarm,
    required this.deleteAlarm,
  });

  List<AlarmEntity> get alarms => _alarms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAlarms() async {
    _isLoading = true;
    notifyListeners();

    try {
      _alarms = await getAlarms();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAlarm(AlarmEntity alarm) async {
    await createAlarm(alarm);
    await loadAlarms();
  }

  Future<void> editAlarm(AlarmEntity alarm) async {
    await updateAlarm(alarm);
    await loadAlarms();
  }

  Future<void> removeAlarm(String id) async {
    await deleteAlarm(id);
    await loadAlarms();
  }

  Future<void> toggleAlarm(String id, bool isEnabled) async {
    final alarm = _alarms.firstWhere((a) => a.id == id);
    final updated = alarm.copyWith(isEnabled: isEnabled);
    await editAlarm(updated);
  }
}

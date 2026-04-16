import 'package:get_it/get_it.dart';
import '../features/alarm/data/datasources/alarm_database.dart';
import '../features/alarm/data/repositories/alarm_repository_impl.dart';
import '../features/alarm/domain/repositories/alarm_repository.dart';
import '../features/alarm/domain/usecases/get_alarms.dart';
import '../features/alarm/domain/usecases/create_alarm.dart';
import '../features/alarm/domain/usecases/update_alarm.dart';
import '../features/alarm/domain/usecases/delete_alarm.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Database
  sl.registerLazySingleton(() => AlarmDatabase.instance);

  // Repository
  sl.registerLazySingleton<AlarmRepository>(
    () => AlarmRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAlarmsUseCase(sl()));
  sl.registerLazySingleton(() => CreateAlarmUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAlarmUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAlarmUseCase(sl()));
}

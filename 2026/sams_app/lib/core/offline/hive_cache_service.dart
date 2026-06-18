import 'package:hive_flutter/hive_flutter.dart';

class HiveCacheService {
  static const String attendanceBox = 'attendance';
  static const String scheduleBox = 'schedule';
  static const String userBox = 'user_data';
  
  late Box attendanceBoxInstance;
  late Box scheduleBoxInstance;
  late Box userBoxInstance;
  
  Future<void> init() async {
    await Hive.initFlutter();
    attendanceBoxInstance = await Hive.openBox(attendanceBox);
    scheduleBoxInstance = await Hive.openBox(scheduleBox);
    userBoxInstance = await Hive.openBox(userBox);
  }
  
  Future<void> cacheAttendance(String key, Map<String, dynamic> data) async {
    await attendanceBoxInstance.put(key, data);
  }
  
  Map<String, dynamic>? getCachedAttendance(String key) {
    return attendanceBoxInstance.get(key);
  }
  
  Future<void> clearAttendance() async {
    await attendanceBoxInstance.clear();
  }
}

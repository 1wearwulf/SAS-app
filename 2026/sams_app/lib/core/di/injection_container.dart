import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../network/network_info.dart';
import '../offline/hive_cache_service.dart';
import '../security/device_id_service.dart';
import '../security/ssid_service.dart';

final sl = GetIt.instance;

Future<void> initInjectionContainer() async {
  // Register Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectionChecker: InternetConnectionChecker.createInstance(),
    ),
  );
  
  // Register Hive Cache Service
  final hiveService = HiveCacheService();
  await hiveService.init();
  sl.registerLazySingleton(() => hiveService);
  
  // Register Device ID Service
  sl.registerLazySingleton(
    () => DeviceIdService(
      deviceInfo: DeviceInfoPlugin(),
    ),
  );
  
  // Register SSID Service
  sl.registerLazySingleton(() => SsidService());
}

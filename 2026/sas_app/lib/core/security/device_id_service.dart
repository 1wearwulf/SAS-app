import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceIdService {
  final DeviceInfoPlugin deviceInfo;
  
  DeviceIdService({required this.deviceInfo});
  
  Future<String> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown';
      }
      return 'unknown_device';
    } catch (e) {
      return 'error_device_id';
    }
  }
}

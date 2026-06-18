import 'package:network_info_plus/network_info_plus.dart';

class SsidService {
  final NetworkInfo networkInfo = NetworkInfo();
  
  Future<String?> getCurrentSsid() async {
    try {
      final ssid = await networkInfo.getWifiName();
      return ssid?.replaceAll('"', '');
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> isConnectedToWifi() async {
    try {
      final ssid = await getCurrentSsid();
      return ssid != null && ssid.isNotEmpty && ssid != 'unknown';
    } catch (e) {
      return false;
    }
  }
}

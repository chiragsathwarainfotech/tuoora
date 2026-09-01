import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoHelper {
  const DeviceInfoHelper._();

  static Future<Map<String, String>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String device = 'Unknown';
    String os = 'Unknown';

    try {
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        device = webInfo.browserName.name;
        os = 'Web';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        final brand = androidInfo.brand;
        final model = androidInfo.model;
        if (model.toLowerCase().contains(brand.toLowerCase())) {
          device = model;
        } else {
          device = '$brand $model';
        }
        os = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        String name = iosInfo.name;
        if (name == 'iPhone' || name.isEmpty) {
          name = _mapIosMachine(iosInfo.utsname.machine);
        }
        device = name;
        os = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        device = macInfo.computerName;
        os = 'macOS ${macInfo.osRelease}';
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        device = windowsInfo.computerName;
        os = 'Windows';
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        device = linuxInfo.name;
        os = 'Linux';
      }
    } catch (_) {
      // Fallback
    }

    return {
      'device': device,
      'os': os,
    };
  }

  static String _mapIosMachine(String machine) {
    final map = {
      // iPhone 16 series
      'iPhone17,1': 'iPhone 16 Pro',
      'iPhone17,2': 'iPhone 16 Pro Max',
      'iPhone17,3': 'iPhone 16',
      'iPhone17,4': 'iPhone 16 Plus',
      // iPhone 15 series
      'iPhone16,1': 'iPhone 15',
      'iPhone16,2': 'iPhone 15 Pro',
      'iPhone16,3': 'iPhone 15 Pro Max',
      'iPhone16,4': 'iPhone 15 Plus',
      // iPhone 14 series
      'iPhone15,2': 'iPhone 14 Pro',
      'iPhone15,3': 'iPhone 14 Pro Max',
      'iPhone14,7': 'iPhone 14',
      'iPhone14,8': 'iPhone 14 Plus',
      // iPhone 13 series
      'iPhone14,2': 'iPhone 13 Pro',
      'iPhone14,3': 'iPhone 13 Pro Max',
      'iPhone14,4': 'iPhone 13 mini',
      'iPhone14,5': 'iPhone 13',
      // iPhone 12 series
      'iPhone13,1': 'iPhone 12 mini',
      'iPhone13,2': 'iPhone 12',
      'iPhone13,3': 'iPhone 12 Pro',
      'iPhone13,4': 'iPhone 12 Pro Max',
      // iPhone 11 series
      'iPhone12,1': 'iPhone 11',
      'iPhone12,3': 'iPhone 11 Pro',
      'iPhone12,5': 'iPhone 11 Pro Max',
      // iPhone SE
      'iPhone12,8': 'iPhone SE (2nd Gen)',
      'iPhone14,6': 'iPhone SE (3rd Gen)',
      // iPhone XS & XR
      'iPhone11,2': 'iPhone XS',
      'iPhone11,4': 'iPhone XS Max',
      'iPhone11,6': 'iPhone XS Max',
      'iPhone11,8': 'iPhone XR',
      // Older
      'iPhone10,1': 'iPhone 8',
      'iPhone10,4': 'iPhone 8',
      'iPhone10,2': 'iPhone 8 Plus',
      'iPhone10,5': 'iPhone 8 Plus',
      'iPhone10,3': 'iPhone X',
      'iPhone10,6': 'iPhone X',
    };

    if (map.containsKey(machine)) {
      return map[machine]!;
    }

    if (machine.startsWith('iPhone')) {
      final parts = machine.replaceAll('iPhone', '').split(',');
      if (parts.isNotEmpty) {
        final major = int.tryParse(parts[0]);
        if (major != null) {
          final estimatedModel = major - 1;
          if (estimatedModel > 10) {
            return 'iPhone $estimatedModel';
          }
        }
      }
    }

    if (machine == 'i386' || machine == 'x86_64' || machine == 'arm64') {
      return 'iPhone Simulator';
    }

    return machine;
  }
}

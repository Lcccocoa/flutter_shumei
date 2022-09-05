
import 'flutter_shumei_platform_interface.dart';

class FlutterShumei {
  Future<String?> getPlatformVersion() {
    return FlutterShumeiPlatform.instance.getPlatformVersion();
  }
}

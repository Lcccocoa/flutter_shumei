import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_shumei_platform_interface.dart';

/// An implementation of [FlutterShumeiPlatform] that uses method channels.
class MethodChannelFlutterShumei extends FlutterShumeiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_shumei');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

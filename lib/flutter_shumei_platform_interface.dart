import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_shumei_method_channel.dart';

abstract class FlutterShumeiPlatform extends PlatformInterface {
  /// Constructs a FlutterShumeiPlatform.
  FlutterShumeiPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterShumeiPlatform _instance = MethodChannelFlutterShumei();

  /// The default instance of [FlutterShumeiPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterShumei].
  static FlutterShumeiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterShumeiPlatform] when
  /// they register themselves.
  static set instance(FlutterShumeiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

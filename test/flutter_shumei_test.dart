import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shumei/flutter_shumei.dart';
import 'package:flutter_shumei/flutter_shumei_platform_interface.dart';
import 'package:flutter_shumei/flutter_shumei_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterShumeiPlatform
    with MockPlatformInterfaceMixin
    implements FlutterShumeiPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterShumeiPlatform initialPlatform = FlutterShumeiPlatform.instance;

  test('$MethodChannelFlutterShumei is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterShumei>());
  });

  test('getPlatformVersion', () async {
    FlutterShumei flutterShumeiPlugin = FlutterShumei();
    MockFlutterShumeiPlatform fakePlatform = MockFlutterShumeiPlatform();
    FlutterShumeiPlatform.instance = fakePlatform;

    expect(await flutterShumeiPlugin.getPlatformVersion(), '42');
  });
}

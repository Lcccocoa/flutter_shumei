import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const String viewType = 'shumei.view.type';

class ShuMeiWidget extends StatefulWidget {
  final double width;
  final double height;
  final String organization;
  final String appId;
  const ShuMeiWidget(this.width, this.height, this.organization, this.appId,
      {super.key});

  @override
  State<ShuMeiWidget> createState() => _ShuMeiWidgetState();
}

class _ShuMeiWidgetState extends State<ShuMeiWidget> {
  MethodChannel? channel;

  void initChannel(String name) {
    channel = MethodChannel(name);
    channel!.setMethodCallHandler((call) async {
      print(call.toString());
      switch (call.method) {
        case 'onError':
          break;
        case 'onSuccess':
          break;
      }
      return;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var creationParams = {
      'width': widget.width,
      'height': widget.height,
      'organization': widget.organization,
      'appId': widget.appId,
    };

    print(creationParams.toString());
    if (Platform.isAndroid) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          initChannel('$viewType.$id');
        },
      );
    }
    return Container();
  }
}

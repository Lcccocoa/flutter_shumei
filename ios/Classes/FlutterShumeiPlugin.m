#import "FlutterShumeiPlugin.h"
#import "ShuMeiView.h"

@implementation FlutterShumeiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_shumei"
            binaryMessenger:[registrar messenger]];
  FlutterShumeiPlugin* instance = [[FlutterShumeiPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  ShuMeiViewFactory* factory =
        [[ShuMeiViewFactory alloc] initWithMessenger:[registrar messenger]];
  [registrar registerViewFactory:factory withId:@"shumei.view.type"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end

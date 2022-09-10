#import "ShuMeiView.h"
#import "SmCaptchaWebView.h"

@implementation ShuMeiViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    return [[ShuMeiView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end

@interface ShuMeiView ()<SmCaptchaProtocol>
@property(nonatomic, strong) FlutterMethodChannel* channel;
@end

@implementation ShuMeiView {
//    UIView *_view;
    SmCaptchaWKWebView  *_webview;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
        //
        NSString* name = [[NSString alloc] initWithFormat:@"shumei.view.type.%lld", viewId];
        self.channel = [[FlutterMethodChannel alloc] initWithName:name binaryMessenger:messenger codec:[FlutterStandardMethodCodec sharedInstance]];
        
        //
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:args];
        printf(@"args:%@", args);
        NSNumber* width = dict[@"width"];
        NSNumber* height = dict[@"height"];
        NSString* organization = dict[@"organization"];
        NSString* appid = dict[@"appid"];
        
        // 构造数美验证码WEBVIEW对象，目前宽高比为3:2
        _webview = [[SmCaptchaWKWebView alloc] init];
        CGRect captchaRect = CGRectMake(0, 0, width.intValue, height.intValue);
        [_webview setFrame:captchaRect];
        
        // 初始化验证码WebView
        SmCaptchaOption *caOption = [[SmCaptchaOption alloc] init];
        [caOption setOrganization: organization];   // 必填，组织标识
        [caOption setAppId:appid];           // 必填，应用标识
        [caOption setHttps:YES];                                //必填
        [caOption setMode: SM_MODE_SLIDE];
        
        // 选填，支持自定义样式
//        [caOption setCaptchaHtml:@"https://castatic.fengkongcloud.com/pr/v1.0.4/index.html"];
//        [caOption setExtOption:@{
//            @"lang" : @"en", // 验证码英文主题，默认中文
//            @"style": @{
//                @"customFont": @{ // 自定义字体
//                    @"name": @"Walsheim", // 字体名，没有特别的限制
//                    // 这个ttf文件必须由客户配置，必须是绝对地址，以https或是http开头的url，且必须支持跨域(设置CORS)。
//                    @"url": @"http://castatic.fengkongcloud.com/pr/v1.0.4/assets/GT-Walsheim-Pro-Bold.ttf",
//                },
//                // 滑动式（MODE_SLIDE）模式下，自定义样式 withTitle 为 true 时，内容宽高比为 6:5，其它样式 3:2
//                @"withTitle":@(YES),
//                @"fontFamily": @"Arial", // 与customFont只能存在一种，不然会覆盖自定义字体
//                @"fontWeight": @(600), // 字体粗度
//                @"headerTitle": @"Vertification1", // 顶部自定义标题
//                @"hideRefreshOnImage": @(YES), // 是否隐藏图片上的刷新按钮，默认是有的
//                @"slideBar": @{ // 进度条自定义样式
//                    @"color": @"#141C30", // 进度条上默认字体颜色
//                    @"successColor": @"#FFF", // 成功时字体颜色
//                    @"showTipWhenMove":@(YES), // 当拖动的时候后面文案依旧显示
//                    @"process": @{
//                        @"border": @"none", // 进度条边框，目前只是用来设置清除边框
//                        @"background": @"#F3F8CE", // 默认进度条背景色
//                        @"successBackground": @"#25BC73", // 成功时背景色
//                        @"failBackground": @"#F5E0E2", // 失败时背景色
//                    },
//                    @"button": @{
//                        @"boxShadow": @"none", // 按钮阴影设置，一般用来去除默认阴影的作用
//                        @"color": @"#333", // 默认按钮中的icon颜色
//                        @"background": @"#F6FF7E", // 默认按钮背景色
//                        @"successBackground": @"#25BC73", // 成功时按钮背景色
//                        @"failBackground": @"#ED816E", // 失败时按钮背景色
//                    }
//                },
//            },
//        }];
//
//        [caOption setTipMessage:@"xxxxx"];      // 选填，自定义提示文字，仅滑动式支持
//        [caOption setChannel:@"xxxxx"];                   // 选填，渠道标识
        
        // 初始化验证码WebView
        NSInteger code = [_webview createWithOption: caOption delegate: self];
        if (SmCaptchaSuccess != code) {
            NSLog(@"SmCaptchaWKWebView init failed %ld", code);
        }
    }
    return self;
}

- (UIView*)view {
    return _webview;
}

// Make: SmCaptchaProtocol

- (void)onError:(NSInteger)code {
    [self.channel invokeMethod:@"onError" arguments:@(code)];
}

- (void)onReady {
    printf(@"onReady");
}

- (void)onSuccess:(NSString *)rid pass:(BOOL)pass {
    [self.channel invokeMethod:@"onSuccess" arguments:@{
        @"rid": rid, @"pass": @(pass)
    }];
}

@end

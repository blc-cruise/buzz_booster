#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "TouchHandlingFlutterViewController.h"
#import <FLEX/FLEX.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [UNUserNotificationCenter currentNotificationCenter].delegate = self;
  TouchHandlingFlutterViewController* controller = [[TouchHandlingFlutterViewController alloc] init];
  self.window.rootViewController = controller;
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"com.buzzvil.dev/booster"
                                                              binaryMessenger:controller.binaryMessenger];
  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([@"changeEnvironment" isEqualToString:call.method]) {
      NSString *environment = call.arguments[@"environment"];
      [self changeServerEnvironment:environment];
      result(nil);
    } else if ([@"clearCursor" isEqualToString:call.method]) {
      NSString *appKey = call.arguments[@"appKey"];
      [self clearCursor:appKey];
      result(nil);
    } else if ([@"showDebugger" isEqualToString:call.method]) {
      [[FLEXManager sharedManager] showExplorer];
    } else if ([@"getVersionName" isEqualToString:call.method]) {
      NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
      result(version);
    }
  }];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return YES;
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  completionHandler(UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound);
}

- (void)changeServerEnvironment:(NSString *)environment {
  NSUserDefaults *_mutatorUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"buzzvil_api_storage_I'm_Damon"];
  NSNumber *number;
  if ([environment isEqualToString:@"Production"]) {
    number = @0;
  } else if (([environment isEqualToString:@"Staging"])) {
    number = @1;
  } else if (([environment isEqualToString:@"StagingQA"])) {
    number = @2;
  } else if (([environment isEqualToString:@"Dev"])) {
    number = @3;
  } else {
    number = @4;
  }
  [_mutatorUserDefaults setValue:number forKey:@"BUZZBOOSTER_SERVICE_URL"];
}

- (void)clearCursor:(NSString *)appKey {
  NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:appKey];
  [userDefaults setValue:0 forKey:@"message_cursor_id"];
}

@end

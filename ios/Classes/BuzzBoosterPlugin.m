#import "BuzzBoosterPlugin.h"

static NSString *const kEventsChannel = @"buzz_booster/link";

@interface BuzzBoosterPlugin () <FlutterStreamHandler>

@end

@implementation BuzzBoosterPlugin {
  FlutterEventSink _eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"buzz_booster"
            binaryMessenger:[registrar messenger]];
  BuzzBoosterPlugin* instance = [[BuzzBoosterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  FlutterEventChannel *chargingChannel = [FlutterEventChannel eventChannelWithName:kEventsChannel
                                                                   binaryMessenger:[registrar messenger]];
  [chargingChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
    NSString *appKey = call.arguments[@"iosAppKey"];
    if (appKey != nil && ![appKey isKindOfClass:[NSNull class]]) {
      BSTConfig *config = [BSTConfig configWithBlock:^(BSTConfigBuilder * _Nonnull builder) {
        builder.appKey = appKey;
      }];
      [BuzzBooster initializeWithConfig:config];
      BuzzBooster.optInMarketingCampaignDelegate = self;
      [BuzzBooster addUserEventDelegate:self];
      result(nil);
    } else {
      FlutterError *error = [FlutterError errorWithCode:@"400" message:@"iOSAppKey is required" details:nil];
      result(error);
    }
  } else if ([@"isInitialized" isEqualToString:call.method]) {
    return result([NSNumber numberWithBool:[BuzzBooster isInitialized]]);
  } else if ([@"setUser" isEqualToString:call.method]) {
    NSString * _Nullable userId = call.arguments[@"userId"];
    NSNumber * _Nullable optInMarketing = call.arguments[@"optInMarketing"];
    NSDictionary * _Nullable properties = call.arguments[@"properties"];
    if (userId != nil && ![userId isKindOfClass:[NSNull class]]) {
      BSTUser *user = [BSTUser userWithBlock:^(BSTUserBuilder * _Nonnull builder) {
        builder.userId = userId;
        builder.properties = properties;
        if (optInMarketing != nil && ![optInMarketing isKindOfClass:[NSNull class]]) {
          if ([optInMarketing boolValue]) {
            builder.marketingStatus = BSTMarketingStatusOptIn;
          } else {
            builder.marketingStatus = BSTMarketingStatusOptOut;
          }
        } else {
          builder.marketingStatus = BSTMarketingStatusUndetermined;
        }
      }];
      [BuzzBooster setUser:user];
    } else {
      [BuzzBooster setUser:nil];
    }
    result(nil);
  } else if ([@"setPushToken" isEqualToString:call.method]) {
    NSString *pushToken = call.arguments[@"token"];
    [BuzzBooster setPushToken:pushToken];
    result(nil);
  } else if ([@"setTheme" isEqualToString:call.method]) {
    NSString *theme = call.arguments[@"theme"];
    if (theme != nil) {
      if ([theme isEqualToString:@"light"]) {
        [BuzzBooster setUserInterfaceStyle:BSTUserInterfaceStyleLight];
      } else if ([theme isEqualToString:@"dark"]) {
        [BuzzBooster setUserInterfaceStyle:BSTUserInterfaceStyleDark];
      } else if ([theme isEqualToString:@"system"]) {
        [BuzzBooster setUserInterfaceStyle:BSTUserInterfaceStyleSystem];
      }
    }
    result(nil);
  } else if ([@"isBuzzBoosterNotification" isEqualToString:call.method]) {
    NSDictionary * _Nullable map = call.arguments[@"map"];
    if (map[@"BuzzBooster"] != nil) {
      return result([NSNumber numberWithBool:YES]);
    } else {
      return result([NSNumber numberWithBool:NO]);
    }
  } else if ([@"handleInitialMessage" isEqualToString:call.method]){
    NSDictionary *data = call.arguments[@"map"];
    [BuzzBooster application:UIApplication.sharedApplication
didReceiveRemoteNotification:data
      fetchCompletionHandler:^(UIBackgroundFetchResult result) { }
    ];
    result(nil);
  } else if ([@"sendEvent" isEqualToString:call.method]){
    NSString *eventName = call.arguments[@"eventName"];
    NSDictionary * _Nullable eventValues = call.arguments[@"eventValues"];
    if (eventValues != nil && ![eventValues isKindOfClass:[NSNull class]]) {
      [BuzzBooster sendEventWithName:eventName
                              values:eventValues];
    } else {
      [BuzzBooster sendEventWithName:eventName];
    }
    result(nil);
  } else if ([@"showInAppMessage" isEqualToString:call.method]){
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [BuzzBooster showInAppMessageWithViewController:viewController];
    result(nil);
  } else if ([@"showHome" isEqualToString:call.method]){
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [BuzzBooster showHomeWithViewController:viewController];
    result(nil);
  } else if ([@"showNaverPayExchange" isEqualToString:call.method]){
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [BuzzBooster showNaverPayExchangeWithViewController:viewController];
    result(nil);
  } else if ([@"showCampaignWithId" isEqualToString:call.method]){
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    NSString *campaignId = call.arguments[@"campaignId"];
    [BuzzBooster showCampaignWithId:campaignId
                     viewController:viewController];
    result(nil);
  } else if ([@"showCampaignWithType" isEqualToString:call.method]){ 
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    NSString *campaignType = call.arguments[@"campaignType"];
    if (campaignType != nil) {
      if ([campaignType isEqualToString:@"attendance"]) {
        [BuzzBooster showCampaignWithType:BSTCampaignTypeAttendance viewController:viewController];
      } else if ([campaignType isEqualToString:@"referral"]) {
        [BuzzBooster showCampaignWithType:BSTCampaignTypeReferral viewController:viewController];
      } else if ([campaignType isEqualToString:@"optInMarketing"]) {
        [BuzzBooster showCampaignWithType:BSTCampaignTypeOptInMarketing viewController:viewController];
      } else if ([campaignType isEqualToString:@"roulette"]) {
        [BuzzBooster showCampaignWithType:BSTCampaignTypeRoulette viewController:viewController];
      } else if ([campaignType isEqualToString:@"scratchLottery"]) {
        [BuzzBooster showCampaignWithType:BSTCampaignTypeScratchLottery viewController:viewController];
      }
    }
    result(nil);
  } else if ([@"showPage" isEqualToString:call.method]){
    NSString *pageId = call.arguments[@"pageId"];
    [BuzzBooster showPageWithId:pageId];
    result(nil);
  } else if ([@"postJavaScriptMessage" isEqualToString:call.method]) {
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    NSError *error;
    NSString *message = call.arguments[@"message"];
    [BuzzBoosterWebKit handleWith:viewController
                      messageName:@"BuzzBooster"
                      messageBody:message
                            error:&error];
    if (error) {
      NSLog(@"%@", [error localizedDescription]);
    }     
    result(nil);                   
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark --FlutterStreamHandler
- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)eventSink {
  _eventSink = eventSink;
  return nil;
}

- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
  _eventSink = nil;
  return nil;
}

#pragma mark --BSTOptInMarketingCampaignDelegate
- (void)onMoveButtonTappedIn:(UIViewController *)viewController {
  // Dimiss using rootViewController not tapped in viewcontroller
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  [rootViewController dismissViewControllerAnimated:NO completion:nil];
  if (_eventSink) {
    _eventSink(@{
      @"event": @"optInMarketingCampaignMoveButtonClicked",
    });
  }
}

#pragma mark --BSTUserEventDelegate
- (void)userEventDidOccur:(BSTUserEvent * _Nonnull)userEvent {
  if (_eventSink) {
    NSString * _Nonnull userEventName = userEvent.name;
    NSDictionary<NSString *, id> * _Nullable userEventValues = userEvent.values;
    
    // Prevent Crash
    if (userEventValues != nil && ![userEventValues isKindOfClass:[NSNull class]]){
      _eventSink(@{
        @"event": @"userEventDidOccur",
        @"userEventName": userEventName,
        @"userEventValues": userEventValues,
      });
    } else {
      _eventSink(@{
        @"event": @"userEventDidOccur",
        @"userEventName": userEventName
      });
    }
  }
}

@end

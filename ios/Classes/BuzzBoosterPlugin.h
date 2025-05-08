@import Foundation;
#import <Flutter/Flutter.h>
#import <BuzzBoosterSDK/BuzzBoosterSDK.h>

@interface BuzzBoosterPlugin : NSObject<FlutterPlugin, BSTOptInMarketingCampaignDelegate, BSTUserEventDelegate>

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler;

@end

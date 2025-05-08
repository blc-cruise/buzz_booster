#import "TouchHandlingFlutterViewController.h"

@implementation TouchHandlingFlutterViewController
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    if (self.presentedViewController != nil) {
        return;
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    if (self.presentedViewController != nil) {
        return;
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    if (self.presentedViewController != nil) {
        return;
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    if (self.presentedViewController != nil) {
        return;
    }
    [super touchesCancelled:touches withEvent:event];
}

@end

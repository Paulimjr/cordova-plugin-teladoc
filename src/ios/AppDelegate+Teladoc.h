#import "AppDelegate.h"
#import <objc/runtime.h>

@interface AppDelegate (TeladocPlugin)

- (void)teladocPlugin_application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler;

+ (void)swizzleFromMethod:(SEL )originalSelector toMethod:(SEL)swizzledSelector;

@end
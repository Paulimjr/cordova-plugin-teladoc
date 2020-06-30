#import "AppDelegate+Teladoc.h"

@import Teladoc;

@implementation AppDelegate (TeladocPlugin)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleFromMethod:@selector(application:didFinishLaunchingWithOptions:)
                       toMethod:@selector(teladocPlugin_application:didFinishLaunchingWithOptions:)];

    });
}

+ (void)swizzleFromMethod:(SEL )originalSelector toMethod:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (NSString *)getValueFromPList:(NSString *)key {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

- (BOOL)teladocPlugin_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self floowPlugin_application:application didFinishLaunchingWithOptions:launchOptions];//original call
    
    NSString *apiKey = [self getValueFromPList:@"TELADOC_API_KEY"];
    NSString *teladocServer = [self getValueFromPList:@"TELADOC_SERVER"];
    BOOL isProduction = [[self getValueFromPList:@"TELADOC_ISPRODUCTION"] isEqual: @"true"];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"lastDevServer"]) {
        teladocServer = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastDevServer"];
    }

    [Teladoc initWithApiKey:apiKey isProd:isProduction environment:teladocServer];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

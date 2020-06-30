#ifndef PluginCore_h
#define PluginCore_h
#import <Cordova/CDV.h>

@import Teladoc;

@interface PluginCore : CDVPlugin
{
    CDVInvokedUrlCommand *lastCommand;
}
- (void)runAction:(CDVInvokedUrlCommand *)command withArgs:(int)argCount forBlock:(void (^)(CDVInvokedUrlCommand *command))handler;
- (BOOL)validate:(int)argCount arguments:(NSArray *)args;
- (BOOL)checkNonEmpty:(NSObject *)input;
- (void)sendSuccessResult:(NSDictionary *)dictionary callbackId:(NSString *)callbackId;
- (void)sendSuccessResult:(NSDictionary *)dictionary callbackId:(NSString *)callbackId keepCallback:(BOOL)keepCallback;
- (void)sendErrorResult:(NSString *)errorMessage withCode:(long)code callbackId:(NSString *)callbackId;
- (void)sendErrorResult:(NSError *)error callbackId:(NSString *)callbackId;
- (void)sendNoResult:(CDVInvokedUrlCommand *)command;
@end

#endif /* PluginCore_h */
#import "PluginCore.h"
@implementation PluginCore : CDVPlugin
-(void)runAction:(CDVInvokedUrlCommand*)command withArgs:(int)argCount forBlock:(void(^)(CDVInvokedUrlCommand * command))handler{
    @try{
        if (argCount == command.arguments.count) {
            handler(command);
        } else {
            [self sendErrorResult:@"INVALID ARGUMENTS"  withCode:-1 callbackId:command.callbackId];
        }
    }@catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        [self sendErrorResult:exception.reason withCode:-2  callbackId:command.callbackId];
    }
}

-(BOOL)validate:(int)argCount arguments:(NSArray*)args{
    BOOL ret = true;
    if(args.count < argCount) return false;
    for(int i = 0; i< argCount; i++){
        ret = ret && [self checkNonEmpty:[args objectAtIndex:i]];
    }
    return ret;
}

-(BOOL)checkNonEmpty:(NSObject*)input{
    return !!input && [input isKindOfClass:[NSString class]] && [(NSString *)input length] > 0;
}

-(void)sendSuccessResult:(NSDictionary *)dictionary callbackId:(NSString *)callbackId {
    
    NSLog(@"==========================");
    NSLog(@">>> sendSuccessResult1 <<<");
    NSLog(@"==========================");
    NSLog(@"> SuccessResult(dictionary): %@",dictionary);
    
    [self sendSuccessResult:dictionary callbackId:callbackId keepCallback:false];
}

-(void)sendSuccessResult:(NSDictionary *)dictionary callbackId:(NSString *)callbackId keepCallback:(BOOL) keepCallback{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:jsonString];
    
    NSLog(@"==========================");
    NSLog(@">>> sendSuccessResult2 <<<");
    NSLog(@"==========================");
    NSLog(@"> SuccessResult (json): %@",jsonString);
    
    
    pluginResult.keepCallback = [NSNumber numberWithBool:keepCallback];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

-(void)sendErrorResult:(NSString *)errorMessage withCode:(long)code callbackId:(NSString *)callbackId {
    
    NSLog(@"========================");
    NSLog(@">>> sendErrorResult1 <<<");
    NSLog(@"========================");
    NSLog(@"> errorMessage: %@",errorMessage.description);
    NSLog(@"> withCode: %ld",code);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:errorMessage forKey:@"errorMessage"];
    [dictionary setObject:[NSNumber numberWithLong:code] forKey:@"errorCode"];
    NSError * error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                      messageAsString:jsonString];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

-(void)sendErrorResult:(NSError *)error callbackId:(NSString *)callbackId {
    NSLog(@"========================");
    NSLog(@">>> sendErrorResult2 <<<");
    NSLog(@"========================");
    NSLog(@"> Send error: %@",error.description);
    [self sendErrorResult:error.description withCode:-1 callbackId:callbackId];
}

-(void)sendNoResult:(CDVInvokedUrlCommand *)command{
    NSLog(@"====================");
    NSLog(@">>> sendNoResult <<<");
    NSLog(@"====================");
    CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    pr.keepCallback = [NSNumber numberWithBool:true];
    [self.commandDelegate sendPluginResult:pr callbackId:command.callbackId];
}

@end

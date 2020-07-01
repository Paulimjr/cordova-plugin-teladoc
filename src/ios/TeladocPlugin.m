#import "PluginCore.h"
#import "UIColor+Utilities.h"
#import "RSA.h"

@interface TeladocPlugin : PluginCore

@property (nonatomic, readwrite) NSString *loginToken;

@end

@implementation TeladocPlugin : PluginCore

-(void)doTeladocLoginWithToken:(CDVInvokedUrlCommand *)command {
    [self runAction:command withArgs:1 forBlock:^(CDVInvokedUrlCommand * command) {
        self.loginToken = command.arguments[0];
        
        [[Teladoc apiService] loginWithToken:self.loginToken completion:^(BOOL completed, id error) {
            CDVPluginResult *pluginResult = nil;
            if (error) {
                [self sendErrorResult:error callbackId:command.callbackId];
            } else {
                TDRegistrationStatus registrationStatus = [[Teladoc apiService] registrationStatus];
                if (registrationStatus == TDRegistrationStatusNotValid || registrationStatus == TDRegistrationStatusUnknown || registrationStatus == TDRegistrationStatusNotRegistered) {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Unregistered"];
                    [[Teladoc apiService] registrationWithToken:self.loginToken andCompletion:^(BOOL completed, UIViewController *viewController, NSError *error) {
                        if (completed && viewController) {
                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                            [self.viewController presentViewController:viewController animated:YES completion:nil];
                        } else {
                            [self sendErrorResult:error callbackId:command.callbackId];
                        }
                    }];
                } else {
                    if ([[Teladoc apiService] isLoggedIn]) {
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Logged in"];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    } else {
                        [self sendErrorResult:@"Not logged in" withCode:-1 callbackId:command.callbackId];
                    }
                }
            }
        }];
    }];
}

-(void)showDashboard:(CDVInvokedUrlCommand*)command {
    [self runAction:command withArgs:0 forBlock:^(CDVInvokedUrlCommand * command) {
        if (self.loginToken == nil) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please login before using this function"] callbackId:command.callbackId];
        } else {
            [[Teladoc apiService] callRoute:TDRouteDashboard withToken:self.loginToken andCompletion:^(BOOL completed, UIViewController *viewController, NSError *error) {
                if (completed && viewController) {
                    [self.viewController presentViewController:viewController animated:YES completion:^{
                        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"] callbackId:command.callbackId];
                    }];
                } else {
                    [self sendErrorResult:error.localizedDescription withCode:error.code callbackId:command.callbackId];
                }
            }];
        }
    }];
}

-(void)showImageUpload:(CDVInvokedUrlCommand *)command {
    [self runAction:command withArgs:0 forBlock:^(CDVInvokedUrlCommand * command) {
        if (self.loginToken == nil) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please login before using this function"] callbackId:command.callbackId];
        } else {
            [[Teladoc apiService] imageUploadWithCompletion:^(BOOL completed, UIViewController *viewController, NSError *error) {
                if (completed && viewController) {
                    [self.viewController presentViewController:viewController animated:YES completion:^{
                        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"] callbackId:command.callbackId];
                    }];
                } else {
                    [self sendErrorResult:error.localizedDescription withCode:error.code callbackId:command.callbackId];
                }
            }];
        }
    }];
}

-(void)showConsultations:(CDVInvokedUrlCommand *)command {
    [self runAction:command withArgs:0 forBlock:^(CDVInvokedUrlCommand * command) {
        if (self.loginToken == nil) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please login before using this function"] callbackId:command.callbackId];
        } else {
            [[Teladoc apiService] callRoute:TDRouteConsultList withToken:self.loginToken andCompletion:^(BOOL completed, UIViewController *viewController, NSError *error) {
                if (completed && viewController) {
                    [self.viewController presentViewController:viewController animated:YES completion:^{
                        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"] callbackId:command.callbackId];
                    }];
                } else {
                    [self sendErrorResult:error.localizedDescription withCode:error.code callbackId:command.callbackId];
                }
            }];
        }
    }];
}

-(void)requestConsultation:(CDVInvokedUrlCommand *)command {
    [self runAction:command withArgs:0 forBlock:^(CDVInvokedUrlCommand * command) {
        if (self.loginToken == nil) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please login before using this function"] callbackId:command.callbackId];
        } else {
            [[Teladoc apiService] callRoute:TDRouteRequestConsult withToken:self.loginToken andCompletion:^(BOOL completed, UIViewController *viewController, NSError *error) {
                if (completed && viewController) {
                    [self.viewController presentViewController:viewController animated:YES completion:^{
                        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"] callbackId:command.callbackId];
                    }];
                } else {
                    [self sendErrorResult:error.localizedDescription withCode:error.code callbackId:command.callbackId];
                }
            }];
        }
    }];
}

-(void)getTeladocConsultations:(CDVInvokedUrlCommand *)command {
    [self runAction:command withArgs:0 forBlock:^(CDVInvokedUrlCommand *command) {
        if (self.loginToken == nil) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please login before using this function"] callbackId:command.callbackId];
        } else {
            [[Teladoc apiService] getConsultsWithCompletion:^(BOOL completed, NSArray *consults, NSError *error) {
                if (completed) {
                    NSLog(@"%@", consults);
                    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:consults];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                } else {
                    [self sendErrorResult:error.localizedDescription withCode:error.code callbackId:command.callbackId];
                }
            }];
        }
    }];
}

-(void)doTeladocLogout:(CDVInvokedUrlCommand *)command {
    [self runAction:command withArgs:0 forBlock:^(CDVInvokedUrlCommand *command) {
        [[Teladoc apiService] logout];
        if (![[Teladoc apiService] isLoggedIn]) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"NOT LOGGED IN"] callbackId:command.callbackId];
        } else {
            [self sendErrorResult:@"Unable to logout" withCode:-1 callbackId:command.callbackId];
        }
    }];
}

-(void)changeColor:(CDVInvokedUrlCommand *)command {
    [self runAction:command withArgs:1 forBlock:^(CDVInvokedUrlCommand *command) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        
        NSDictionary *colors = command.arguments[0];
        
        if (colors[@"primary"]) {
            if ([UIColor colowWithHexString:colors[@"primary"]] == nil) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid hex value for primary color"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                [Teladoc apiService].primaryColor = [UIColor colorWithHexString:colors[@"primary"]];
            }
        }
        
        if (colors[@"secondary"]) {
            if ([UIColor colorWithHexString:colors[@"secondary"]] == nil) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid hex value for secondary color"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                [Teladoc apiService].secondaryColor = [UIColor colorWithHexString:colors[@"secondary"]];
            }
        }
        
        if (colors[@"tertiary"]) {
            if ([UIColor colorWithHexString:colors[@"tertiary"]] == nil) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid hex value for tertiary color"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                [Teladoc apiService].tertiaryColor = [UIColor colorWithHexString:colors[@"tertiary"]];
            }
        }
        
        if (colors[@"statusBar"]) {
            if ([UIColor colorWithHexString:colors[@"statusBar"]] == nil) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid hex value for status bar color"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                [Teladoc apiService].statusBarColor = [UIColor colorWithHexString:colors[@"statusBar"]];
            }
        }
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:colors];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end;

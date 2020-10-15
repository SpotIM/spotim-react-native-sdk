//
//  LoginEvents.h
//  Spotim
//
//  Created by SpotIM on 11/05/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpotIMEvents.h"

@implementation SpotIMEvents

RCT_EXPORT_MODULE();

+ (id)allocWithZone:(NSZone *)zone {
    static SpotIMEvents *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"startLoginFlow", @"viewHeightDidChange", @"startSSOSuccess", @"startSSOFailed", @"completeSSOSuccess", @"completeSSOFailed", @"ssoSuccess", @"ssoFailed", @"getUserLoginStatusSuccess", @"getUserLoginStatusFailed", @"logoutSuccess", @"logoutFailed"];
}

- (void)sendLoginEvent
{
   [self sendEventWithName:@"startLoginFlow" body:@""];
}

- (void)sendViewHeightDidChangeEvent:(NSString*)newHeight {
    [self sendEventWithName:@"viewHeightDidChange" body:@{@"newHeight": newHeight}];
}

- (void)sendRequsetSuccessEvent:(NSString*)eventName response:(NSDictionary *)response
{
    [self sendEventWithName:eventName body:response];
}

- (void)sendRequsetFailedEvent:(NSString*)eventName error:(NSError *)error
{
    [self sendEventWithName:eventName body:@{@"error": error}];
}
@end

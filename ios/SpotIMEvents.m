//
//  LoginEvents.h
//  Spotim
//
//  Created by SpotIM on 11/05/2020.
//  Copyright © 2019 Spot.IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpotIMEvents.h"

@implementation SpotIMEvents

RCT_EXPORT_MODULE();

NSString *const EVENT_NAME_KEY = @"eventName";
NSString *const EVENT_BODY_KEY = @"eventBody";
NSString *const OPENWEB_EVENT_EMITTER_NOTIFICATIN = @"openwebEventEmitted";


- (void)startObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emitEventInternal:)
                                                 name:OPENWEB_EVENT_EMITTER_NOTIFICATIN
                                               object:nil];
}

- (void)stopObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)emitEventInternal:(NSNotification *)notification
{
    NSDictionary *event = notification.userInfo;
    NSString *name = event[EVENT_NAME_KEY];
    NSDictionary *body = event[EVENT_BODY_KEY];
    [self sendEventWithName:name
                       body:body];
}

+ (void)emitEventWithName:(NSString *)name andPayload:(NSDictionary *)payload
{
    NSDictionary *event = @{EVENT_NAME_KEY:name, EVENT_BODY_KEY: payload};
    [[NSNotificationCenter defaultCenter] postNotificationName:OPENWEB_EVENT_EMITTER_NOTIFICATIN
                                                        object:self
                                                      userInfo:event];
}

+ (void)emitErrorEventWithName:(NSString *)name andError:(NSError *)error
{
    NSDictionary *event = @{EVENT_NAME_KEY:name, EVENT_BODY_KEY: @{@"error": error.localizedDescription}};
    [[NSNotificationCenter defaultCenter] postNotificationName:OPENWEB_EVENT_EMITTER_NOTIFICATIN
                                                        object:self
                                                      userInfo:event];
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"startLoginFlow", @"viewHeightDidChange", @"startSSOSuccess", @"startSSOFailed", @"completeSSOSuccess", @"completeSSOFailed", @"ssoSuccess", @"ssoFailed", @"getUserLoginStatusSuccess", @"getUserLoginStatusFailed", @"logoutSuccess", @"logoutFailed", @"trackAnalyticsEvent"];
}


@end

//
//  LoginEvents.m
//  Spotim
//
//  Created by SpotIM on 11/05/2020.
//  Copyright © 2019 Spot.IM. All rights reserved.
//

#import "RCTEventEmitter.h"
#import "RCTBridgeModule.h"

@interface SpotIMEvents : RCTEventEmitter <RCTBridgeModule>

+ (void)emitEventWithName:(NSString *)name andPayload:(NSDictionary *)payload;
+ (void)emitErrorEventWithName:(NSString *)name andError:(NSError *)error;

@end

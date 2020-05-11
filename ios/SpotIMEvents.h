//
//  LoginEvents.m
//  Spotim
//
//  Created by SpotIM on 11/05/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "RCTEventEmitter.h"
#import "RCTBridgeModule.h"

@interface SpotIMEvents : RCTEventEmitter <RCTBridgeModule>

- (void)sendLoginEvent;
- (void)sendViewHeightDidChangeEvent:(NSString*)newHeight;

@end

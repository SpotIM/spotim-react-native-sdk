//
//  SpotIMView.m
//  Spotim
//
//  Created by SpotIM on 08/05/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "SpotIMView.h"
#import <react_native_spotim/react_native_spotim-Swift.h>

@implementation SpotIMView

SpotImBridge *spotIm;
UIViewController *preConversationVC;
UIViewController *appRootViewController;
BOOL defaultNavBarVisibilityHidden;

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)initWithSpotId:(NSString *)spotId
{
    spotIm = [SpotImBridge new];
    [spotIm initialize:spotId];
}

- (void)setSpotId:(NSString *)spotId
{
    _spotId = spotId;
    
    if (self->_darkModeBackgroundColor) {
        [self setDarkModeBackgroundColor];
    }
    
    [self initPreConversationControlle];
}

- (void)initPreConversationControlle
{
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *rootViewController = navController.visibleViewController;
    
    appRootViewController = rootViewController;
    defaultNavBarVisibilityHidden = navController.navigationBar.isHidden;
    
    [spotIm createSpotImFlowCoordinator:self completion:^() {
        
        [spotIm getPreConversationController:navController postId:self->_postId url:self->_url title:self->_title subtitle:self->_subtitle thumbnailUrl:self->_thumbnailUrl completion:^(UIViewController *vc) {
            
            [rootViewController addChildViewController:vc];
            [self addSubview:vc.view];
            vc.view.frame = self.bounds;
            [vc didMoveToParentViewController:rootViewController];
            preConversationVC = vc;
            
        } onError:^(NSError * error) {
            
        }];
    } onError:^(NSError *error) {
    }];
}

- (void)setDarkModeBackgroundColor
{
    NSString *hex = self->_darkModeBackgroundColor;
    
    NSUInteger red, green, blue;
    sscanf([hex UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    
    [spotIm setBackgroundColor:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

- (void)startSSO:(SSOCompletionBlock)completion
                  onError:(SSOErrorBlock)error {
    [spotIm startSSO:^(NSString *response) {
        completion(response);
    } onError:^(NSError *err) {
        error(err);
    }];
}

- (void)completeSSO:(NSString *)with
       onCompletion:(SSOCompletionBlock)completion
            onError:(SSOErrorBlock)error {
    [spotIm completeSSO:with completion:^(NSString * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)ssoWithJwtSecret:(NSString *)token
            onCompletion:(SSOCompletionBlock)completion
                 onError:(SSOErrorBlock)error {
    [spotIm sso:token completion:^(NSString * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)getUserLoginStatus:(SSOCompletionBlock)completion
                   onError:(SSOErrorBlock)error {
    [spotIm getUserLoginStatus:^(NSString * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)logout:(SSOCompletionBlock)completion
       onError:(SSOErrorBlock)error {
    [spotIm logout:^(NSString * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)didMoveToWindow {
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *rootViewController = navController.visibleViewController;
    
    if (defaultNavBarVisibilityHidden && appRootViewController == rootViewController) {
        [navController setNavigationBarHidden:YES];
    }
}

@end

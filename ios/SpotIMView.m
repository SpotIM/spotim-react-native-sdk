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
    
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *rootViewController = navController.visibleViewController;
    
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

@end

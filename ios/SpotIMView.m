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

UIViewController *rootViewControllerForPreConversation;
UINavigationController *rootNavigationControllerForPreConversation;

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
    } else {
        [spotIm overrideUserInterfaceStyleWithStyle:SpotImUserInterfaceStyleLight];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self initPreConversationController];
    });

}

- (void)initPreConversationController
{
    // Original code
//    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *rootViewController = navController.topViewController;
//    appRootViewController = rootViewController;
//    defaultNavBarVisibilityHidden = navController.navigationBar.isHidden;
    // done

    UIViewController *rootViewController = [self parentViewController];
    UINavigationController *navController = rootViewController.navigationController;
    appRootViewController = rootViewController;

    rootViewControllerForPreConversation = rootViewController;
    rootNavigationControllerForPreConversation = navController;

    defaultNavBarVisibilityHidden = rootViewController.navigationController.navigationBar.isHidden;

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

- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return (UIViewController *)responder;
}

- (void)setDarkModeBackgroundColor
{
    NSString *hex = self->_darkModeBackgroundColor;

    NSUInteger red, green, blue;
    sscanf([hex UTF8String], "#%02X%02X%02X", &red, &green, &blue);

    [spotIm setBackgroundColor:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

- (void)startSSO:(RequestCompletion)completion
                  onError:(SSOErrorBlock)error {
    [spotIm startSSO:^(NSDictionary *response) {
        completion(response);
    } onError:^(NSError *err) {
        error(err);
    }];
}

- (void)completeSSO:(NSString *)with
       onCompletion:(RequestCompletion)completion
            onError:(SSOErrorBlock)error {
    [spotIm completeSSO:with completion:^(NSDictionary * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)ssoWithJwtSecret:(NSString *)token
            onCompletion:(RequestCompletion)completion
                 onError:(SSOErrorBlock)error {
    [spotIm sso:token completion:^(NSDictionary * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)getUserLoginStatus:(RequestCompletion)completion
                   onError:(SSOErrorBlock)error {
    [spotIm getUserLoginStatus:^(NSDictionary * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)logout:(RequestCompletion)completion
       onError:(SSOErrorBlock)error {
    [spotIm logout:^(NSDictionary * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)didMoveToWindow {
//    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *rootViewController = navController.topViewController;

    UIViewController *currentTopViewController = rootNavigationControllerForPreConversation.topViewController;

    if (defaultNavBarVisibilityHidden && appRootViewController == currentTopViewController) {
        [rootNavigationControllerForPreConversation setNavigationBarHidden:YES];
    }
}

@end

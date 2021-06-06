//
//  SpotIMView.m
//  Spotim
//
//  Created by SpotIM on 08/05/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "SpotIMView.h"
#import <react_native_spotim/react_native_spotim-Swift.h>

@interface SpotIMView()

@property (nonatomic, strong) SpotImBridge *spotIm;
@property (nonatomic, weak) UIViewController *preConversationVC;
@property (nonatomic, weak) UIViewController *appRootViewController;
@property (nonatomic, assign) BOOL defaultNavBarVisibilityHidden;

@end


@implementation SpotIMView


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
    self.spotIm = [SpotImBridge new];
    [self.spotIm initialize:spotId];
}

- (void)setSpotId:(NSString *)spotId
{
    _spotId = spotId;

    if (self.darkModeBackgroundColor) {
        [self setDarkModeBackgroundColor];
    } else {
        [self.spotIm overrideUserInterfaceStyleWithStyle:SpotImUserInterfaceStyleLight];
    }

    [self initPreConversationControlle];
}

- (void) setNotifyOnCommentCreate:(BOOL)notifyOnCommentCreate {
    self.notifyOnCommentCreate = notifyOnCommentCreate;
    [self.spotIm notifyOnCommentCreate:notifyOnCommentCreate];
}

- (void)initPreConversationControlle
{
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *rootViewController = navController.topViewController;

    self.appRootViewController = rootViewController;
    self.defaultNavBarVisibilityHidden = navController.navigationBar.isHidden;

    [self.spotIm createSpotImFlowCoordinator:self completion:^() {

        [self.spotIm getPreConversationController:navController postId:self.postId url:self.url title:self.title subtitle:self.subtitle thumbnailUrl:self.thumbnailUrl completion:^(UIViewController *vc) {

            [rootViewController addChildViewController:vc];
            [self addSubview:vc.view];
            vc.view.frame = self.bounds;
            [vc didMoveToParentViewController:rootViewController];
            self.preConversationVC = vc;

        } onError:^(NSError * error) {

        }];
    } onError:^(NSError *error) {
    }];
}

- (void)setDarkModeBackgroundColor
{
    NSString *hex = self.darkModeBackgroundColor;

    NSUInteger red, green, blue;
    sscanf([hex UTF8String], "#%02X%02X%02X", &red, &green, &blue);

    [self.spotIm setBackgroundColor:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

- (void)startSSO:(RequestCompletion)completion
                  onError:(SSOErrorBlock)error {
    [self.spotIm startSSO:^(NSDictionary *response) {
        completion(response);
    } onError:^(NSError *err) {
        error(err);
    }];
}

- (void)completeSSO:(NSString *)with
       onCompletion:(RequestCompletion)completion
            onError:(SSOErrorBlock)error {
    [self.spotIm completeSSO:with completion:^(NSDictionary * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)ssoWithJwtSecret:(NSString *)token
            onCompletion:(RequestCompletion)completion
                 onError:(SSOErrorBlock)error {
    [self.spotIm sso:token completion:^(NSDictionary * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)getUserLoginStatus:(RequestCompletion)completion
                   onError:(SSOErrorBlock)error {
    [self.spotIm getUserLoginStatus:^(NSDictionary * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)logout:(RequestCompletion)completion
       onError:(SSOErrorBlock)error {
    [self.spotIm logout:^(NSDictionary * _Nonnull response) {
        completion(response);
    } onError:^(NSError * _Nonnull err) {
        error(err);
    }];
}

- (void)didMoveToWindow {
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *rootViewController = navController.topViewController;

    if (self.defaultNavBarVisibilityHidden && self.appRootViewController == rootViewController) {
        [navController setNavigationBarHidden:YES];
    }
}

@end

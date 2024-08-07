//
//  SpotIMView.m
//  Spotim
//
//  Created by SpotIM on 08/05/2020.
//  Copyright © 2019 Spot.IM. All rights reserved.
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

- (void)setPostId:(NSString *)postId
{
    _postId = postId;

    if (self.darkModeBackgroundColor) {
        [self setDarkModeBackgroundColor];
    }

    [self initPreConversationController];
}

- (void) setShowLoginScreenOnRootScreen:(BOOL)showLoginScreenOnRootScreen {
    _showLoginScreenOnRootScreen = showLoginScreenOnRootScreen;
    [self.spotIm showLoginScreenOnRootScreen:showLoginScreenOnRootScreen];
}

- (UIViewController *)parentViewController {
    UIResponder *responder = [self nextResponder];
    while (responder != nil) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (void)openFullConversationWithPostId:(NSString *)postId url:(NSString *)url title:(NSString *)title subtitle:(NSString *)subtitle thumbnailUrl:(NSString *)thumbnailUrl onCompletion:(RequestCompletion)completion onError:(ErrorCompletion)error; {

    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *rootViewController = navController.topViewController;

    self.appRootViewController = rootViewController;

    [self.spotIm createSpotImFlowCoordinator:self completion:^() {
        [self.spotIm openFullConversationViewController:self.appRootViewController postId:postId url:url title:title subtitle:subtitle thumbnailUrl:thumbnailUrl completion:^(NSDictionary * _Nonnull response) {
          completion(response);
        } onError:^(NSError * _Nonnull err) {
          error(err);
        }];
    } onError:^(NSError *err) {
      error(err);
    }];
}

- (void)initPreConversationController
{
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *rootViewController = navController.topViewController;

    self.appRootViewController = rootViewController;
    self.defaultNavBarVisibilityHidden = navController.navigationBar.isHidden;

    [self.spotIm createSpotImFlowCoordinator:self completion:^() {

        [self.spotIm getPreConversationController:navController postId:self.postId url:self.url title:self.title subtitle:self.subtitle thumbnailUrl:self.thumbnailUrl completion:^(UIViewController *vc) {

            // remove existing views when re-rendering view
            if (self.preConversationVC) {
                [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.preConversationVC removeFromParentViewController];
            }

            UIViewController *parentViewController = [self parentViewController];

            [parentViewController addChildViewController:vc];
            [self addSubview:vc.view];
            vc.view.frame = self.bounds;
            [vc didMoveToParentViewController:parentViewController];
            self.preConversationVC = vc;

        } onError:^(NSError * error) {

        }];
    } onError:^(NSError *error) {
    }];
}

- (void)setDarkModeBackgroundColor
{
    NSString *hex = self.darkModeBackgroundColor;

    [self.spotIm setBackgroundColorWithHex:hex];
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

- (void)showFullConversation {
    SEL selector = NSSelectorFromString(@"reactNativeShowMoreComments");
    [self.preConversationVC performSelector:selector];
}

- (void)setIsDarkMode:(BOOL)isOn {
    if (isOn) {
        [self.spotIm overrideUserInterfaceStyleWithStyle:SpotImUserInterfaceStyleDark];
    } else {
        [self.spotIm overrideUserInterfaceStyleWithStyle:SpotImUserInterfaceStyleLight];
    }
}

- (void)didMoveToWindow {
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *rootViewController = navController.topViewController;

    if (self.defaultNavBarVisibilityHidden && self.appRootViewController == rootViewController) {
        [navController setNavigationBarHidden:YES];
    }
}

@end

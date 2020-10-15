#import "Spotim.h"
#import <React/RCTUtils.h>
#import "SpotIMView.h"
#import "SpotIMEvents.h"

@class SpotImBridge;
@class SpotImSDKFlowCoordinator;

@implementation SpotIMManager {}

SpotIMView *spotIMView;
SpotImBridge *spotImBridge;
SpotIMEvents *spotIMEvents;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_VIEW_PROPERTY(spotId, NSString)
RCT_EXPORT_VIEW_PROPERTY(postId, NSString)
RCT_EXPORT_VIEW_PROPERTY(url, NSString)
RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(subtitle, NSString)
RCT_EXPORT_VIEW_PROPERTY(thumbnailUrl, NSString)
RCT_EXPORT_VIEW_PROPERTY(darkModeBackgroundColor, NSString)

RCT_EXPORT_MODULE(SpotIM)

- (UIView *)view
{
    return spotIMView;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startLoginFlow
{
    [spotIMEvents sendLoginEvent];
}

- (void)viewHeightDidChange:(NSNotification *)notification
{
    [spotIMEvents sendViewHeightDidChangeEvent:notification.object];
}

RCT_EXPORT_METHOD(initWithSpotId:(NSString *)spotId) {
    dispatch_async(dispatch_get_main_queue(), ^{
        spotIMEvents = [SpotIMEvents allocWithZone:nil];
        spotIMView = [[SpotIMView alloc] init];
        [spotIMView initWithSpotId:spotId];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLoginFlow) name:@"StartLoginFlow" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewHeightDidChange:) name:@"ViewHeightDidChange" object:nil];
    });
}

RCT_EXPORT_METHOD(startSSO) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [spotIMView startSSO:^(NSDictionary *response) {
            [spotIMEvents sendRequsetSuccessEvent:@"startSSOSuccess" response:response];
        } onError:^(NSError *error) {
            [spotIMEvents sendRequsetFailedEvent:@"startSSOFailed" error:error];
            RCTLogInfo(@"RNSpotim: start SSO error: %@ (%ld)", error.localizedDescription, (long)error.code);
        }];
    });
}

RCT_EXPORT_METHOD(completeSSO:(NSString *)codeB) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [spotIMView completeSSO:codeB onCompletion:^(NSDictionary *response) {
            [spotIMEvents sendRequsetSuccessEvent:@"completeSSOSuccess" response:response];
        } onError:^(NSError *error) {
            [spotIMEvents sendRequsetFailedEvent:@"completeSSOFailed" error:error];
            RCTLogInfo(@"RNSpotim: complete SSO error: %@ (%ld)", error.localizedDescription, (long)error.code);
        }];
    });
}

RCT_EXPORT_METHOD(ssoWithJwtSecret:(NSString *)token) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [spotIMView ssoWithJwtSecret:token onCompletion:^(NSDictionary *response) {
            [spotIMEvents sendRequsetSuccessEvent:@"ssoSuccess" response:response];
        } onError:^(NSError *error) {
            [spotIMEvents sendRequsetFailedEvent:@"ssoFailed" error:error];
            RCTLogInfo(@"RNSpotim: sso with JWT token error: %@ (%ld)", error.localizedDescription, (long)error.code);
        }];
    });
}

RCT_EXPORT_METHOD(getUserLoginStatus) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [spotIMView getUserLoginStatus:^(NSDictionary *response) {
            [spotIMEvents sendRequsetSuccessEvent:@"getUserLoginStatusSuccess" response:response];
        } onError:^(NSError *error) {
            [spotIMEvents sendRequsetFailedEvent:@"getUserLoginStatusFailed" error:error];
            RCTLogInfo(@"RNSpotim: getUserLoginStatus error: %@ (%ld)", error.localizedDescription, (long)error.code);
        }];
    });
}

RCT_EXPORT_METHOD(logout) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [spotIMView logout:^(NSDictionary *response) {
            [spotIMEvents sendRequsetSuccessEvent:@"logoutSuccess" response:response];
        } onError:^(NSError *error) {
            [spotIMEvents sendRequsetFailedEvent:@"logoutFailed" error:error];
            RCTLogInfo(@"RNSpotim: logout error: %@ (%ld)", error.localizedDescription, (long)error.code);
        }];
    });
}

@end

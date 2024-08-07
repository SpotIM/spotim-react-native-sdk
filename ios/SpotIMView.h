//
//  SpotIMView.h
//  Spotim
//
//  Created by SpotIM on 08/05/2020.
//  Copyright © 2019 Spot.IM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotIMView : UIView

typedef void (^SSOErrorBlock)(NSError *error);
typedef void (^ErrorCompletion)(NSError *error);
typedef void (^RequestCompletion)(NSDictionary *response);

@property (nonatomic, copy) NSString *spotId;
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *darkModeBackgroundColor;
@property (nonatomic, assign) BOOL showLoginScreenOnRootScreen;

- (void)initWithSpotId:(NSString *)spotId;
- (void)startSSO:(RequestCompletion)completion onError:(SSOErrorBlock)error;
- (void)completeSSO:(NSString *)with onCompletion:(RequestCompletion)completion onError:(SSOErrorBlock)error;
- (void)ssoWithJwtSecret:(NSString *)token onCompletion:(RequestCompletion)completion onError:(SSOErrorBlock)error;
- (void)getUserLoginStatus:(RequestCompletion)completion onError:(SSOErrorBlock)error;
- (void)logout:(RequestCompletion)completion onError:(SSOErrorBlock)error;
- (void)showFullConversation;
- (void)setIsDarkMode:(BOOL)isOn;
- (void)openFullConversationWithPostId:(NSString *)postId url:(NSString *)url title:(NSString *)title subtitle:(NSString *)subtitle thumbnailUrl:(NSString *)thumbnailUrl onCompletion:(RequestCompletion)completion onError:(ErrorCompletion)error;
@end

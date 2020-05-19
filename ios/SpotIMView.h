//
//  SpotIMView.h
//  Spotim
//
//  Created by SpotIM on 08/05/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotIMView : UIView

typedef void (^SSOCompletionBlock)(NSString *response);
typedef void (^SSOErrorBlock)(NSError *error);

@property (nonatomic, copy) NSString *spotId;
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *darkModeBackgroundColor;

- (void)initWithSpotId:(NSString *)spotId;
- (void)startSSO:(SSOCompletionBlock)completion onError:(SSOErrorBlock)error;
- (void)completeSSO:(NSString *)with onCompletion:(SSOCompletionBlock)completion onError:(SSOErrorBlock)error;
- (void)ssoWithJwtSecret:(NSString *)token onCompletion:(SSOCompletionBlock)completion onError:(SSOErrorBlock)error;
- (void)getUserLoginStatus:(SSOCompletionBlock)completion onError:(SSOErrorBlock)error;
- (void)logout:(SSOCompletionBlock)completion onError:(SSOErrorBlock)error;

@end

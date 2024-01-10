#import "AppDelegate.h"
//#import "example-Swift.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTBridge.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

//  [GoogleAdsProvider setSpotImSDKWithProvider];

  self.moduleName = @"example";

  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};

  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                     moduleName:@"example"
                                              initialProperties:nil];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *rootViewController = [UIViewController new];
    self.navControll = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self.navControll setNavigationBarHidden:YES]; // Hide nav bar if you don't use native navigation controller
    rootViewController.view = rootView;
    self.window.rootViewController = self.navControll;
    [self.window makeKeyAndVisible];

    return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self getBundleURL];
}

- (NSURL *)getBundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end

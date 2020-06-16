# Spot.IM React-Native Module 🚀

This library provides an easy integration with Spot.IM into a React-Native app.

## Requirements

* iOS 10.3 or later.
* Android SDK verison (API 18) and above.
* Have a [Spot.IM](https://spot.im) account

## Getting started

### Install react-native-spotim package

#### [@spot.im/react-native-spotim](https://www.npmjs.com/package/@spot.im/react-native-spotim)
1. Install and add the package to your project:
    `npm install @spot.im/react-native-spotim --save`
2. Import Spot.IM modules:
    `import { SpotIM, SpotIMEventEmitter, SpotIMAPI } from 'react-native-spotim';`
    
### Use Spot.IM native view
### iOS
1. Go to the project ios folder and make sure `use_frameworks!` is set in the Podfile
2. If you're using RN version > 0.62, you will need to disable `flipper` by doing the follownig:
  * Comment the following lines from the Podfile:
  ```ruby
  ...
  #add_flipper_pods!
  #  post_install do |installer|
  #  flipper_post_install(installer)
  #end
  ...
  ```
  * Disable flipper init by removing the following lines from AppDelegate.m:
  ```obj-c
  ...
  #if DEBUG
    #import <FlipperKit/FlipperClient.h>
    #import <FlipperKitLayoutPlugin/FlipperKitLayoutPlugin.h>
    #import <FlipperKitUserDefaultsPlugin/FKUserDefaultsPlugin.h>
    #import <FlipperKitNetworkPlugin/FlipperKitNetworkPlugin.h>
    #import <SKIOSNetworkPlugin/SKIOSNetworkAdapter.h>
    #import <FlipperKitReactPlugin/FlipperKitReactPlugin.h>

    static void InitializeFlipper(UIApplication *application) {
      FlipperClient *client = [FlipperClient sharedClient];
      SKDescriptorMapper *layoutDescriptorMapper = [[SKDescriptorMapper alloc] initWithDefaults];
      [client addPlugin:[[FlipperKitLayoutPlugin alloc] initWithRootNode:application withDescriptorMapper:layoutDescriptorMapper]];
      [client addPlugin:[[FKUserDefaultsPlugin alloc] initWithSuiteName:nil]];
      [client addPlugin:[FlipperKitReactPlugin new]];
      [client addPlugin:[[FlipperKitNetworkPlugin alloc] initWithNetworkAdapter:[SKIOSNetworkAdapter new]]];
      [client start];
    }
  #endif
  ...
  #if DEBUG
    InitializeFlipper(application);
  #endif
  ...
  ```
3. The default React-Native root view controller is an instance of UIViewController.
Spot.IM is using UINavigationController no navigate to native view controllers.
To support native navigation wrap the app with a navigation controller in your `AppDelegate.m`:
```obj-c
...
UIViewController *rootViewController = [UIViewController new];
self.navControll = [[UINavigationController alloc] initWithRootViewController:rootViewController];
[self.navControll setNavigationBarHidden:YES]; // Hide nav bar if you don't use native navigation controller
rootViewController.view = rootView;
self.window.rootViewController = self.navControll;
...
```

### Load PreConversation View in React-Native

```javascript
<SpotIM
    spotId="<SPOT.IM_ID>"
    postId="<POST_ID>"
    url="<POST_URL>"
    title="<POST_TITLE>"
    subtitle="<POST_SUBTITLE>"
    thumbnailUrl="<POST_THUMBNAIL>"
    darkModeBackgroundColor="#<HEX_COLOR>"
    style={{flex: 1}}
/>
```

#### Listen to PreConversation View size changes
We make sure the container view is resized when the PreConversation View is filled with comments.
You can also subscribe to `SpotIMEventEmitter` with `startLoginFlow` event to get PreConversation View height changes:
```javascript
SpotIMEventEmitter.addListener('viewHeightDidChange', (event) => {
    this.setState({height: event['newHeight']});
})
```

### Flows

Our SDK exposes one major flow to set up. The pre-conversation view is a view that displays a preview of 2-16 comments from the conversation, a text box to create new comments and a button to see all comments.

The Pre-conversation view should be displayed in your article view below the article.

When the user wants to see more comments we push a new ViewController/Activity which displays all comments from the conversation.

When clicking on the text box to create a new comments we bring the user to the creation screen. The users needs to be logged in inorder to post new comments, this is where the hosting app needs to integrate it's authentication system.

#### Authentication
To utilize SSO authentication, you can use your login UI by subscribing to `startLoginFlow` event:
```javascript
const onStartLoginFlow = (event) => {
    ...
}
const subscription = SpotIMEventEmitter.addListener('startLoginFlow', onStartLoginFlow);
```

##### Authentication with SSO:

There are to types of SSO available: **Generic SSO** and **SSO with JWT secret**. Please contact your Spot.IM advisor to pick the best option for you.

##### Generic SSO

1. Authenticate a user with your backend - see Authentication above
2. Call `startSSO` function and get `codeA`
3. Send the `codeA` and all needed information to your backend system in order to get `codeB`
4. Call `completeSSO` with the `codeB`
5. Check `success` and `error` properties in the callback to ensure everything is ok

###### Example
```javascript
// 2
SpotIMAPI.startSSO()
    .then(response => {
        console.log(response);
    })
    .catch(error => {
        console.error(error);
    })

// 4
SpotIMAPI.completeSSO("<CODE_B>")
    .then(response => {
        console.log(response);
    })
    .catch(error => {
        console.error(error);
    })
```


##### SSO with JWT secret

1. Authenticate a user with your backend
2. Call `sso(JWTSecret)` function with a user JWT secret
3. If there’s no error in the callback and `response?.success` is true, the authentication process finished successfully

###### Example
```javascript
SpotIMAPI.sso("<SECRET_JWT>")
    .then(response => {
        console.log(response);
      })
    .catch(error => {
        console.error(error);
      })
```

##### Logout
Call SpotIm logout API whenever a user logs out of your system

###### Example
```javascript
SpotIMAPI.logout();
```

##### Login status
An API to understand the status of the current SpotIm user.
Guest - Means this is a guest unregistered user. You should call startSSO/sooWithJWT if your own login status is 'user is logged in'
LoggedIn - Mean this is a registered user of SpotIm. You should avoid calling startSSO/sooWithJWT in this case. If you own status is 'user is logged out', you should SpotIm logout method

###### Example
```javascript
SpotIMAPI.getUserLoginStatus()
    .then(status => {
        console.log(status);
      })
    .catch(error => {
        console.error(error);
      })
```

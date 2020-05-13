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
    `npm install react-native-spotim --save`
2. Import Spot.IM modules:
    `import { SpotIM, SpotIMEventEmitter } from 'react-native-spotim';`

### Use Spot.IM native view
### iOS

The default React-Native root view controller is an instance of UIViewController.
Spot.IM is using UINavigationController no navigate to native view controllers.
To support native navigation wrap the app with a navigation controller in your `AppDelegate.m`:
```obj-c
...
UIViewController *rootViewController = [UIViewController new];
self.navControll = [[UINavigationController alloc] initWithRootViewController:rootViewController];
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
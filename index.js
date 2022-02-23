import { Dimensions, NativeEventEmitter, NativeModules, PixelRatio, Platform, UIManager, findNodeHandle, requireNativeComponent } from 'react-native';

import PropTypes from 'prop-types';
import React from 'react';

const ISIOS = Platform.OS === "ios";

export const SpotIMModule = NativeModules.SpotIM;
const SpotIMEvents = NativeModules.SpotIMEvents;
export const SpotIMEventEmitter = new NativeEventEmitter(SpotIMEvents);

export class SpotIM extends React.Component {

    nativeComponentRef;
    lastHeightUpdate = 0;
    heightUpdateTimestamp;

    constructor(props) {
        super(props);
        this._onChange = this._onChange.bind(this);
    }

    componentDidMount() {
        if (ISIOS) {
            SpotIMEventEmitter.addListener('viewHeightDidChange', (event) => {
                this.setState({height: event['newHeight']});
            });
        } else {
            this.loadConversationAndroid()
        }
    }

    loadConversationAndroid() {
      this.setState({ height: 0 });
      this.lastHeightUpdate = 0;
      this.dispatchCreateCommandAndroid();
      this.setState({ loading: true });
      this.heightUpdateTimestamp = Date.now() / 1000;
      setTimeout(() => {
          this.setState({ loading: false });
      }, 2500);
    }

    dispatchCreateCommandAndroid() {
        const androidViewId = findNodeHandle(this.nativeComponentRef);
        UIManager.dispatchViewManagerCommand(
          androidViewId,
          UIManager.SpotIM.Commands.create.toString(),
          [androidViewId]
        );
    }
    _onChange(event: Event) {
        const newHeight = event.nativeEvent.height / PixelRatio.get();
        const heightDiff = Math.abs(newHeight - this.lastHeightUpdate);
        if ((!this.lastHeightUpdate || heightDiff != 0)) {
            this.lastHeightUpdate = newHeight;
            if (!this.state.height ||
                this.state.height < newHeight ||
                Date.now() / 1000 - this.heightUpdateTimestamp > 5) {
                this.setState({ height: newHeight });
            }
            this.heightUpdateTimestamp = Date.now() / 1000;
        }

    }
    componentWillUnmount() {
        if (ISIOS) {
            SpotIMEventEmitter.removeAllListeners("viewHeightDidChange")
        }
    }

    componentDidUpdate(prevProps) {
      if (!ISIOS && (prevProps.postId != this.props.postId)) {
        this.loadConversationAndroid()
      }
    }

    render() {
        return <RNSpotIM
                {...this.props}
                onChange={this._onChange}
                ref={(nativeRef) => this.nativeComponentRef = nativeRef}
                style={{alignSelf: 'stretch', height: this.state && this.state.height ? Number(this.state.height) : 0, opacity: this.state && this.state.loading ? 0 : 1}} />;
    }
}

export class SpotIMAPI {
    static init = (spotId) => {
        SpotIMModule.initWithSpotId(spotId)
    }
    static startSSO = () => {
        return new Promise((resolve, reject) => {
            const successSubscription = SpotIMEventEmitter.addListener('startSSOSuccess', (response) => {
                successSubscription.remove();
                failureSubscription.remove();
                resolve(response);
            });

            const failureSubscription = SpotIMEventEmitter.addListener('startSSOFailed', (event) => {
                successSubscription.remove();
                failureSubscription.remove();
                reject(event);
            });

            SpotIMModule.startSSO();
        })
    }
    static completeSSO = (str) => {
        return new Promise((resolve, reject) => {
            const successSubscription = SpotIMEventEmitter.addListener('completeSSOSuccess', (response) => {
                successSubscription.remove();
                failureSubscription.remove();
                resolve(response);
            });

            const failureSubscription = SpotIMEventEmitter.addListener('completeSSOFailed', (event) => {
                successSubscription.remove();
                failureSubscription.remove();
                reject(event);
            });

            SpotIMModule.completeSSO(str);
        })
    }
    static sso = (jwt) => {
        return new Promise((resolve, reject) => {
            const successSubscription = SpotIMEventEmitter.addListener('ssoSuccess', (response) => {
                successSubscription.remove();
                failureSubscription.remove();
                resolve(response);
            });

            const failureSubscription = SpotIMEventEmitter.addListener('ssoFailed', (event) => {
                successSubscription.remove();
                failureSubscription.remove();
                reject(event);
            });

            SpotIMModule.ssoWithJwtSecret(jwt);
        })
    }
    static getUserLoginStatus = () => {
        return new Promise((resolve, reject) => {
            const successSubscription = SpotIMEventEmitter.addListener('getUserLoginStatusSuccess', (response) => {
                successSubscription.remove();
                failureSubscription.remove();
                resolve(response);
            });

            const failureSubscription = SpotIMEventEmitter.addListener('getUserLoginStatusFailed', (event) => {
                successSubscription.remove();
                failureSubscription.remove();
                reject(event);
            });

            SpotIMModule.getUserLoginStatus();
        })
    }
    static logout = () => {
        return new Promise((resolve, reject) => {
            const successSubscription = SpotIMEventEmitter.addListener('logoutSuccess', (response) => {
                successSubscription.remove();
                failureSubscription.remove();
                resolve(response);
            });

            const failureSubscription = SpotIMEventEmitter.addListener('logoutFailed', (event) => {
                successSubscription.remove();
                failureSubscription.remove();
                reject(event);
            });

            SpotIMModule.logout();
        })
    }
    static showFullConversation = () => {
      SpotIMModule.showFullConversation()
    }
    static setIOSDarkModeEnabled = (isEnabled) => {
      if (ISIOS) {
        SpotIMModule.setIsDarkModeEnabled(isEnabled)
      }
    }
}

SpotIM.propTypes = {
    postId: PropTypes.string,
    url: PropTypes.string,
    title: PropTypes.string,
    subtitle: PropTypes.string,
    thumbnailUrl: PropTypes.string
};

var RNSpotIM = requireNativeComponent('SpotIM', SpotIM, {
    nativeOnly: {onChange: true}
});

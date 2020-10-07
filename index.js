import { Dimensions, NativeEventEmitter, NativeModules, Platform, UIManager, findNodeHandle, requireNativeComponent, PixelRatio } from 'react-native';

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
        SpotIMModule.initWithSpotId(this.props.spotId);

        if (ISIOS) {
            SpotIMEventEmitter.addListener('viewHeightDidChange', (event) => {
                this.setState({height: event['newHeight']});
            });
        } else {
            this.create();
            this.setState({ loading: true });
            this.heightUpdateTimestamp = Date.now() / 1000;
            setTimeout(() => {
                this.setState({ loading: false });
            }, 2500);
        }  
    }
    create = () => {
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
        return SpotIMModule.initWithSpotId(spotId)
    }
    static startSSO = () => {
        return SpotIMModule.startSSO();
    }
    static completeSSO = (str) => {
        return SpotIMModule.completeSSO(str);
    }
    static sso = (jwt) => {
        return SpotIMModule.ssoWithJwtSecret(jwt);
    }
    static getUserLoginStatus = () => {
        return SpotIMModule.getUserLoginStatus();
    }
    static logout = () => {
        return SpotIMModule.logout();
    }
}

SpotIM.propTypes = {
    spotId: PropTypes.string,
    postId: PropTypes.string,
    url: PropTypes.string,
    title: PropTypes.string,
    subtitle: PropTypes.string,
    thumbnailUrl: PropTypes.string
};

var RNSpotIM = requireNativeComponent('SpotIM', SpotIM, {
    nativeOnly: {onChange: true}
});
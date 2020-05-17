import React from 'react';
import { requireNativeComponent, NativeModules, NativeEventEmitter } from 'react-native';
import PropTypes from 'prop-types';

export const SpotIMModule = NativeModules.SpotIM;
const SpotIMEvents = NativeModules.SpotIMEvents;
export const SpotIMEventEmitter = new NativeEventEmitter(SpotIMEvents);

export class SpotIM extends React.Component {
    componentDidMount() {
        SpotIMModule.initWithSpotId(this.props.spotId);

        SpotIMEventEmitter.addListener('viewHeightDidChange', (event) => {
            this.setState({height: event['newHeight']});
        });
    }
    render() {
        return <RNSpotIM {...this.props} style={{alignSelf: 'stretch', height: this.state && this.state.height ? Number(this.state.height) : 0}} />;
    }
}

export class SpotIMAPI {
    static startSSO = () => {
        return SpotIMModule.startSSO();
    }
    static completeSSO = (str) => {
        return SpotIMModule.completeSSO(str);
    }
    static sso = (jwt) => {
        return SpotIMModule.sso(jwt);
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

var RNSpotIM = requireNativeComponent('SpotIM', SpotIM);
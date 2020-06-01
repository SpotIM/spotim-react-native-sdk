import React from 'react';
import { requireNativeComponent, NativeModules, NativeEventEmitter, Platform, findNodeHandle, UIManager, Dimensions } from 'react-native';
import PropTypes from 'prop-types';

const ISIOS = Platform.OS === "ios";

export const SpotIMModule = NativeModules.SpotIM;
const SpotIMEvents = NativeModules.SpotIMEvents;
export const SpotIMEventEmitter = new NativeEventEmitter(SpotIMEvents);

export class SpotIM extends React.Component {

    nativeComponentRef;

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
            setTimeout(() => {
                this.create();
            }, 3000);
        }  
    }
    create = () => {
        const androidViewId = findNodeHandle(this.nativeComponentRef);
        UIManager.dispatchViewManagerCommand(
          androidViewId,
          UIManager.SpotIM.Commands.create.toString(),
          [androidViewId]
        );

        setTimeout(() => {
            this.setState({ height: Dimensions.get('window').height });
        }, 2000);
    }
    _onChange(event: Event) {
        this.setState({ height: event.nativeEvent.height / 2 });
      }
    render() {
        return <RNSpotIM
                {...this.props}
                onChange={this._onChange}
                ref={(nativeRef) => this.nativeComponentRef = nativeRef}
                style={{alignSelf: 'stretch', height: this.state && this.state.height ? Number(this.state.height) : 0}} />;
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
import React from 'react';
import { requireNativeComponent, NativeModules, NativeEventEmitter } from 'react-native';
import PropTypes from 'prop-types';

const SpotIMModule = NativeModules.SpotIM;
const SpotIMEvents = NativeModules.SpotIMEvents;
const SpotIMEventEmitter = new NativeEventEmitter(SpotIMEvents);

class SpotIM extends React.Component {
    componentDidMount() {
        SpotIMModule.initWithSpotId(this.props.spotId);

        SpotIMEventEmitter.addListener('viewHeightDidChange', (event) => {
            this.setState({height: event['newHeight']});
        });
    }
    render() {
        return <RNSpotIM {...this.props} style={{height: this.state && this.state.height ? Number(this.state.height) : 0}} />;
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

module.exports = { SpotIM, SpotIMEventEmitter };

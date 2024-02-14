import { PixelRatio, Platform, UIManager, findNodeHandle, requireNativeComponent } from 'react-native';
import { SpotIMEventEmitter } from './SpotIMEventEmitter';

import PropTypes from 'prop-types';
import React from 'react';

const ISIOS = Platform.OS === "ios";

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
        this.setState({ height: event['newHeight'] });
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
  _onChange(event) {
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
      style={{ alignSelf: 'stretch', height: this.state && this.state.height ? Number(this.state.height) : 0, opacity: this.state && this.state.loading ? 0 : 1 }} />;
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
  nativeOnly: { onChange: true }
});
import { StyleSheet, ScrollView, View, Text, Button } from 'react-native';
import React, { Component } from 'react';
import { SpotIMEventEmitter } from '@spot.im/react-native-spotim';
import * as AuthProvider from '../AuthProvider';
export default class MainScreen extends Component {
  constructor(props) {
    super(props);
    this.spotIds = [
      {
        displayName: 'Demo Spot',
        id: 'sp_eCIlROSD',
      },
      {
        displayName: 'sp_mobileGuest',
        id: 'sp_mobileGuest',
      },
    ];
  }

  componentDidMount() {
    const onStartLoginFlow = event => {
      console.log('onStartLoginFlow');
      // Load here login view
      this.props.navigation.navigate('Login');
    };
    const subscription = SpotIMEventEmitter.addListener(
      'startLoginFlow',
      onStartLoginFlow,
    );

    const renewSSOAuthentication = userId => {
      // TODO - renew SSO authentication
      console.log('renewSSOAuthentication, userId: ' + userId);
      AuthProvider.login()
    };

    const subscriptionRenewSSOAuthentication = SpotIMEventEmitter.addListener(
      'renewSSOAuthentication',
      renewSSOAuthentication,
    );
  }

  render() {
    return (
      <ScrollView style={styles.container}>
        <View style={{ marginTop: 10 }} />
        <Text style={styles.welcome}>Spot.IM React-Native Demo App</Text>
        {this.spotIds.map(spot => this.getSpotButton(spot))}
      </ScrollView>
    );
  }

  getSpotButton(spot) {
    return (
      <Button
        key={spot.id}
        title={spot.displayName}
        onPress={() => {
          this.props.navigation.navigate('Articles', { spotId: spot.id });
        }}
      />
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginVertical: 30,
  },
  welcome: {
    fontSize: 24,
    color: 'blue',
    textAlign: 'center',
    marginTop: 40,
    marginBottom: 20,
  },
});

/**
 * Sample React Native App
 *
 * adapted from App.js generated by the following command:
 *
 * react-native init example
 *
 * https://github.com/facebook/react-native
 */

import { Platform, ScrollView, StyleSheet, Text } from 'react-native';
import React, { Component } from 'react';
import { SpotIM, SpotIMAPI, SpotIMEventEmitter } from '@spot.im/react-native-spotim';

export default class App extends Component<{}> {
  render() {
    const onStartLoginFlow = (event) => {
      // Load here login view
    }
    const subscription = SpotIMEventEmitter.addListener('startLoginFlow', onStartLoginFlow);

    return (
      <ScrollView style={styles.container}>
        <Text style={styles.welcome}>Spot.IM React-Native Demo App</Text>
        <Text>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</Text>
        <SpotIM
          spotId="sp_eCIlROSD"
          postId="sdk1"
          url="http://www.spotim.name/bd-playground/post9.html"
          title="Spot.IM is aiming for the stars!"
          subtitle=""
          thumbnailUrl="https://images.spot.im/v1/production/trqsvhyviejd0bfp2qlp"
          style={{flex: 1}} />
      </ScrollView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginVertical: 30,
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    marginTop: 40,
  },
});

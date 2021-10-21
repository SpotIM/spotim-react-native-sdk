import { Platform, ScrollView, StyleSheet, Text, View, Button } from 'react-native';
import React, { Component } from 'react';
import { SpotIM, SpotIMAPI, SpotIMEventEmitter } from '@spot.im/react-native-spotim';
import ArticlesScreen from './ArticlesScreen.js'
export default class MainScreen extends Component {
  constructor(props) {
    super(props)
    this.spotIds = [{
      displayName: "Demo Spot",
      id: "sp_eCIlROSD"
    }]
  }

  render() {
    return (
      <ScrollView style={styles.container}>
        <View style={{marginTop: 30}} />
        <Text style={styles.welcome}>Spot.IM React-Native Demo App</Text>
        {this.spotIds.map((spot) =>
          this.getSpotButton(spot)
        )}
      </ScrollView>
    );
  }

  getSpotButton(spot) {
    return (
      <Button key={spot.id} title={spot.displayName} onPress={() => {
        debugger
        this.props.navigation.navigate('Articles', {spotId: spot.id})
      }}/>
    )
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

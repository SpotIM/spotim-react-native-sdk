import { Platform, ScrollView, StyleSheet, Text, View, Button } from 'react-native';
import React, { Component } from 'react';
import { SpotIM, SpotIMAPI, SpotIMEventEmitter } from '@spot.im/react-native-spotim';

export default class ArticlesScreen extends Component {
  constructor(props) {
    super(props)
    // const spotId = this.props.route.params.spotId
    this.articleId = this.props.route.params.articleId
  }

  render() {
    return (
      <ScrollView style={styles.container}>
        <View style={{marginTop: 30}} />
        <Text style={{margin:10}}>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</Text>
        <View style={{marginTop: 30}} />
          <SpotIM
            postId={this.articleId}
            url="http://www.spotim.name/bd-playground/post9.html" //TODO
            title="Spot.IM is aiming for the stars!" //TODO
            subtitle="" //TODO
            thumbnailUrl="https://images.spot.im/v1/production/trqsvhyviejd0bfp2qlp" //TODO
            showLoginScreenOnRootScreen={true}
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
    fontSize: 24,
    color: 'blue',
    textAlign: 'center',
    marginTop: 40,
    marginBottom: 20,
  },
});

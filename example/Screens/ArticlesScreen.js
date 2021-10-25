import { Platform, ScrollView, StyleSheet, Text, View, Button } from 'react-native';
import React, { Component } from 'react';
import { SpotIM, SpotIMAPI, SpotIMEventEmitter } from '@spot.im/react-native-spotim';

export default class ArticlesScreen extends Component {
  constructor(props) {
    super(props)
    const spotId = this.props.route.params.spotId
    // TODO - clean from previus spotId if exsist
    SpotIMAPI.init(spotId)

    this.articles = ["sdk1", "sdk2", "sdk3"]
  }

  render() {
    return (
      <ScrollView style={{flex: 1}}>
      {this.articles.map(articleId => this.getArticleButton(articleId))}
      <Button style={{marginTop: 30}} title="Login Screen" onPress={() => this.props.navigation.navigate('Login')}/>
      </ScrollView>
    );
  }

  getArticleButton(articleId) {
    return (
      <Button key={articleId} title={articleId} onPress={() => {
        // open article screen
        this.props.navigation.navigate('Article', {articleId: articleId})
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

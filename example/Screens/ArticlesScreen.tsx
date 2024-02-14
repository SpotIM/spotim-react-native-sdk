import React, { useEffect } from 'react';
import { ScrollView, Button, View } from 'react-native';
import { SpotIMAPI } from '@spot.im/react-native-spotim';

const ArticlesScreen = (props: any) => {

  const articles = ['sdk1', 'sdk2', 'sdk3'];

  const spotId = props.route.params.spotId;

  useEffect(() => {
    SpotIMAPI.init(spotId);
  }, []);



  const getArticleButton = (articleId: string) => {
    return (
      <Button
        key={articleId}
        title={articleId}
        onPress={() => {
          // open article screen
          props.navigation.navigate('Article', { articleId: articleId });
        }}
      />
    );
  }

  return (
    <ScrollView style={{ flex: 1 }}>
      {articles.map(articleId => getArticleButton(articleId))}
      <View style={{ marginTop: 30 }}>
        <Button
          title="Login Screen"
          onPress={() => props.navigation.navigate('Login')}
        />
      </View>
    </ScrollView>
  );
}

export default ArticlesScreen;
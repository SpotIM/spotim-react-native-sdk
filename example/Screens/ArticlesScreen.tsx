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

  const getOpenFullConversationButton = () => {
    return (
      <Button
        title="Open Full Conversation"
        onPress={() => {
          // open full conversation
          SpotIMAPI.openFullConversation({
            postId: "sdk1",
            url: "http://www.spotim.name/bd-playground/post9.html",
            title: "Spot.IM is aiming for the stars!",
            subtitle: "",
            thumbnailUrl: "https://images.spot.im/v1/production/trqsvhyviejd0bfp2qlp"
          });
        }}
      />
    );
  }

  const getLoginButton = () => {
    return (
      <View style={{ marginTop: 30 }}>
        <Button
          title="Login Screen"
          onPress={() => {
            // open login screen
            props.navigation.navigate('Login');
          }}
        />
      </View>
    );
  }

  return (
    <ScrollView style={{ flex: 1 }}>
      {articles.map(articleId => getArticleButton(articleId))}
      {getOpenFullConversationButton()}
      {getLoginButton()}
    </ScrollView>
  );
}

export default ArticlesScreen;
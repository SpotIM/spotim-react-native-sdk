import React, { useEffect, useState } from 'react';
import { ScrollView, Button, View, ActivityIndicator } from 'react-native';
import { SpotIMAPI } from '@spot.im/react-native-spotim';

const ArticlesScreen = (props: any) => {
  const [isLoading, setIsLoading] = useState(false);

  const articles = ['sdk1', 'sdk2', 'sdk3'];

  const spotId = props.route.params.spotId;

  useEffect(() => {
    SpotIMAPI.init(spotId);
  }, []);

  const openFullConversation = async () => {
    try {
      setIsLoading(true);
      await SpotIMAPI.openFullConversation({
        postId: "sdk1",
        url: "http://www.spotim.name/bd-playground/post9.html",
        title: "Spot.IM is aiming for the stars!",
        subtitle: "",
        thumbnailUrl: "https://images.spot.im/v1/production/trqsvhyviejd0bfp2qlp"
      });
      setIsLoading(false);
    } catch (error) {
      setIsLoading(false);
      // handle error
    }
  };

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
        onPress={openFullConversation}
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
      {isLoading && (
        <ActivityIndicator style={{ paddingTop: 20 }} color="blue" />
      )}
      {getLoginButton()}
    </ScrollView>
  );
}

export default ArticlesScreen;
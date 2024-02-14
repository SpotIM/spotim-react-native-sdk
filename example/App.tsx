import React, { useEffect } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import 'react-native-gesture-handler';
import { SpotIMEventEmitter } from '@spot.im/react-native-spotim';

import MainScreen from './Screens/MainScreen';
import ArticlesScreen from './Screens/ArticlesScreen';
import ArticleScreen from './Screens/ArticleScreen';
import LoginScreen from './Screens/LoginScreen';

const Stack = createStackNavigator();
const App = () => {

  const onTrackAnalyticsEvent = (event: any) => {
    console.log('\n', event.type, '\n', event);
  }

  useEffect(() => {
    SpotIMEventEmitter.addListener(
      'trackAnalyticsEvent',
      onTrackAnalyticsEvent,
    );

    return () => {
      SpotIMEventEmitter.removeAllListeners('trackAnalyticsEvent');
    }
  }, []);

  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Home">
        <Stack.Screen name="Home" component={MainScreen} />
        <Stack.Screen name="Articles" component={ArticlesScreen} />
        <Stack.Screen name="Article" component={ArticleScreen} />
        <Stack.Screen name="Login" component={LoginScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}

export default App;
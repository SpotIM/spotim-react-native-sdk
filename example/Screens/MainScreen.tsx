import React, { useEffect } from 'react';
import { StyleSheet, ScrollView, View, Text, Button } from 'react-native';
import { SpotIMEventEmitter } from '@spot.im/react-native-spotim';
import * as AuthProvider from '../AuthProvider';

const MainScreen = (props: any) => {
  const spotIds = [
    {
      displayName: 'Demo Spot',
      id: 'sp_eCIlROSD',
    },
    {
      displayName: 'sp_mobileGuest',
      id: 'sp_mobileGuest',
    },
  ];

  useEffect(() => {
    const onStartLoginFlow = () => {
      console.log('onStartLoginFlow');
      // Load here login view
      props.navigation.navigate('Login');
    };

    SpotIMEventEmitter.addListener(
      'startLoginFlow',
      onStartLoginFlow,
    );

    const renewSSOAuthentication = (userId: string) => {
      // TODO - renew SSO authentication
      console.log('renewSSOAuthentication, userId: ' + userId);
      AuthProvider.login()
    };

    SpotIMEventEmitter.addListener(
      'renewSSOAuthentication',
      renewSSOAuthentication,
    );
  }, []);

  const getSpotButton = (spot: any) => {
    return (
      <Button
        key={spot.id}
        title={spot.displayName}
        onPress={() => {
          props.navigation.navigate('Articles', { spotId: spot.id });
        }}
      />
    );
  }

  return (
    <ScrollView style={styles.container}>
      <View style={{ marginTop: 10 }} />
      <Text style={styles.welcome}>Spot.IM React-Native Demo App</Text>
      {spotIds.map(spot => getSpotButton(spot))}
    </ScrollView>
  );
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

export default MainScreen;
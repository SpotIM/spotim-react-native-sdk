import React, { useEffect, useState } from 'react';
import {
  ActivityIndicator,
  StyleSheet,
  Text,
  View,
  Button,
} from 'react-native';
import { SpotIMAPI } from '@spot.im/react-native-spotim';
import * as AuthProvider from '../AuthProvider';

const LoginScreen = (props: any) => {
  const [userStatus, setUserStatus] = useState<any>();
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    updateStatus();
  }, []);

  const updateStatus = async () => {
    const status = await AuthProvider.getUserStatus();
    setUserStatus(status);
  }

  const onLogoutClicked = async () => {
    setIsLoading(true);
    try {
      const response: any = await SpotIMAPI.logout()
      setIsLoading(false);
      updateStatus();
      console.log('Logout success: ' + response.success);
    } catch (error) {
      setIsLoading(false);
      updateStatus();
      console.log('Logout error: ' + error);
    }
  }

  const onLoginClicked = async () => {
    //Login
    setIsLoading(true);

    try {
      const res = await AuthProvider.login();
      console.log('Login success: ' + res);
      setIsLoading(false);
      props.navigation.pop();
    } catch (error) {
      console.log('Login error: ' + error);
      setIsLoading(false);
    }
  }

  return (
    <View>
      <Button onPress={onLoginClicked} title={'Login'} />
      <Button onPress={onLogoutClicked} title={'Logout'} />
      {isLoading && (
        <ActivityIndicator style={{ paddingTop: 20 }} color="blue" />
      )}
      <Text style={styles.text}>User Status: {userStatus}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginVertical: 30,
  },
  text: {
    fontSize: 20,
    textAlign: 'center',
    marginTop: 40,
    marginBottom: 20,
  },
});

export default LoginScreen;
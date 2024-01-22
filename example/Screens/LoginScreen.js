import {
  ActivityIndicator,
  Platform,
  StyleSheet,
  Text,
  View,
  Button,
} from 'react-native';
import React, { Component } from 'react';
import { SpotIMAPI } from '@spot.im/react-native-spotim';
import {
  ANDROID_SSO_ENDPOINT_LOGIN,
  SSO_ENDPOINT_LOGIN,
  USERNAME,
  PASSWORD,
} from '../Consts';
import * as AuthProvider from '../AuthProvider';
import axios from 'axios';

export default class LoginScreen extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoading: false,
    };
    this.onLoginClicked = this.onLoginClicked.bind(this);
    this.onLogoutClicked = this.onLogoutClicked.bind(this);
    this.updateStatus = this.updateStatus.bind(this);
  }

  componentDidMount() {
    this.updateStatus();
  }

  updateStatus() {
    AuthProvider.getUserStatus().then(status => {
      this.setState({ userStatus: status });
    });
  }

  render() {
    return (
      <View>
        <Button onPress={this.onLoginClicked} title={'Login'} />
        <Button onPress={this.onLogoutClicked} title={'Logout'} />
        {this.state.isLoading && (
          <ActivityIndicator style={{ paddingTop: 20 }} color="blue" />
        )}
        <Text style={styles.text}>User Status: {this.state.userStatus}</Text>
      </View>
    );
  }

  onLogoutClicked() {
    this.setState({ isLoading: true });
    SpotIMAPI.logout()
      .then(response => {
        this.setState({ isLoading: false });
        this.updateStatus();
        console.log('Logout success: ' + response.success);
      })
      .catch(error => {
        this.setState({ isLoading: false });
        this.updateStatus();
        console.log('Logout error: ' + error);
      });
  }

  async onLoginClicked() {
    //Login
    this.setState({ isLoading: true });

    try {
      const res = await AuthProvider.login();
      console.log('Login success: ' + res);
      this.setState({ isLoading: false });
      this.props.navigation.pop();
    } catch (error) {
      console.log('Login error: ' + error);
      this.setState({ isLoading: false });
    }
  }
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

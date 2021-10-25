import { Platform, ScrollView, StyleSheet, Text, View, Button } from 'react-native';
import React, { Component } from 'react';
import { SpotIM, SpotIMAPI, SpotIMEventEmitter } from '@spot.im/react-native-spotim';

export default class LoginScreen extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <View>
        <Button onPress={this.onLoginClicked} title={"Login"}/>
        <Button title={"Logout - TODO"}/>
      </View>
    );
  }

  onLoginClicked() {
    // COMPLETE SSO FLOW
    const Http = new XMLHttpRequest();
    const url=SSO_ENDPOINT_BASE_URL+SSO_ENDPOINT_LOGIN;
    Http.open("POST", url);
    Http.setRequestHeader("content-type","application/json");
    Http.send(JSON.stringify({
      "username":USERNAME,
      "password":PASSWORD
    }));
    
    Http.onreadystatechange=(e) => {
      if(Http.readyState == 4) {
        console.log(Http.responseText);
        const json = JSON.parse(Http.responseText);
        const userToken = json.token
        console.log("user token: " + userToken);
        SpotIMAPI.startSSO()
        .then((data) => {
          console.log("SpotIm: Succees for SSO: ");
          console.log("SpotIm: Code: " + data.code_a);

          const Http = new XMLHttpRequest();
          const url=SSO_ENDPOINT_BASE_URL+SSO_ENDPOINT_CODE_B;
          Http.open("POST", url);
          Http.setRequestHeader("access-token-network", SPOT_ACCESS_TOKEN);
          Http.setRequestHeader("content-type","application/json");
          Http.send(JSON.stringify({
            "code_a":data.code_a,
            "access_token":userToken,
            "username":USERNAME,
            "environment":"production"
          }));
          Http.onreadystatechange=(e) => {
            if(Http.readyState == 4) {
              const json = JSON.parse(Http.responseText);
              console.log("Got code B: ");
              console.log(json)
              SpotIMAPI.completeSSO(json.code_b)
              .then((response) => {
                console.log("SpotIm: " + response.success);
              })
              .catch((error) => {
                console.log("SpotIm: " + error);
              })
            }
          }
        })
        .catch((error) => {
          console.log("SpotIm: Api call error: " + error);
        });
      }
    }
  }


  // SSO WITH JWT
  // SpotIMAPI.sso(JWT_TOKEN)
  // .then((data) => {
  //   console.log("Succees for SSO: ");
  //   console.log(data.success);
  // }).catch((error)=>{
  //   console.log("Api call error: " + error.error);
  // });

  // LOGOUT
  // SpotIMAPI.logout()
  // .then((response) => {
  //   console.log("Logout success: " + response.success);
  // })
  // .catch((error) => {
  //   console.log("Logout error: " + error);
  // });

  // // GET USER STATUS
  // SpotIMAPI.getUserLoginStatus()
  // .then((response) => {
  //   console.log("User status is: " + response.status);
  // })
  // .catch((error) => {
  //   console.log("User status error: ");
  //   console.log(error);
  // });

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
